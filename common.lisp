;; (ql:register-local-projects)
(ql:quickload '(:eazy-gnuplot :iterate :alexandria :trivia :trivia.ppcre :mito :lisp-namespace :lparallel
                :cl-syntax-interpol :recursive-restart) :silent t)

(defpackage :ros.script.plot
  (:use :cl :eazy-gnuplot :iterate :alexandria :trivia :trivia.ppcre :mito :lparallel :sxql :dbi
        :recursive-restart
        :cl-interpol))

(in-package :ros.script.plot)

(setf *auto-migration-mode* t)

(defun my-connect (&optional (name "db.sqlite") (toplevel t))
  (declare (ignorable name))
  (format t "~&connecting... [~a]" name)
  (if toplevel
      (connect-toplevel :sqlite3 :database-name name)
      (connect :sqlite3 :database-name name)))
(defun reset (&optional (name "db.sqlite"))
  (ignore-errors (disconnect-toplevel))
  (delete-file name))

;; (my-connect)
;; (defclass user ()
;;   ((name :col-type (:varchar 64)
;;          :initarg :name
;;          :accessor user-name)
;;    (email :col-type (or (:varchar 128) :null)
;;           :initarg :email
;;           :accessor user-email))
;;   (:metaclass mito:dao-table-class))
;; 
;; 
;; (defclass tweet ()
;;   ((user :col-type user
;;          :initarg :user
;;          :accessor tweet-user))
;;   (:metaclass mito:dao-table-class))
;; 
;; (defparameter me
;;   (create-dao 'user :name "Eitaro Fukamachi" :email "e.arrows@gmail.com"))
;; 
;; (defparameter tw
;;               (mito.logger:with-sql-logging
;;                 (mito:create-dao 'tweet :user me)))


(defclass db-symbol ()
  ((name :col-type :text :initarg :name))
  (:metaclass dao-table-class)
  (:record-timestamps nil)
  (:unique-keys name))
(defclass tag (db-symbol) ()
  (:metaclass dao-table-class)
  (:record-timestamps nil))
(defclass domain (db-symbol) ()
  (:metaclass dao-table-class)
  (:record-timestamps nil))
(defclass algorithm (db-symbol) ()
  (:metaclass dao-table-class)
  (:record-timestamps nil))
(defclass heuristics (db-symbol) ()
  (:metaclass dao-table-class)
  (:record-timestamps nil))

(defclass experiment ()
  ((tag :col-type tag :initarg :tag) ;; arbitrary tag string
   (problem :col-type :integer :initarg :problem)
   (domain :col-type domain :initarg :domain)
   (ipcyear :col-type :integer :initarg :ipcyear)
   (algorithm :col-type algorithm :initarg :algorithm)
   (heuristics :col-type heuristics :initarg :heuristics)
   ;;
   (search :col-type :float :initarg :search :initform -1)
   (wall :col-type :integer :initarg :wall :initform -1)
   (memory :col-type :integer :initarg :memory :initform -1)
   ;;
   (expansion :col-type :integer :initarg :expansion :initform -1)
   (evaluation :col-type :integer :initarg :evaluation :initform -1)
   (generation :col-type :integer :initarg :generation :initform -1)
   (plan-length :col-type :integer :initarg :plan-length :initform -1)
   (plan-cost   :col-type :integer :initarg :plan-cost :initform -1))
  (:metaclass dao-table-class)
  (:record-timestamps nil))


(defclass macro (experiment)
     ((macros :col-type :integer :initarg :macros :initform 0)
      (macros2 :col-type :integer :initarg :macros2 :initform 0)
      (usedmacros :col-type :integer :initarg :usedmacros :initform 0))
  (:metaclass dao-table-class)
  (:record-timestamps nil))

(defclass fig2 (macro)
     ()
  (:metaclass dao-table-class)
  (:record-timestamps nil))

(defclass fig3 (macro)
     ((length :col-type :integer :initarg :length)
      (seed :col-type :integer :initarg :seed))
  (:metaclass dao-table-class)
  (:record-timestamps nil))
