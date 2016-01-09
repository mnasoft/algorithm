;;;; testing.lisp

(in-package #:algorithm)

;;;;(declaim (optimize (debug 3)))


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

;;;;(graph-clear *g*)

(progn (maphash #'(lambda (k v) (format t "~S " (to-string k))) (graph-find-inlet-vertexes *g*))
       (format t "~%")
       (maphash #'(lambda (k v) (format t "~S " (to-string k))) (graph-find-outlet-vertexes *g*)))



(maphash #'(lambda (k v) (format t "~A~%" k))
	 (algorithm::graph-find-outlet-ribs *g*(graph-find-vertex-by-name *g* "PH06:274")))

(eq (graph-find-vertex-by-name *g* "PH06:274") (graph-find-vertex-by-name *g* "PH06:274"))
