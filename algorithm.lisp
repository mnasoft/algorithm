;;;; algorithm.lisp

(in-package :cl-user)

(defpackage :algorithm
  (:use #:cl #:mnas-hash-table #:mnas-graph)
  (:export make-create))

(in-package :algorithm)

(defparameter *noda-print-number* nil
  "*noda-print-number* !!!!!")

(defun noda-label-print (num name lbl &optional (out t))
  "@b(Описание:) noda-label-print !!!!!"
  (if *noda-print-number*
      (format out "\"~A ~A\"[label=\"~A ~A ~A\"] " num name num name lbl)
      (format out "\"~A ~A\"[label=\"~A ~A\"] "    num name     name lbl)))

(defun x0 (p &optional (out t))
"@b(Описание:) x0 !!!!!"
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

(defun x1 (p)
"@b(Описание:) x1 !!!!!"
  (list (car p) (cdr p)))

(defun x-start (p &optional (out t) (lbl "S") (label "Начало"))
"@b(Описание:) x-start !!!!!"
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (noda-label-print lbl (first el) (second el) out)) p)
  (format out "}~%")
  (format out "  \"~A\" -> { " label)
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "}~%~%"))

(defun x-end (p &optional (out t) (lbl "E") (label "Конец"))
  "@b(Описание:) x-end !!!!!"
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (noda-label-print lbl (first el) (first (last el)) out)) p)
  (format out "}~%")
  (format out "  { ")
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "} -> \"~A\"~%~%" label))

(defun x-preamble (&optional (out t) (name "G") (rankdir "LR") (shape "box"))
"@b(Описание:) x-preamble !!!!!"
  (format out "digraph ~A {~%  rankdir=~A~%  node[shape=~A]~%~%" name rankdir shape))

(defun x-postamble (&optional (out t))
"@b(Описание:) x-postamble !!!!!"
  (format out "~%}~%"))

(defun rib->rib-list (r)
"@b(Описание:) rib->rib-list !!!!!"
  (if (not(listp(car r)))(list r)r))

(defun noda-print (n &optional (out t))
  "@b(Описание:) noda-print !!!!!"
  (let ((prefix (car n)) (name (cadr n))) (format out "\"~A ~A\" " prefix name)))

(defun noda-list-print (nl &optional (out t))
  "@b(Описание:) noda-list-print !!!!!"
  (mapc #'(lambda(el) (noda-print el out)) nl))

(defun noda-list-group-print (nl &optional (out t))
  "@b(Описание:) noda-list-group-print !!!!!"
  (if (/= (length nl) 1)  (format out "{ "))
  (noda-list-print nl out)
  (if (/= (length nl) 1)(format out "} ")))

(defun rib-print(rib &optional (out t))
  "@b(Описание:) rib-print !!!!!"
  (let ((sl (rib->rib-list (first rib))) (el (rib->rib-list (second rib))))
    (noda-list-group-print sl out)
    (format out "-> ")
    (noda-list-group-print el out)))

(defun rib-list-print(ribs &optional (out t))
  "@b(Описание:) rib-list-print !!!!!"
  (mapc #'(lambda (el) (rib-print el out) (format out "~%") )ribs))

(defun main (p ribs &optional (out t))
  "@b(Описание:) main !!!!!"
  (x-preamble out)
  (x-start p out)
  (x-end  p out)
  (mapc #'(lambda (el) (x0 (x1 el) out)) p)
  (format out "edge[style=dashed]~%~%")
  (rib-list-print ribs out)
  (x-postamble out))

(export 'make-create )

(defun make-create (graph-nodas
		    graph-ribs
		    fname
		    &key
		      (out-type "pdf")
		      (dpi "150")
		      (viewer (cond
				((uiop/os:os-windows-p) "C:/Program Files/Adobe/Reader 11.0/Reader/AcroRd32.exe")
				((uiop/os:os-unix-p)    "/usr/bin/atril"))) ;;;;"/usr/bin/okular"
		      (dot-prg
		       (cond ((uiop/os:os-windows-p) "D:/PRG/msys32/mingw32/bin/dot.exe")
			     ((uiop/os:os-unix-p)    "/usr/bin/dot")))
		      (fpath
		       (cond ((uiop/os:os-windows-p) "D:/PRG/msys32/home/namatv/quicklisp/local-projects/clisp/algorithm") 
			     ((uiop/os:os-unix-p)    "/home/namatv/quicklisp/local-projects/clisp/algorithm/rezult")))
		      (invoke-viewer nil))
"@b(Описание:) make-create предназначена для генерирования симпатичного графа, отображающего алгоритм переходного процесса,
выраженного в теминах последовательных состояний агрегатов.

 @b(Переменые:)
@begin(list)
 @item(graph-nodas - список, каждым элементом которого является список,
              состоящий из обозначения агрегата после которого следуют его состояния;)
 @item(graph-ribs - список каждым элементом которого является список,
              отражающий зависимости между переключениями агрегатов.
              Первым элементом является список из номера состояния 
              и обозначения агрегата к которому приязана возможность 
              осуществления действия над агрегатами перечисленными во втором сиске; )
 @item(fname - имя файла в который выводится результат.)
@end(list)

 @b(Пример использования:)
 Пусть имеем три клапана: КЛ1, КЛ2, КЛ3. 

 Каждый клапан может находиться в положении открыто - \"+\" или закрыто - \"-\".

 Первоначально КЛ1 и КЛ2 - открыты, а КЛ3 закрыт.

 Необходимо сначала переложить клапаны КЛ1 и КЛ2 в закрытое положение, а затем открыть КЛ3.

 Код, который будет генерировать соответствующий граф можо записать так:
@begin[lang=lisp](code)
 (make-create '((\"КЛ1\" \"+\" \"-\" \"-\")
	       (\"КЛ2\" \"+\" \"-\" \"-\")
	       (\"КЛ3\" \"-\" \"+\" \"+\"))
	     '(((1 \"КЛ1\") (1 \"КЛ3\"))
	       ((1 \"КЛ2\") (1 \"КЛ3\")))
	     \"sample_01\")
@end(code)
 или так:
@begin[lang=lisp](code)
 (make-create '((\"КЛ1\" \"+\" \"-\" \"-\")
	       (\"КЛ2\" \"+\" \"-\" \"-\")
	       (\"КЛ3\" \"-\" \"+\" \"+\"))
	     '((((1 \"КЛ1\")(1 \"КЛ2\")) (1 \"КЛ3\")))
	     \"sample_01\")
@end(code)
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
