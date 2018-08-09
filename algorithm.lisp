;;;; algorithm.lisp

(in-package #:algorithm)

(defpackage #:algorithm
  (:use #:cl #:mnas-hash-table #:mnas-graph)
  (:export make-create))

(in-package #:algorithm)

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))

(defparameter *node-print-number* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric to-string (obj) (:documentation "Прелбразование объекта в строку"))

(defgeneric add-vertex (node-graph) (:documentation "lksjdlfkj"))

(defgeneric insert (part container) (:documentation "Выражает зависимость добавления части в контейнер"))

(defgeneric copy-class-instance (class-object) (:documentation "Выполняет копирование и экземпляра класса"))

(defgeneric switch-time (obj from-state to-tate) (:documentation "Возвращает время преркладки клапана, крана итп из одного состояния в другое"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun node-label-print (num name lbl &optional (out t))
  (if *node-print-number*
      (format out "\"~A ~A\"[label=\"~A ~A ~A\"] " num name num name lbl)
      (format out "\"~A ~A\"[label=\"~A ~A\"] " num name name lbl)))

(defun x0 (p &optional (out t))
  (do*
   ((i 0 (1+ i)) (name (car p)) (dd (cadr p)) (len (length dd)) (el (nth i dd) (nth i dd)) (lst nil))
   ((>= i len) (reverse lst))
    (setq lst (cons el lst))
    (cond
      ((or (= i 0)(= i (- len 1))) )
      (t  (node-label-print i name el out))))
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
  (mapc #'(lambda (el) (node-label-print lbl (first el) (second el) out)) p)
  (format out "}~%")
  (format out "  \"~A\" -> { " label)
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "}~%~%"))

(defun x-end (p &optional (out t) (lbl "E") (label "Конец"))
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (node-label-print lbl (first el) (first (last el)) out)) p)
  (format out "}~%")
  (format out "  { ")
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "} -> \"~A\"~%~%" label))

(defun x-preamble(&optional (out t) (name "G") (rankdir "LR") (shape "box"))
  (format out "digraph ~A {~%  rankdir=~A~%  node[shape=~A]~%~%" name rankdir shape))

(defun x-postamble (&optional (out t)) (format out "~%}~%"))

(defun rib->rib-list (r) (if (not(listp(car r)))(list r)r))

(defun node-print (n &optional (out t)) (let ((prefix (car n)) (name (cadr n))) (format out "\"~A ~A\" " prefix name)))

(defun node-list-print (nl &optional (out t)) (mapc #'(lambda(el) (node-print el out)) nl))

(defun node-list-group-print (nl &optional (out t))
  (if (/= (length nl) 1)  (format out "{ "))
  (node-list-print nl out)
  (if (/= (length nl) 1)(format out "} ")))

(defun rib-print(rib &optional (out t))
  (let ((sl (rib->rib-list (first rib))) (el (rib->rib-list (second rib))))
    (node-list-group-print sl out)
    (format out "-> ")
    (node-list-group-print el out)))

(defun rib-list-print(ribs &optional (out t)) (mapc #'(lambda (el) (rib-print el out) (format out "~%") )ribs))

(defun main (p ribs &optional (out t))
  (x-preamble out)
  (x-start p out)
  (x-end  p out)
  (mapc #'(lambda (el) (x0 (x1 el) out)) p)
  (format out "edge[style=dashed]~%~%")
  (rib-list-print ribs out)
  (x-postamble out))

(defun make-create (graph-nodes
		    graph-ribs
		    fname
		    &key
		      (out-type "pdf")
		      (dpi "150")
		      (viewer (cond
				((uiop/os:os-windows-p) "C:/Program Files/Adobe/Reader 11.0/Reader/AcroRd32.exe")
				((uiop/os:os-unix-p) "/usr/bin/atril"))) ;;;;"/usr/bin/okular"
		      (dot-prg
		       (cond ((uiop/os:os-windows-p) "D:/home/_namatv/bin/graphviz-2.38/release/bin/dot.exe")
			     ((uiop/os:os-unix-p) "/usr/bin/dot")))
		      (fpath
		       (cond ((uiop/os:os-windows-p) "d:/home/_namatv/git/clisp/algorithm")
			     ((uiop/os:os-unix-p) "/home/namatv/quicklisp/local-projects/clisp/algorithm/rezult")))
		      (invoke-viewer nil))
  "Предназначена для генерирования симпатичного графа, отображающего алгоритм переходного процесса,
выраженного в теминах последовательных состояний агрегатов.
Параметры:
graph-nodes - список, каждым элементом которого является список,
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
    (main graph-nodes graph-ribs out))
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

(defclass node ()
  ((node-name :accessor node-name :initarg :node-name :initform "" :documentation "Имя")
   (node-type :accessor node-type :initarg :node-type :initform nil :documentation "Ссылка на тип ntype или его потомков"))
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

(defmethod print-object :after ((x node) s)
  (format s "~%(~S ~S)"
	  (node-name x)
	  (cond
	    ((node-type x) (ntype-name(node-type x)))
	    ((node-type x)))))

;;;;;;;;;; graph-add-* ;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;(defmethod to-string ((x vertex)) (format nil "~A:~A" (node-name (vertex-node x)) (vertex-number x)))
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
