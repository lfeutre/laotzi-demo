(defmodule laotzi-demo-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'laotzi-demo))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(laotzi-demo ,(get-version)))))

(defun generate-json (data)
  (ljson:encode
    (lists:map #'process-node/1
               (enumerate data))))

(defun process-node
  ((`#(,idx ,x))
   `(#(title ,(++ "Node " (integer_to_list idx)))
     #(value ,x))))

(defun enumerate (data)
  (element
    1
    (lists:mapfoldl #'enumerate-item/2 0 data)))

(defun enumerate-item (x acc)
  (let ((idx (+ 1 acc)))
    `#(#(,idx ,x) ,idx)))