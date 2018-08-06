;;;; testing.lisp

(in-package #:algorithm)

;;;;(defparameter *dn=10_pn=4_τ=20* (make-instance 'ntype2 :ntype-name "dn=10 pn=4 τ=20" :time-open 20 :time-close 20))

;;;;(defparameter *dn=20_pn=4_τ=20* (make-instance 'ntype2 :ntype-name "dn=20 pn=4 τ=20" :time-open 20 :time-close 20))

;;;;(defparameter *dn=12_pn=4_τ=0.2* (make-instance 'ntype2 :ntype-name "dn=12 pn=4 τ=0.2" :time-open 0.2 :time-close 0.2))

;;;;(defparameter *PH06* (make-instance 'node  :node-name "PH06" :node-type *dn=12_pn=4_τ=0.2*))

;;;;(defparameter *PH06-0* (make-instance 'vertex :vertex-node *PH06* :vertex-state "-"))

;;;;(defparameter *PH06-1* (make-instance 'vertex :vertex-node *PH06* :vertex-state "+"))

;;;;(defparameter *v1* (make-instance 'vertex :v-name "PH06" :v-state "+" :v-type *valve-01* ))

;;;;(defparameter *rib-1* (make-instance 'rib :rib-start-vertex *PH06-0* :rib-end-vertex *PH06-1*))

(progn
  (defparameter *G* (make-instance 'graph ))
  (graph-add-node-list *g* *dt-gt-0-25*)
  (format t "~S" *g*))

(maphash
 #'(lambda(key val)
     (graph-reorder-vertex *g* key 0)     
     )
 (graph-find-inlet-vertexes *g*))

(mapcar #'(lambda (el) (format t "~A~%" el))
	*dt-gt-hhd-ribs*)

(progn (maphash #'(lambda (k v) (format t "~S " (to-string k))) (graph-find-inlet-vertexes *g*))
       (format t "~%")
       (maphash #'(lambda (k v) (format t "~S " (to-string k))) (graph-find-outlet-vertexes *g*)))



(maphash #'(lambda (k v) (format t "~A~%" k))
	 (algorithm::graph-find-outlet-ribs *g*(graph-find-vertex-by-name *g* "PH06:274")))

(eq (graph-find-vertex-by-name *g* "PH06:274") (graph-find-vertex-by-name *g* "PH06:274"))

(progn
  (defparameter *g-node-list*
    '(("A" "0" "1" "2" "3" "4")
      ("B" "1" "3")
      ("C" "2" "5")))
  (defparameter *rib-connect*
    '(
;;;;      ("A:0" "A:1") ("A:1" "A:2") ("A:2" "A:3") ("A:3" "A:4")
      ("A:0" "B:1") ("A:2" "B:3")
;;;;      ("B:1" "B:3")
      ("A:4" "C:5")
      ("B:1" "C:2")
;;;;      ("C:2" "C:5")
      ))
  (defparameter *g* (make-instance 'graph ))
  (graph-add-node-list *g* *g-node-list*)
  (mapc #'(lambda (r)
	    (graph-add-rib
	     *g*
	     (make-instance
	      'rib
	      :rib-start-vertex (graph-find-vertex-by-name *g* (first r))
	      :rib-end-vertex (graph-find-vertex-by-name *g* (second r)))))
	*rib-connect*))

;;;;(graph-clear *g*)


(graph-reorder-vertex *g* (graph-find-vertex-by-name *g* "A:0") 10 )

(format t "~S" *g*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(algorithm:make-create
 '(("КЛ1" "+" "-"  "-")
   ("КЛ2" "+" "-"  "-")
   ("КЛ3" "-" "-" "+" "+")
   ("КЛ4" "-" "-" "+" ))
 '((((1 "КЛ1")(1 "КЛ2")) (1 "КЛ3"))
   ((2 "КЛ3") (1 "КЛ4")))
 "sample_01"
 :invoke-viewer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(progn
  (defparameter *dt-gt-0-25*
    '(("PH06" "-"                                                                                                "-")
      ("PH07" "-"                                                                                                "-")
      ("FH17" "-"       "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-"          "-")
      ("FH20" "+"                           "+" "-"                                                              "-")
      ("FH40" "+"       "+" "-"                                                                                  "-")
      ("FH25" "+"       "-"                                                                                      "-")
      ("FH26" "+"       "-"                                                                                      "-")
      ("FH27" "-"       "-"                                                                                      "+")
      ("FH28" "-"       "-"                                                                                      "+")
      ("FH29" "-"       "-"                                                                                      "+")
      ("FH30" "+"       "+" "-"                                                                                  "-")
      ("FH31" "-"       "-"                                                                                      "+")
      ("WH01" "-"       "-" "+" "+" "-"                                                                          "-")
      ("КД1"  "-"       "-"                                                                                      "+")
      ("КД2"  "-"       "-"                                                                                      "+")
      ("КД3"  "+"       "+" "-" "-"                                                                              "+")
      ("КД4"  "+"                                                                                                "+")
      ("КД5"  "+"                                                                                                "+")
      ("КД6"  "-"                                                                                                "-")
      ("КД7"  "-"                                                                                                "-")
      ("СК.В" "-"                                                                                                "-")
      ("СК.К" "-"       "-" "+"                                                                                  "+")
      ("КВ"   "-"       "-" "+"                                                                                  "+")
      ("FA01" "0.00R"   "0.00R" "0.95R"                                                                      "1.00R")
      ("WM01" "-"       "-" "+" "+" "-"                                                                          "-")
      ("FA02" "1.00R"   "1.00R" "0.05R"                                                                      "0.00R")
      ("FM02" "+"       "+"                                                                                      "-"))
    "Переход с дизельного топлива на газобразное ДГ80Л3 с двухтопливной двухканальной двухсопловой форсункой на режиме от 0 МВт до 25 МВт.")

  (defparameter *dt-gt-0-25-ribs*
    '(
      (((1 "FH25") (1 "FH26"))     ((1 "СК.К") (1 "КВ") (1 "FH27")))
      ( (2 "КВ")                    (1 "СК.К") )
      ( (2 "СК.К")                 ((1 "FA01") (1 "FA02")))
      (((2 "FA01") (2 "FA02"))      (1 "FH20"))
      ( (2 "FH20")                 ((1 "WH01") (1 "КД3") (1 "FM02") (1 "КД1") (1 "КД2") (1 "FH40")))
      ( (2 "КД3")                   (1 "WM01"))
      ( (2 "WH01")                  (1 "WM01"))
      ( (4 "WH01")                  (1 "FH30"))
      ( (2 "FH30")                 ((1 "FH31")(1 "FH28")(1 "FH29")))
      ( (4 "WH01")                  (3 "КД3"))
      ( (4 "WM01")                  (3 "WH01"))
      ))
  (algorithm:make-create
   *dt-gt-0-25*
   *dt-gt-0-25-ribs*
   "dt-gt-0-25"
   :invoke-viewer t))
