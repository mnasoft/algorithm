;;;; algorithm.lisp

(in-package #:cl-user)

(defpackage #:algorithm
  (:use #:cl #:mnas-hash-table #:mnas-graph)
  (:export make-create))

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))

(in-package #:algorithm)

(defparameter *noda-print-number* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric to-string (obj) (:documentation "Прелбразование объекта в строку"))

(defgeneric add-vertex (noda-graph) (:documentation "lksjdlfkj"))

(defgeneric insert (part container) (:documentation "Выражает зависимость добавления части в контейнер"))

(defgeneric copy-class-instance (class-object) (:documentation "Выполняет копирование и экземпляра класса"))

(defgeneric switch-time (obj from-state to-tate) (:documentation "Возвращает время преркладки клапана, крана итп из одного состояния в другое"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun noda-label-print (num name lbl &optional (out t))
  (if *noda-print-number*
      (format out "\"~A ~A\"[label=\"~A ~A ~A\"] " num name num name lbl)
      (format out "\"~A ~A\"[label=\"~A ~A\"] " num name name lbl)))

(defun x0 (p &optional (out t))
  (do*
   ((i 0 (1+ i)) (name (car p)) (dd (cadr p)) (len (length dd)) (el (nth i dd) (nth i dd)) (lst nil))
   ((>= i len) (reverse lst))
    (setq lst (cons el lst))
    (cond
      ((or (= i 0)(= i (- len 1))) )
      (t  (noda-label-print i name el out))))
  (do*
   ((i 0 (1+ i)) (name (car p)) (dd (cadr p)) (len (length dd)) (el (nth i dd) (nth i dd)) (lst nil))
   ((>= i len) (reverse lst))
    (setq lst (cons el lst))
    (cond
      ((= i 0) (format out "\"~A ~A\" -> " "S" name))
      ((= i (- len 1)) (format out "\"~A ~A\"~%" "E" name))
      (t (format out "\"~A ~A\" -> " i name)))))
  
(defun x1 (p) (list (car p) (cdr p)))

(defun x-start (p &optional (out t) (lbl "S") (label "Начало"))
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (noda-label-print lbl (first el) (second el) out)) p)
  (format out "}~%")
  (format out "  \"~A\" -> { " label)
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "}~%~%"))

(defun x-end (p &optional (out t) (lbl "E") (label "Конец"))
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (noda-label-print lbl (first el) (first (last el)) out)) p)
  (format out "}~%")
  (format out "  { ")
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "} -> \"~A\"~%~%" label))

(defun x-preamble(&optional (out t) (name "G") (rankdir "LR") (shape "box"))
  (format out "digraph ~A {~%  rankdir=~A~%  node[shape=~A]~%~%" name rankdir shape))

(defun x-postamble (&optional (out t)) (format out "~%}~%"))

(defun rib->rib-list (r) (if (not(listp(car r)))(list r)r))

(defun noda-print (n &optional (out t)) (let ((prefix (car n)) (name (cadr n))) (format out "\"~A ~A\" " prefix name)))

