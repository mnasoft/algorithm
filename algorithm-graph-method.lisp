;;;; algorithm-graph-method.lisp

(in-package #:algorithm)

;;;;(declaim (optimize (debug 3)))

;;;;;;;;;; initialize-instance ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod initialize-instance :around ((x ntype) &key ntype-name ntype-states ntype-switch-time)
  (call-next-method x
		    :ntype-name ntype-name
		    :ntype-states ntype-states 
		    :ntype-switch-time ntype-switch-time))

(defmethod initialize-instance :around ((x ntype2) &key ntype-name  (time-open 20) (time-close 20))
  (call-next-method x :ntype-name ntype-name :ntype-states '("+" "-")
		    :ntype-switch-time (list (list "-" "+" time-open) (list "+" "-" time-close) )))

;;;;;;;;;; print-object ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod print-object :after ((x ntype) s)
  (format s "~%(~S ~S ~S)" (ntype-name x) (ntype-states x) (ntype-switch-time x)))

(defmethod print-object :after ((x node) s)
  (format s "~%(~S ~S)"
	  (node-name x)
	  (cond
	    ((node-type x) (ntype-name(node-type x)))
	    ((node-type x)))))

;;;;;;;;;; graph-add-* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod graph-add-node ((g graph ) node-name node-state-list)
  (let* (
	 (nd (make-instance 'node :node-name node-name))
	 (vl (mapcar #'(lambda (v)
			 (graph-add-vertex g (make-instance 'vertex :vertex-node nd :vertex-state v)))
		     node-state-list)))
    (mapc
     #'(lambda (v1 v2 )
	 (graph-add-rib g (make-instance 'rib :rib-start-vertex v1 :rib-end-vertex v2)))
     (reverse(cdr(reverse vl))) (cdr vl))))

(defmethod graph-add-node-list((g graph ) node-list)
  (mapc
   #'(lambda (el)
       (graph-add-node g (car el) (cdr el))
       )
   node-list)
  )



;;;;;;;;;; graph-reorder ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod graph-reorder-vertex((g graph) (v vertex) num &optional (h-table nil))
  "Выполняет перенумерацию вершин.
Алоритм подходит для графа не имеющего в своем составе циклов.
0 Граф Вершина Номер Хеш-таблица_обработанных_вершин_(ХТОВ)
1 Вершина присутствует в ХТОВ
1.1 Нет
1.1.1 Присвоить номер вершине 
1.1.2 Добавить вершину в ХТОВ
1.2 Да
1.2.1 Номер больше номера вершины - присвоить новы номер вершине
1.2.2 Поместить вершину в ХТОВ
1.2.3 Найти для вершины исходящие ребра "
  (let ((ht (if (null h-table) (make-hash-table) h-table))
	(o-ribs (graph-find-outlet-ribs g v)))
    (if (null(second(multiple-value-list(gethash v ht))))
	(progn
	  (setf (vertex-number v) num)
	  (setf (gethash v ht) v))
	(progn
	  (setf (vertex-number v) (max (vertex-number v) num))))
    (incf num)
    (maphash
     #'(lambda (key val)
	 (graph-reorder-vertex g (rib-end-vertex key) num ht)
	 )
     o-ribs)
    g))

;;;;;;;;;; to-string ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod to-string ((x vertex)) (format nil "~A:~A" (node-name (vertex-node x)) (vertex-number x)))
;;;;(defmethod to-string ((x vertex)) (format nil "~A:~A" (node-name (vertex-node x)) (vertex-state x)))


;;;;;;;;;; to-html ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;; switch-time ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;(defmethod switch-time ((obj vertex-type) from-state to-state)  0.0  )

;;;;(defmethod switch-time ((obj valve-01) from-state to-state)
;;;;  (let ((rez 0.0))
;;;;    (mapc
;;;;     #'(lambda (el)
;;;;	 (cond
;;;;	   ((and (string= from-state (first el)) (string= to-state (second el)))
;;;;	    (setf rez (third el)))))
;;;;     (vt-switch-time obj))
;;;;    rez))

;;;;;;;;;; insert

;;;;;;;;;; copy-class-instance

;;;;(defmethod copy-class-instance ((x node-graph)) (make-instance 'node-graph :name (name x) :vertexes (vertexes x)))

;;;;(defmethod copy-class-instance ((x vertex-type)) (make-instance 'vertex-type :vt-type (vt-type x) :vt-switch-time (vt-switch-time x) :vt-states (vt-states x)))
