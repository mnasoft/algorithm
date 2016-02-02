;;;; algorithm.lisp

(in-package #:algorithm)
;;;;(declaim (optimize (debug 3)))

;;; "algorithm" goes here. Hacks and glory await!

(defparameter *node-print-number* nil)

(defun node-label-print(num name lbl &optional (out t))
  (if *node-print-number*
      (format out "\"~A ~A\"[label=\"~A ~A ~A\"] " num name num name lbl)
      (format out "\"~A ~A\"[label=\"~A ~A\"] " num name name lbl)))

(defun x0(p &optional (out t))
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
  
(defun x1(p) (list (car p) (cdr p)))

(defun x-start(p &optional (out t) (lbl "S") (label "Начало"))
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (node-label-print lbl (first el) (second el) out)) p)
  (format out "}~%")
  (format out "  \"~A\" -> { " label)
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "}~%~%"))

(defun x-end(p &optional (out t) (lbl "E") (label "Конец"))
  (format out "\"~A\"~%~%subgraph cluster_~A{~%  " label label)
  (mapc #'(lambda (el) (node-label-print lbl (first el) (first (last el)) out)) p)
  (format out "}~%")
  (format out "  { ")
  (mapc #'(lambda (el) (format out "\"~A ~A\" " lbl (first el))) p)
  (format out "} -> \"~A\"~%~%" label))

(defun x-preamble(&optional (out t) (name "G") (rankdir "LR") (shape "box"))
  (format out "digraph ~A {~%  rankdir=~A~%  node[shape=~A]~%~%" name rankdir shape))

(defun x-postamble(&optional (out t)) (format out "~%}~%"))

(defun rib->rib-list(r) (if (not(listp(car r)))(list r)r))

(defun node-print(n &optional (out t)) (let ((prefix (car n)) (name (cadr n))) (format out "\"~A ~A\" " prefix name)))

(defun node-list-print(nl &optional (out t)) (mapc #'(lambda(el) (node-print el out)) nl))

(defun node-list-group-print(nl &optional (out t))
  (if (/= (length nl) 1)  (format out "{ "))
  (node-list-print nl out)
  (if (/= (length nl) 1)(format out "} ")))

(defun rib-print(rib &optional (out t))
  (let ((sl (rib->rib-list (first rib))) (el (rib->rib-list (second rib))))
    (node-list-group-print sl out)
    (format out "-> ")
    (node-list-group-print el out)))

(defun rib-list-print(ribs &optional (out t)) (mapc #'(lambda (el) (rib-print el out) (format out "~%") )ribs))

(defun main(p ribs &optional (out t))
  (x-preamble out)
  (x-start p out)
  (x-end  p out)
  (mapc #'(lambda (el) (x0 (x1 el) out)) p)
  (format out "edge[style=dashed]~%~%")
  (rib-list-print ribs out)
  (x-postamble out))

(defun make-create(graph-nodes
		   graph-ribs
		   fname
		   &key
		     (out-type "pdf")
		     (dpi "150")
		     (viewer (cond
			       ((uiop/os:os-windows-p) "C:/Program Files/Adobe/Reader 11.0/Reader/AcroRd32.exe")
			       ((uiop/os:os-unix-p) "/usr/bin/okular")))
		     (dot-prg
		      (cond ((uiop/os:os-windows-p) "D:/home/_namatv/bin/graphviz-2.38/release/bin/dot.exe")
			    ((uiop/os:os-unix-p) "/usr/bin/dot")))
		     (fpath
		      (cond ((uiop/os:os-windows-p) "d:/home/_namatv/git/clisp/algorithm")
			    ((uiop/os:os-unix-p) "/home/namatv/My/git/clisp/algorithm")))
		     (invoke-viewer nil))
  (with-open-file (out (concatenate 'string fpath "/" fname ".gv") :direction :output :if-exists :supersede :external-format :UTF8) (main graph-nodes graph-ribs out))
  (sb-ext:run-program dot-prg
		      (list (concatenate 'string "-T" out-type)
			    (concatenate 'string "-Gdpi=" dpi)
			    "-o"
			    (concatenate 'string fpath "/" fname ".gv" "." out-type)
			    (concatenate 'string fpath "/" fname ".gv")))
  (if invoke-viewer
      (sb-ext:run-program viewer
			  (list (concatenate 'string fpath "/" fname ".gv" "." out-type)))))


