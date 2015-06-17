(defmodule laotzi-demo-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0)
          (start 0))
  ;; Supervisor callbacks
  (export (init 1))
  ;; Other
  (export (add 0)
          (get-children 0)))

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

(defun get-children ()
  (supervisor:which_children (server-name)))