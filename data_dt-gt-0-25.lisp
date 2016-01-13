;;;; data_dt-gt-0-25.lisp

(in-package #:algorithm)

;;;;         S         1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20          21 
(defparameter *dt-gt-0-25*
  '(("PH06" "-"                                                                                                "-")
    ("PH07" "-"                                                                                                "-")
    ("FH17" "-"       "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-" "-"          "-")
    ("FH20" "+"                           "+" "-"                                                              "-")
    ("FH40" "+"       "+" "-"                                                                                  "-")
    ("FH25" "+"       "-"                                                                                      "-")
    ("FH26" "+"       "-"                                                                                      "-")
    ("FH27" "-"       "-"                                                                                      "+")
    ("FH28" "-"       "-"                                                                                      "+")
    ("FH29" "-"       "-"                                                                                      "+")
    ("FH30" "+"       "+" "-"                                                                                  "-")
    ("FH31" "-"       "-"                                                                                      "+")
    ("WH01" "-"       "-" "+" "+" "-"                                                                          "-")
    ("КД1"  "-"       "-"                                                                                      "+")
    ("КД2"  "-"       "-"                                                                                      "+")
    ("КД3"  "+"       "+" "-" "-"                                                                              "+")
    ("КД4"  "+"                                                                                                "+")
    ("КД5"  "+"                                                                                                "+")
    ("КД6"  "-"                                                                                                "-")
    ("КД7"  "-"                                                                                                "-")
    ("СК.В" "-"                                                                                                "-")
    ("СК.К" "-"       "-" "+"                                                                                  "+")
    ("КВ"   "-"       "-" "+"                                                                                  "+")
    ("FA01" "0.00R"   "0.00R" "0.95R"                                                                      "1.00R")
    ("WM01" "-"       "-" "+" "+" "-"                                                                          "-")
    ("FA02" "1.00R"   "1.00R" "0.05R"                                                                      "0.00R")
    ("FM02" "+"       "+"                                                                                      "-")))

(defparameter *dt-gt-0-25-ribs*
  '(
    (((1 "FH25") (1 "FH26"))                 ((1 "СК.К") (1 "КВ") (1 "FH27")))
    ( (2 "КВ")                                (1 "СК.К") )
    ( (2 "СК.К")                              ((1 "FA01") (1 "FA02")))
    (((2 "FA01") (2 "FA02"))                  (1 "FH20"))
    ( (2 "FH20")                             ((1 "WH01") (1 "КД3") (1 "FM02") (1 "КД1") (1 "КД2") (1 "FH40")))
    ( (2 "КД3")                               (1 "WM01"))
    ( (2 "WH01")                              (1 "WM01"))
    ( (4 "WH01")                             (1 "FH30"))
    ( (2 "FH30")                            ((1 "FH31")(1 "FH28")(1 "FH29")))
    ( (4 "WH01")                             (3 "КД3"))
    ( (4 "WM01")                             (3 "WH01"))
    ))

;;;;
(make-create *dt-gt-0-25* *dt-gt-0-25-ribs* "dt-gt-0-25")






