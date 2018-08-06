;;;; package.lisp

(defpackage #:algorithm
  (:use #:cl #:mnas-hash-table #:mnas-graph)
  (:export make-create))

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))
