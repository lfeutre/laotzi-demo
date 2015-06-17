(defmodule laotzi-demo-server
  (behaviour gen_server)
  ;; API
  (export (start_link 0)
          (test-call 1)
          (test-cast 1))
  ;; gen_server callbacks
  (export (init 1)
          (handle_call 3)
          (handle_cast 2)
          (handle_info 2)
          (terminate 2)
          (code_change 3)))

(defun server-name () (MODULE))
(defun callback-module () (MODULE))
(defun initial-state () 0)
(defun genserver-opts () '())
(defun register-name () `#(local ,(server-name)))

;;; gen_server implementation

(defun start_link ()
  (start_link '()))

(defun start_link (_args)
  (gen_server:start_link(callback-module)
                         (initial-state)
                         (genserver-opts)))

(defun test-call (message)
  (gen_server:call
     (server-name) `#(test ,message)))

(defun test-cast (message)
  (gen_server:cast
     (server-name) `#(test ,message)))

;;; callback implementation

(defun init (initial-state)
  `#(ok ,initial-state))

(defun handle_call
  ((`#(test ,message) from state)
    (lfe_io:format "Call: ~p~n" (list message))
    `#(reply ok ,state))
  ((request from state)
    `#(reply ok ,state)))

(defun handle_cast
  ((`#(test ,message) state)
    (lfe_io:format "Cast: ~p~n" `(,message))
    `#(noreply ,state))
  ((message state)
    `#(noreply ,state)))

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
