(defmodule laotzi-demo
  (behaviour application)
  (export (start 0) (start 2)
          (stop 1)
          (add 0) (add 1)
          (get-children 0)
          (get-child-pids 0)
          (enable-stats 0)
          (get-child-stats 0)
          (get-reductions 0)
          (execute-tasks 0)
          (start-tracking 0)))

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

(defun add (count)
  (laotzi-demo-sup:add count))

(defun get-children ()
  (laotzi-demo-sup:get-children))

(defun get-child-pids ()
  (laotzi-demo-sup:get-child-pids))

(defun enable-stats ()
  (laotzi-demo-sup:enable-stats))

(defun get-child-stats ()
  (laotzi-demo-sup:get-child-stats))

(defun get-reductions ()
  (laotzi-demo-sup:get-reductions))

(defun execute-tasks ()
  (laotzi-demo-sup:execute-tasks))

(defun start-tracking()
  (laotzi-demo-sup:start-tracking))