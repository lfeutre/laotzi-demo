(defmodule laotzi-http
  (export all))

(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")

(defun dispatch-handler
  (((= (match-request path "/") request))
   (home))
  (((= (match-request path "/css/style.css") request))
   (style-css request))
  (((= (match-request path "/data.json") request))
   (data-json request))
  ((request)
   (not-found request)))

(defun run ()
  (lmug-barista-adapter:run
    #'dispatch-handler/1
    '(#(port 5099))))

(defun home ()
  (make-response
   status 200
   headers '(#("content-type" "text/html"))
   body "<html><body>Hello World</body></html>"))

(defun data-json (request)
  (make-response
   status 200
   headers '(#("content-type" "application/json"))
   body "{data: \"Hello World\"}"))

(defun style-css (request)
  (make-response
   status 200
   headers '(#("content-type" "text/css"))
   body (read-file request)))

(defun not-found (request)
  (io:format "Fields: ~p~n" (list (fields-request)))
  (io:format "Request: ~p~n" (list request))
  (make-response
   status 404
   headers '(#("content-type" "text/html"))
   body "<html><body><strong>Resource not found.</strong></body></html>"))

(defun read-file (request)
  (let* ((`#(ok ,cwd) (file:get_cwd))
         (filename (++ "/www" (request-path request)))
         (`#(ok ,content) (file:read_file filename)))
    (unicode:characters_to_list content)))