;;;; algorithm.asd

(asdf:defsystem #:algorithm
  :description "Describe algoritm here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:mnas-hash-table #:mnas-graph)
  :serial t
  :components ((:file "algorithm")
;;;;	       (:file "testing" :depends-on ("algorithm-graph-method"))
	       ))
