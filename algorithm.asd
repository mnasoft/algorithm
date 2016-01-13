;;;; algorithm.asd

(asdf:defsystem #:algorithm
  :description "Describe algoritm here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:mnas-hash-table)
  :serial t
  :components ((:file "package")
	       (:file "algorithm")
	       (:file "data_dt-gt-0-25" :depends-on ("algorithm"))
	       (:file "data_dt-gt-hhd"  :depends-on ("algorithm"))
	       (:file "data_gt-dt-0-25" :depends-on ("algorithm"))
	       (:file "data_gt-dt-hhd"  :depends-on ("algorithm"))
	       (:file "algorithm-graph-classes")
	       (:file "algorithm-graph-generic")
	       (:file "algorithm-graph-method"
		      :depends-on ("algorithm-graph-generic"
				   "algorithm-graph-classes"))
;;;;	       (:file "testing" :depends-on ("algorithm-graph-method"))
	       ))






