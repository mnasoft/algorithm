;;;; data_01.lisp

(in-package #:algorithm)

(defparameter *dt-gt-hhd*
  '(("PH06" "-"       "-" "+" "-"                                                                                                "-")
    ("PH07" "-"       "-" "+" "-"                                                                                                "-")
    ("FH17" "-"       "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-"    "-")
    ("FH20" "+"       "+" "-"                                                                                                    "-")
    ("FH40" "-"                                                                                                                  "-")
    ("FH25" "+"       "-"                                                                                                        "-")
    ("FH26" "+"       "-"                                                                                                        "-")
    ("FH27" "-"       "-" "+"                                                                                                    "+")
    ("FH28" "+"       "-" "-" "+" "+10"                                                                                          "+")
    ("FH29" "-"       "-" "+" "+10"                                                                                              "+")
    ("FH30" "-"       "-" "+" "+" "-"                                                                                            "-")
    ("FH31" "+"       "-" "-" "+" "+10"                                                                                          "+")
    ("WH01" "-"       "-" "+" "+" "-"                                                                                            "-")
    ("КД1"  "-"       "-" "+"                                                                                                    "+")
    ("КД2"  "+"                                                                                                                  "+")
    ("КД3"  "+"       "+"  "-" "-"                                                                                               "+")
    ("КД4"  "+"       "+" "-" "-"                                                                                                "+")
    ("КД5"  "+"       "+" "-" "-"                                                                                                "+")
    ("КД6"  "-"                                                                                                                  "-")
    ("КД7"  "-"                                                                                                                  "-")
    ("СК.В" "-"                                                                                                                  "-")
    ("СК.К" "-"       "-" "+"                                                                                                    "+")
    ("КВ"   "-"       "-" "+"                                                                                                    "+")
    ("FA01" "0.00R"   "0.00R" "0.95R"                                                                                        "1.00R")
    ("WM01" "-"       "-" "+" "+" "-"                                                                                            "-")
    ("FA02" "1.00R"   "1.00R" "0.05R"                                                                                        "0.00R")
    ("FM02" "+"       "+" "-"                                                                                                    "-")))

(defparameter *dt-gt-hhd-ribs*
  '(((2 "КД4") (1 "PH06"))
    ((2 "КД5") (1 "PH07"))
    ((3 "PH06") (3 "КД4"))
    ((3 "PH07") (3 "КД5"))
    (((1 "FH25") (1 "FH26")) (1 "СК.К"))
    ((2 "FH20") ((1 "WH01") (1 "КД3") (1 "FM02") (1 "КД1")))
    (((1 "FH25") (1 "FH26")) (1 "КВ"))
    (((1 "FH25") (1 "FH26")) (1 "FH27"))
    (((2 "СК.К") (2 "КВ")) ((1 "FA01") (1 "FA02")))
    (((2 "FA01") (2 "FA02")) (1 "FH20"))
    ((4 "WH01") (3 "FH30"))
    ((4 "FH30") ((2 "FH31")(2 "FH28")(1 "FH29")))
    (((3 "FH29")(4 "FH28")(4 "FH31")) ((1 "КД4") (1 "КД5")))
    (((1 "FH31") (1 "FH28")("S" "FH29")) (1 "FH30"))
    ((4 "WH01") (3 "КД3"))
    ((2 "КД3") (1 "WM01"))
    ((2 "WH01") (1 "WM01"))
    ((4 "WM01") (3 "WH01"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;WINDOWS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;(with-open-file (out "d:/home/_namatv/git/clisp/algoritm/dt-gt-hhd.gv" :direction :output :if-exists :supersede :external-format :CP1251) (main *dt-gt-hhd* *dt-gt-hhd-ribs* out))
;;;;(sb-ext:run-program "d:/home/_namatv/bin/graphviz-2.38/release/bin/dot.exe" "-Tpdf -o d:/home/_namatv/git/clisp/algoritm/dt-gt-hhd.gv.pdf d:/home/_namatv/git/clisp/algoritm/dt-gt-hhd.gv")
;;;;(sb-ext:run-program "C:\\Program Files\\Adobe\\Reader 11.0\\Reader\\AcroRd32.exe" "d:/home/_namatv/git/clisp/algoritm/dt-gt-hhd.gv.pdf")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;WINDOWS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LINUX;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;(make-create *dt-gt-hhd* *dt-gt-hhd-ribs* "/home/namatv/My/git/clisp/algorithm/dt-gt-hhd.gv" :out-type "png" :dpi "150" :viewer "/usr/bin/okular")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LINUX;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;