;;;; algorithm-graph-method.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

(defmethod initialize-instance :around ((x valve-01) &key vt-type  (time-open 20) (time-close 20))
  (call-next-method x :vt-type vt-type :vt-states '("+" "-")
		    :vt-switch-time (list (list "-" "+" time-open) (list "+" "-" time-close) )))


;;;;;;;;;; print-object

(defmethod print-object ((x node-graph) s) (format s "#node-graph(~S ~S)" (name x) (vertexes x)))

(defmethod print-object ((x algorithm-graph) s) (format s "#algorithm-graph(~S ~S)" (nodes x) (ribs x)))

(defmethod print-object ((x vertex-type) s)
  (format s "#vertex-type(~S ~S ~S)~%" (vt-type x) (vt-states x) (vt-switch-time x)))

(defmethod print-object ((x vertex) s)
  (format s "#vertex(~S ~S ~S ~S)" (v-name x) (v-num x) (v-state x) (vt-type(v-type x))))

;;;;;;;;;; copy-class-instance

(defmethod copy-class-instance ((x node-graph)) (make-instance 'node-graph :name (name x) :vertexes (vertexes x)))

(defmethod copy-class-instance ((x vertex-type)) (make-instance 'vertex-type :vt-type (vt-type x) :vt-switch-time (vt-switch-time x) :vt-states (vt-states x)))

;;;;;;;;;; switch-time

(defmethod switch-time ((obj vertex-type) from-state to-state)
  0.0
  )

(defmethod switch-time ((obj valve-01) from-state to-state)
  (let ((rez 0.0))
    (mapc
     #'(lambda (el)
	 (cond
	   ((and (string= from-state (first el)) (string= to-state (second el)))
	    (setf rez (third el)))))
     (vt-switch-time obj))
    rez))

;;;;;;;;;; add-vertex

;(defmethod add-vertex ((x node-graph)) (setf (vertexes x) (cons (length (vertexes x)) (vertexes x))))

;;;;;;;;;; insert

;(defmethod insert((y node-graph) (x algorithm-graph)) (setf (nodes x) (cons (copy-object y) (nodes x) )))

;(defmethod insert((y vertex-graph) (x node-graph)) (setf (nodes x) (cons (copy-object y) (nodes x) )))


;(defmethod add-node((x algorithm-graph) (y node-graph)) (if (and (not (member node (nodes x) :test #'equal))) (progn (setf (nodes x) (cons node (nodes x)))  node)  nil))

;(defmethod add-vertex((x algorithm-graph) node) (if (and (stringp node) (member node (nodes x) :test #'equal)) (progn (setf (vertexes x) (cons (list node (length (vertexes x))) (vertexes x))) node)  nil))
