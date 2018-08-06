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
