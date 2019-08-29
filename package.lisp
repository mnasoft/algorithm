;;;; algorithm.lisp

(defpackage #:algorithm
  (:use #:cl #:mnas-hash-table #:mnas-graph)
  (:export make-create))

;;;; (declaim (optimize (compilation-speed 0) (debug 3) (safety 0) (space 0) (speed 0)))
