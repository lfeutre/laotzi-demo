(defmodule laotzi-demo-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0)
          (start 0))
  ;; Supervisor callbacks
  (export (init 1))
  ;; Other
  (export (add 0) (add 1)
          (get-children 0)
          (get-child-pids 0)
          (enable-stats 0)
          (get-child-stats 0)
          (sort-stats 1) (sort-stats 2)
          (get-stat 1)
          (get-least 0)
          (get-most 0)
          (get-least-pid 0)
          (get-most-pid 0)
          (get-least-most 0)
          (get-reductions 0)
          (save-reductions 0)
          (execute-tasks 0)
          (do-random-work 0)
          (start-tracking 0)
          (randpid 0)))

(defun server-name () (MODULE))
(defun callback-module () (MODULE))
(defun worker-mod () 'laotzi-demo-server)
(defun init-args () '())
(defun register-name () `#(local ,(server-name)))
(defun max-terminations () 10)
(defun termination-window () 60)
(defun restart-strategy () 'simple_one_for_one)
(defun restart-data () `#(,(restart-strategy)
                          ,(max-terminations)
                          ,(termination-window)))

;;; supervisor implementation

(defun start ()
  (start_link))

(defun start_link ()
  (supervisor:start_link (register-name)
                         (callback-module)
                         (init-args)))

(defun stop ()
  (exit (whereis (server-name)) 'shutdown))

;;; callback implementation

(defun init (_args)
  `#(ok #(,(restart-data)
          ,(get-children-setup))))

(defun get-children-setup ()
  `(,(get-child-spec (worker-mod))))

(defun get-child-spec (mod)
  (let* ((start-mod mod)
         (start-func 'start_link)
         (start-args '())
         (start-data `#(,start-mod ,start-func ,start-args))
         (restart-type 'temporary)
         (shutdown-time 'brutal_kill)
         (upgrade-modules `(,mod)))
    `#(,mod
       ,start-data
       ,restart-type
       ,shutdown-time
       worker
       ,upgrade-modules)))

(defun add ()
  (supervisor:start_child
    (server-name)
    '()))

(defun add (count)
  (lists:map (lambda (_) (add)) (lists:seq 1 count))
  'ok)

(defun get-children ()
  (supervisor:which_children (server-name)))

(defun get-child-pids ()
  (lists:map
   (lambda (x)
     (element 2 x))
   (get-children)))

(defun enable-stats ()
  (sys:statistics (server-name) 'true)
  (lists:map (lambda (pid) (sys:statistics pid 'true)) (get-child-pids))
  'ok)

(defun get-child-stats (pid)
  (case (sys:statistics pid 'get)
    (`#(ok ,data) data)
    (x x)))

(defun get-child-stats ()
  (lists:map
   (lambda (pid)
     (++ (get-child-stats pid) `(#(pid ,pid))))
   (get-child-pids)))

(defun sort-stats (key)
  (sort-stats key (get-child-stats)))

(defun sort-stats (key stats)
  (lists:sort
   (lambda (a b)
     (if (< (proplists:get_value key a)
            (proplists:get_value key b))
       'true
       'false))
   stats))

(defun get-least ()
  (car (sort-stats 'reductions)))

(defun get-most ()
  (car (lists:reverse (sort-stats 'reductions))))

(defun get-least-pid ()
  (proplists:get_value 'pid (get-least)))

(defun get-most-pid ()
  (proplists:get_value 'pid (get-most)))

(defun get-least-most ()
  (get-head-tail (sort-stats 'reductions)))

(defun get-head-tail
  ((`(,head . ,tail))
   `(,head ,(car (lists:reverse tail)))))

(defun get-stat (stat-key)
  (lists:map
    (lambda (x)
      (lists:foldl
        #'proplists:get_value/2
        x
        `(,stat-key)))
    (get-child-stats)))

(defun get-reductions ()
  (get-stat 'reductions))

(defun save-reductions ()
  (laotzi-demo-util:write-data (get-reductions)))

(defun execute-tasks ()
  (timer:apply_interval
    (get-execution-time)
    (MODULE)
    'do-random-work
    '()))

(defun get-execution-time ()
  (+ (laotzi-demo-server:rand 2000) 500))

(defun do-random-work ()
  (laotzi-demo-server:fac
    (randpid)
    (laotzi-demo-server:rand 1000)))

(defun start-tracking ()
  (timer:apply_interval 5000 (MODULE) 'save-reductions '()))

(defun randpid ()
  (let* ((pids (get-child-pids))
         (len (length pids))
         (pid-idx (laotzi-demo-server:rand len)))
    (lists:nth pid-idx pids)))