(defmodule laotzi-demo-server
  (behaviour gen_server)
  ;; API
  (export (start_link 0)
          (fac 2)
          (inc 2)
          (quad 2)
          (rand 0) (rand 1))
  ;; gen_server callbacks
  (export (init 1)
          (handle_call 3)
          (handle_info 2)
          (terminate 2)
          (code_change 3)))

(defun server-name () (MODULE))
(defun callback-module () (MODULE))
(defun initial-state () (now))
(defun genserver-opts () '())
(defun register-name () `#(local ,(server-name)))

;;; gen_server implementation

(defun start_link ()
  (start_link '()))

(defun start_link (_args)
  (gen_server:start_link (callback-module)
                         (initial-state)
                         (genserver-opts)))

(defun fac (pid integer)
  (gen_server:call
    pid `#(fac ,integer)))

(defun inc (pid integer)
  (gen_server:call
    pid `#(inc ,integer)))

(defun quad (pid integer)
  (gen_server:call
    pid `#(quad ,integer)))

(defun rand ()
  (gen_server:call (laotzi-demo-sup:get-least-pid) `#(rand)))

(defun rand (limit)
  (gen_server:call (laotzi-demo-sup:get-least-pid) `#(rand ,limit)))

;;; callback implementation

(defun init (initial-state)
  `#(ok ,initial-state))

(defun handle_call
  ((`#(fac ,integer) from state)
   `#(reply ,(laotzi-demo-util:factorial integer) ,state))
  ((`#(inc ,integer) from state)
   `#(reply ,(+ 1 integer) ,state))
  ((`#(quad ,integer) from state)
   `#(reply ,(* 4 integer) ,state))
  ((`#(rand) from state)
   (let ((`#(,rand ,new-seed) (random:uniform_s state)))
     `#(reply ,rand ,new-seed)))
  ((`#(rand ,limit) from state)
   (let ((`#(,rand ,new-seed) (random:uniform_s limit state)))
     `#(reply ,rand ,new-seed)))
  ((request from state)
   `#(reply ok ,state)))

(defun handle_info
  ((`#(EXIT ,caller normal) state-data)
   `#(noreply ,state-data))
  ((`#(EXIT ,caller ,reason) state-data)
   `#(noreply ,state-data))
  ((msg state-data)
   `#(noreply ,state-data)))

(defun terminate (_reason _state-data)
  'ok)

(defun code_change (old-version state extra)
  `#(ok ,state))
