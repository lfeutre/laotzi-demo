(defmodule laotzi-demo-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'laotzi-demo))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(laotzi-demo ,(get-version)))))
