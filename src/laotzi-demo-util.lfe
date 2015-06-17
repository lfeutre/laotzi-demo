(defmodule laotzi-demo-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'laotzi-demo))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(laotzi-demo ,(get-version)))))

(defun write-fake (count)
  (file:write_file "www/data.json" (generate-fake count)))

(defun generate-fake (count)
  (let ((data (lists:map (lambda (_) (random:uniform)) (lists:seq 1 count))))
    (generate-json data)))

(defun generate-json (data)
  (ljson:encode
    (lists:map #'process-node/1
               (enumerate data))))

(defun process-node
  ((`#(,idx ,x))
   `(#(title ,(list_to_binary (++ "Node " (integer_to_list idx))))
     #(value ,x))))

(defun enumerate (data)
  (element
    1
    (lists:mapfoldl #'enumerate-item/2 0 data)))

(defun enumerate-item (x acc)
  (let ((idx (+ 1 acc)))
    `#(#(,idx ,x) ,idx)))