(defun noda-list-print (nl &optional (out t)) (mapc #'(lambda(el) (noda-print el out)) nl))

(defun noda-list-group-print (nl &optional (out t))
  (if (/= (length nl) 1)  (format out "{ "))
  (noda-list-print nl out)
  (if (/= (length nl) 1)(format out "} ")))

(defun rib-print(rib &optional (out t))
  (let ((sl (rib->rib-list (first rib))) (el (rib->rib-list (second rib))))
    (noda-list-group-print sl out)
    (format out "-> ")
    (noda-list-group-print el out)))

(defun rib-list-print(ribs &optional (out t)) (mapc #'(lambda (el) (rib-print el out) (format out "~%") )ribs))

(defun main (p ribs &optional (out t))
  (x-preamble out)
  (x-start p out)
  (x-end  p out)
  (mapc #'(lambda (el) (x0 (x1 el) out)) p)
  (format out "edge[style=dashed]~%~%")
  (rib-list-print ribs out)
  (x-postamble out))

(defun make-create (graph-nodas
		    graph-ribs
		    fname
		    &key
		      (out-type "pdf")
		      (dpi "150")
		      (viewer (cond
				((uiop/os:os-windows-p) "C:/Program Files/Adobe/Reader 11.0/Reader/AcroRd32.exe")
				((uiop/os:os-unix-p) "/usr/bin/atril"))) ;;;;"/usr/bin/okular"
		      (dot-prg
		       (cond ((uiop/os:os-windows-p) "D:/PRG/msys32/mingw32/bin/dot.exe")
			     ((uiop/os:os-unix-p) "/usr/bin/dot")))
		      (fpath
		       (cond ((uiop/os:os-windows-p) "D:/PRG/msys32/home/namatv/quicklisp/local-projects/clisp/algorithm") 
			     ((uiop/os:os-unix-p) "/home/namatv/quicklisp/local-projects/clisp/algorithm/rezult")))
		      (invoke-viewer nil))
  "Предназначена для генерирования симпатичного графа, отображающего алгоритм переходного процесса,
выраженного в теминах последовательных состояний агрегатов.
Параметры:
graph-nodas - список, каждым элементом которого является список,
              состоящий из обозначения агрегата после которого следуют его состояния;
graph-ribs  - список каждым элементом которого является список,
              отражающий зависимости между переключениями агрегатов.
              Первым элементом является список из номера состояния 
              и обозначения агрегата к которому приязана возможность 
              осуществления действия над агрегатами перечисленными во втором сиске;
fname       - имя файла в который выводится результат;
Пример использования:
Имеем три клапана: КЛ1, КЛ2, КЛ3. 
Каждый клапан может находиться в положении открыто - \"+\" или закрыто - \"-\".
Первоначально КЛ1 и КЛ2 - открыты, а КЛ3 закрыт.
Необходимо сначала переложить клапаны КЛ1 и КЛ2 в закрытое положение, а затем открыть КЛ3.
Код, который будет генерировать соответствующий граф можо записать так:
 (make-create '((\"КЛ1\" \"+\" \"-\" \"-\")
	       (\"КЛ2\" \"+\" \"-\" \"-\")
	       (\"КЛ3\" \"-\" \"+\" \"+\"))
	     '(((1 \"КЛ1\") (1 \"КЛ3\"))
	       ((1 \"КЛ2\") (1 \"КЛ3\")))
	     \"sample_01\")
или так:
 (make-create '((\"КЛ1\" \"+\" \"-\" \"-\")
	       (\"КЛ2\" \"+\" \"-\" \"-\")
	       (\"КЛ3\" \"-\" \"+\" \"+\"))
	     '((((1 \"КЛ1\")(1 \"КЛ2\")) (1 \"КЛ3\")))
	     \"sample_01\")
"
  (with-open-file (out (concatenate 'string fpath "/" fname ".gv")
		       :direction :output :if-exists :supersede :external-format :UTF8)
    (main graph-nodas graph-ribs out))
  (sb-ext:run-program dot-prg
		      (list (concatenate 'string "-T" out-type)
			    (concatenate 'string "-Gdpi=" dpi)
			    "-o"
			    (concatenate 'string fpath "/" fname ".gv" "." out-type)
			    (concatenate 'string fpath "/" fname ".gv")))
  (if invoke-viewer
      (sb-ext:run-program viewer
			  (list (concatenate 'string fpath "/" fname ".gv" "." out-type)))))

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

;;;;;;;;;; print-object ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod print-object :after ((x ntype) s)
  (format s "~%(~S ~S ~S)" (ntype-name x) (ntype-states x) (ntype-switch-time x)))

(defmethod print-object :after ((x noda) s)
  (format s "~%(~S ~S)"
	  (noda-name x)
	  (cond
	    ((noda-type x) (ntype-name(noda-type x)))
	    ((noda-type x)))))

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
   #'(lambda (el)
       (graph-add-noda g (car el) (cdr el))
       )
   noda-list)
  )

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

;;;;;;;;;; to-string ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;(defmethod to-string ((x vertex)) (format nil "~A:~A" (noda-name (vertex-noda x)) (vertex-number x)))
;;;;(defmethod to-string ((x vertex)) (format nil "~A:~A" (noda-name (vertex-noda x)) (vertex-state x)))


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

;;;;(defmethod copy-class-instance ((x noda-graph)) (make-instance 'noda-graph :name (name x) :vertexes (vertexes x)))

;;;;(defmethod copy-class-instance ((x vertex-type)) (make-instance 'vertex-type :vt-type (vt-type x) :vt-switch-time (vt-switch-time x) :vt-states (vt-states x)))
