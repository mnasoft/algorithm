;;;; algorithm-graph-classes.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

(defclass node-graph ()
  ((name :accessor name
	 :initarg :name
	 :initform ""
	 :documentation "Имя узла графа")
   (vertexes :accessor vertexes
	 :initarg :vertexes
	 :initform nil
	 :documentation "Вершины графа, связанные с данным узлом графа")))

(defclass algorithm-graph ()
  ((nodes :accessor nodes
	     :initarg :nodes
	     :initform nil
	     :documentation "Список узлов графа")
   (ribs :accessor ribs
         :initarg :ribs
	 :initform nil
	 :documentation "Список ребер графа"))
  (:documentation "Представляет граф, выражающий алгоритм изменения состояния агрегатов"))



(defclass vertex ()
  ((v-name :accessor v-name
	 :initarg :v-name
	 :initform ""
	 :allocation :instance
	 :documentation "Имя вершины")
   (v-num :accessor v-num
	   :initarg :v-num
	   :initform 0
	   :allocation :instance
	   :documentation "Номер вершины")
   (v-type :accessor v-type
	 :initarg :v-type
	 :initform nil
	 :allocation :instance
	 :documentation "Ссылка на тип вершины")
   (v-state :accessor v-state
	 :initarg :v-state
	 :initform nil
	 :allocation :instance
	 :documentation "Ссылка на состояние вершины")
   ))

(defclass vertex-type()
  ((vt-type :accessor vt-type
	    :initarg :vt-type
	    :initform ""
	    :allocation :instance
	    :documentation "Тип вершины")
   (vt-states :accessor vt-states
	      :initarg :vt-states
	      :initform nil
	      :allocation :instance
	      :documentation "Перечень возможных состояний")
   (vt-switch-time :accessor vt-switch-time
		   :initarg :vt-switch-time
		   :initform nil
		   :allocation :instance
		   :documentation "Перечень затрат времени на переход из одного состояния в другое")))

(defclass valve-01(vertex-type) ()
  (:documentation "Элемент двухпозиционный с  положениями \"+\" (открыто; включено) \"-\" (закрыто; выключено) "))



  


