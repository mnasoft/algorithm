;;;; algorithm.asd

(defsystem #:algorithm
  :description "Describe algoritm here"
  :author "Nick Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"  
  :depends-on (#:mnas-hash-table #:mnas-graph)
  :serial nil
  :components ((:file "package")
	       (:file "algorithm" :depends-on ("package"))
;;;;	       (:file "testing" :depends-on ("algorithm-graph-method"))
	       ))
