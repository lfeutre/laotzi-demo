(defmodule laotzi-http
  (export all))

(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")

(defun start ()
  (lmug-barista-adapter:run
    #'dispatch-handler/1
    '(#(port 5099))))

(defun dispatch-handler
  ;; HTML
  (((= (match-request path "/") request))
   (home))
  (((= (match-request path "/index.html") request))
   (get-html request))
  ;; CSS
  (((= (match-request path "/css/style.css") request))
   (get-style request))
  (((= (match-request path "/css/svg.css") request))
   (get-style request))
  (((= (match-request path "/css/highlightjs.min.css") request))
   (get-style request))
  ;; JavaScript
  (((= (match-request path "/js/d3.min.js") request))
   (get-js request))
  (((= (match-request path "/js/circularHeatChart.js") request))
   (get-js request))
  (((= (match-request path "/js/lfe-proc-map.js") request))
   (get-js request))
  (((= (match-request path "/js/highlight.min.js") request))
   (get-js request))
  ;; Data
  (((= (match-request path "/data.json") request))
   (get-json request))
  ((request)
   (not-found request)))

(defun home ()
  (make-response
   status 200
   headers '(#("content-type" "text/html"))
   body (read-file "/index.html")))

(defun get-html (request)
  (make-response
   status 200
   headers '(#("content-type" "text/html"))
   body (read-file request)))

(defun get-style (request)
  (make-response
   status 200
   headers '(#("content-type" "text/css"))
   body (read-file request)))

(defun get-js (request)
  (make-response
   status 200
   headers '(#("content-type" "application/javascript"))
   body (read-file request)))

(defun get-json (request)
  (make-response
   status 200
   headers '(#("content-type" "application/json"))
   body "{data: \"Hello World\"}"))

(defun not-found (request)
  (io:format "Fields: ~p~n" (list (fields-request)))
  (io:format "Request: ~p~n" (list request))
  (make-response
   status 404
   headers '(#("content-type" "text/html"))
   body "<html><body><strong>Resource not found.</strong></body></html>"))

(defun read-file (request)
  (let* ((`#(ok ,content) (file:read_file (get-fullpath request))))
    (unicode:characters_to_list content)))

(defun get-fullpath (request)
  (let* ((`#(ok ,cwd) (file:get_cwd))
         (filename (++ cwd "/www" (extract-path request))))
    (io:format "cwd: ~p~n" `(,cwd))
    (io:format "filename: ~p~n" `(,filename))
    filename))

(defun extract-path
  ((path) (when (is_list path))
   path)
  ((path) (when (is_binary path))
   (binary_to_list path))
  ((request)
   (extract-path (request-path request))))
