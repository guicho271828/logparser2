#!/bin/sh
#|-*- mode:lisp -*-|#
#| <Put a one-line description here>
exec ros -Q -- $0 "$@"
|#

(load "common.lisp")
(in-package :ros.script.plot)
(cl-syntax:use-syntax :cl-interpol)

(defun correct (num)
  (if (plusp num)
      num
      10e8))

(defun main (&rest args)
  (declare (ignorable args))
  (my-connect "db.sqlite")
  (with-plots (*standard-output*)
    (gp-setup :terminal '(:pdf :enhanced :size (5.5 3.6)
                          :dashed
                          ;; :background :rgb "gray80"
                          ;; :monochrome
                          :font "Times New Roman, 12")
              :size :square
              :view '(:equal :xy)
              :output #?"coverage.pdf"
              :pointsize 0.45
              ;; :logscale :xy
              ;; :format '(xy "10^%T")
              :title #?"coverage"
              :xlabel "Without Macro"
              :ylabel "With Macro")
    (plot "x" :title "y=x")
    (plot (lambda ()
            (iter (for (_ config) in
                       (retrieve-by-sql
                        (select :configuration
                          (from :fig2)
                          (group-by :configuration))))
                  (iter (for length in '(2 5 8))
                        (for ((_2 x)) =
                             (retrieve-by-sql
                              (select ((:count :id))
                                (from :fig2)
                                (where
                                 (:and (:= :configuration config)
                                       (:= :tag "base")
                                       (:>= :plan-length 0))))))
                        (for ((_3 y)) =
                             (retrieve-by-sql
                              (select ((:count :id))
                                (from :fig3)
                                (where
                                 (:and (:= :configuration config)
                                       (:= :tag "mangle")
                                       (:= :length length)
                                       (:>= :plan-length 0))))))
                        (format t "~&~a ~a"
                                (correct x)
                                (correct (floor (/ y 6))))))))))


