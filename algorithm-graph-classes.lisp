;;;; algorithm-graph-classes.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

(defclass ntype()
  ((ntype-name :accessor ntype-name
	    :initarg :ntype-name
	    :initform ""
	    :allocation :instance
	    :documentation "Имя")
   (ntype-states :accessor ntype-states
	      :initarg :ntype-states
	      :initform nil
	      :allocation :instance
	      :documentation "Список возможных состояний объекта")
   (ntype-switch-time :accessor ntype-switch-time
		   :initarg :ntype-switch-time
		   :initform nil
		   :allocation :instance
		   :documentation "Список затрат времени на переход из одного состояния в другое"))
  (:documentation "Определяет тип объекта, присутствующего в графе"))

(defclass ntype2(ntype) ()
  (:documentation "Элемент двухпозиционный с  положениями \"+\" (открыто; включено) \"-\" (закрыто; выключено) "))

(defclass node ()
  ((node-name :accessor node-name
	 :initarg :node-name
	 :initform ""
	 :documentation "Имя")
   (node-type :accessor node-type
	 :initarg :node-type
	 :initform nil
	 :documentation "Ссылка на тип ntype или его потомков"))
  (:documentation "Объект, присутствующий в графе состояний.
Состояния объекта задаются вершинами."))


(defclass vertex ()
  ((vertex-node :accessor vertex-node
		:initarg :vertex-node
		:initform nil
		:allocation :instance
		:documentation "Имя вершины")
   (vertex-number :accessor vertex-number
		  :initarg :vertex-number
;;;;		  :initform 0
		  :allocation :instance
		  :documentation "Номер вершины")
   (vertex-state :accessor vertex-state
		 :initarg :vertex-state
		 :initform nil
		 :allocation :instance
		 :documentation "Ссылка на состояние вершины")
   (vertex-counter :accessor vertex-counter
;;;;		   :initarg :vertex-counter
		   :initform 0
		   :allocation :class
		   :documentation "Количество, созданных вершин")
   ))

(defclass rib ()
  ((rib-start-vertex :accessor rib-start-vertex
		     :initarg :rib-start-vertex
		     :initform nil
		     :allocation :instance
		     :documentation "Начальная вершина ребра")
   (rib-end-vertex :accessor rib-end-vertex
		   :initarg :rib-end-vertex
		   :initform nil
		   :allocation :instance
		   :documentation "Конечная  вершина ребра"))
  (:documentation "Ребро графа"))


(defclass graph ()
  ((graph-vertexes :accessor graph-vertexes
;;;;		   :initarg :graph-vertexes
		   :initform (make-hash-table)
		   :documentation "Хешированная таблица вершин графа")
   (graph-ribs :accessor graph-ribs
;;;;         :initarg :graph-ribs
	       :initform (make-hash-table)
	       :documentation "Хешированная таблица ребер графа"))
  (:documentation "Представляет граф, выражающий алгоритм изменения состояния агрегатов во времени"))











  


