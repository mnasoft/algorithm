;;;; testing.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

(make-create *dt-gt-0-25* *dt-gt-0-25-ribs* "dt-gt-0-25")
(make-create *dt-gt-hhd* *dt-gt-hhd-ribs* "dt-gt-hhd")
(make-create *gt-dt-0-25* *gt-dt-0-25-ribs* "gt-dt-0-25")
(make-create *gt-dt-hhd* *gt-dt-hhd-ribs* "gt-dt-hhd")


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
  (graph-add-node-list *g* *dt-gt-hhd*)
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
