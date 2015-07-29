(defmodule laotzi-http
  (export all))

(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")

(defun start ()
  (barista:start
    #'dispatch-handler/1))

(defun stop ()
  (barista:stop))

(defun dispatch-handler (request)
  request)

