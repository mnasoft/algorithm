;;;; bkp.lisp

(in-package #:algorithm)



;;;; classes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass ntype ()
  ((ntype-name        :accessor ntype-name        :initarg :ntype-name        :initform ""  :documentation "Имя")
   (ntype-states      :accessor ntype-states      :initarg :ntype-states      :initform nil :documentation "Список возможных состояний объекта")
   (ntype-switch-time :accessor ntype-switch-time :initarg :ntype-switch-time :initform nil :documentation "Список затрат времени на переход из одного состояния в другое"))
  (:documentation "Определяет тип объекта, присутствующего в графе"))

(defclass ntype2 (ntype) ()
  (:documentation "Элемент двухпозиционный с  положениями \"+\" (открыто; включено) \"-\" (закрыто; выключено) "))

(defclass noda ()
  ((noda-name :accessor noda-name :initarg :noda-name :initform "" :documentation "Имя")
   (noda-type :accessor noda-type :initarg :noda-type :initform nil :documentation "Ссылка на тип ntype или его потомков"))
  (:documentation "Объект, присутствующий в графе состояний.
Состояния объекта задаются вершинами."))


;;;; defmethod ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; initialize-instance ;;;;;;;;;;;;;;;;;;;

(defmethod initialize-instance :around ((x ntype) &key ntype-name ntype-states ntype-switch-time)
  (call-next-method x
		    :ntype-name ntype-name
		    :ntype-states ntype-states 
		    :ntype-switch-time ntype-switch-time))

(defmethod initialize-instance :around ((x ntype2) &key ntype-name  (time-open 20) (time-close 20))
  (call-next-method x
		    :ntype-name ntype-name :ntype-states '("+" "-")
		    :ntype-switch-time (list (list "-" "+" time-open) (list "+" "-" time-close) )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric switch-time (obj from-state to-tate) (:documentation "Возвращает время преркладки клапана, крана итп из одного состояния в другое"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; graph-add-* ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod graph-add-noda ((g graph ) noda-name noda-state-list)
  (let* (
	 (nd (make-instance 'noda :noda-name noda-name))
	 (vl (mapcar #'(lambda (v)
			 (insert-to (make-instance 'vertex :vertex-noda nd :vertex-state v) g))
		     noda-state-list)))
    (mapc
     #'(lambda (v1 v2 )
	 (insert-to (make-instance 'rib :rib-start-vertex v1 :rib-end-vertex v2) g))
     (reverse(cdr(reverse vl))) (cdr vl))))

(defmethod graph-add-noda-list((g graph ) noda-list)
  (mapc
   #'(lambda (el) (graph-add-noda g (car el) (cdr el)))
   noda-list))

;;;;;;;;;; graph-reorder ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	(o-ribs (outlet-ribs g v)))
    (if (null(second(multiple-value-list(gethash v ht))))
	(progn
	  (setf (vertex-number v) num)
	  (setf (gethash v ht) v))
	(progn
	  (setf (vertex-number v) (max (vertex-number v) num))))
    (incf num)
    (maphash
     #'(lambda (key val)
	 (graph-reorder-vertex g (rib-to key) num ht)
	 )
     o-ribs)
    g))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; print-object ;;;;;;;;;;;;;;;;;;;;;;;;;;



(defmethod print-object :after ((x noda) s)
  (format s "~%(~S ~S)"
	  (noda-name x)
	  (cond
	    ((noda-type x) (ntype-name(noda-type x)))
	    ((noda-type x)))))

(defmethod print-object :after ((x ntype) s)
  (format s "~%(~S ~S ~S)" (ntype-name x) (ntype-states x) (ntype-switch-time x)))
