;;; Copyright (c) 2019 Tasuku Hiraishi <tasuku@media.kyoto-u.ac.jp>
;;; All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.

(defpackage "TCELL-BAF"
  (:shadow cl:declaration)
  (:use "RULE" "CL" "SC-MISC")
  (:export :baf-compatible-p :*init* :*env*))
(in-package "TCELL-BAF")

;; Initial value of Location specifier
(defparameter *init* (list))
;; Current value of Location specifier
(defparameter *env* (list))

(defun env-equal-p (env1 env2)
  (every #'(lambda (loc-val)
             (aand (find (car loc-val) env2 :key #'car :test #'equal)
                   (equal (cdr loc-val) (cdr it))))
         env1))
    
(defun baf-compatible-p (before after)
  (let ((bef (apply-rule before :untype))
        (aft (apply-rule after :untype)))
    (and (let ((*init* *init*)
               (*env* *env*))
           (mapcar #'interpret bef)
           (mapcar #'interpret aft)
           (env-equal-p *init* *env*))
         (let ((*init* *init*)
               (*env* *env*))
           (mapcar #'interpret aft)
           (mapcar #'interpret bef)
           (env-equal-p *init* *env*)))))

         