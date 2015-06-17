(defmodule laotzi-demo
  (behaviour application)
  (export (start 0) (start 2)
          (stop 1)
          (add 0)
          (get-children 0)))

(defun start ()
  (application:start (MODULE)))

(defun start (_type _args)
  (laotzi-http:start)
  (let ((result (laotzi-demo-sup:start_link)))
    (case result
      (`#(ok ,pid)
        result)
      (_
        `#(error ,result)))))

(defun stop (state)
  'ok)

(defun add ()
  (laotzi-demo-sup:add))

(defun get-children ()
  (laotzi-demo-sup:get-children))