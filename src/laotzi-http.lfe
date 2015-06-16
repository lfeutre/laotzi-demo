(defmodule laotzi-http
  (export all))

(include-lib "inets/include/httpd.hrl")
(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")

(defun dispatch-handler
  (((= (match-request path "/data.json") request))
   (io:format "Request: ~p" (list request))
   (make-response
    status 200
    headers '(#("content-type" "application/json"))
    body "{data: \"Hello World\"}"))
  (((= (match-request path "/") request))
   (io:format "Request: ~p" (list request))
   (make-response
    status 200
    headers '(#("content-type" "text/html"))
    body "<html><body>Hello World</body></html>"))
  (((= (match-request path "/css/style.css") request))
   (let* ((`#(ok ,cwd) (file:get_cwd))
          (filename (++ cwd "/www" (request-path request)))
          (`#(ok ,content) (file:read_file filename)))
     (io:format "Content: ~p~n" (list content))
     (make-response
      status 200
      headers '(#("content-type" "text/css"))
      body (unicode:characters_to_list content))))
  ((request)
   (io:format "Fields: ~p~n" (list (fields-request)))
   (io:format "Request: ~p~n" (list request))
   (make-response
    status 200
    headers '(#("content-type" "text/html"))
    body "<html><body>not supported</body></html>")))

(defun run ()
  (lmug-barista-adapter:run
    #'dispatch-handler/1
    '(#(port 5099))))