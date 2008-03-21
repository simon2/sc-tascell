;; User defined indentation
(let ((tag 'fi:lisp-indent-hook))
  (put 'awhen tag '(like when))
  (put 'acond tag '(like cond))
  (put 'aif tag '(like if))
  (put 'string-case tag '(like case))
  (put 'with-fresh-variables tag '(like let))
  (put 'defrule tag '((1 (3 t) ((1 0 quote) (0 t nil))) (0 t 2)))
  (put 'extendrule tag '(like defrule))
  (put 'if-pattern-variable tag '(like if))
  (put 'if-match tag 4)
  (put 'when-match tag 3)
  (put 'unless-match tag 3)
  ;; SC
  (put '%defmacro tag '(like defmacro))
  (put '%defconstant tag 1)
  (put '%if tag '(like if))
  (put '%ifdef tag '(like if))
  (put '%ifndef tag '(like if))
  (put '%if* tag '(like when))
  (put '%ifdef* tag '(like when))
  (put '%ifndef* tag '(like when))
  (put 'static-def tag '(like def))
  (put 'for tag 1)
  (put 'switch tag 1)
  (put 'cast tag 1)
  )

(defadvice fi::lisp-invoke-method (around sharp-question
                                          (form-start method depth count state
                                                      indent-point))
  (let (ret)
    (cond ((and form-start
                (eq (char-after (- form-start 1)) ?\?) ; pattern notation #?(...)
                (eq (char-after (- form-start 2)) ?\#))
           (setq ret (fi::lisp-indent-quoted-list depth count state indent-point))
           (message "%S,%S:pattern indent" state ret))
          ((and form-start
                (eq (char-after (- form-start 1)) ?\~)) ; SC-backquote ~(...)
           (setq ret (fi::lisp-indent-quoted-list depth count state indent-point))
           (message "%S,%S:SC-backquote indent" state ret))
          (t
           (setq ret ad-do-it)
           (message "%S,%S" state ret)))
    ret))
(ad-activate 'fi::lisp-invoke-method t)
;; (ad-deactivate 'fi::lisp-invoke-method)

(modify-syntax-entry ?\~ "'   " fi:lisp-mode-syntax-table)
(modify-syntax-entry ?\[ "(]  " fi:lisp-mode-syntax-table)
(modify-syntax-entry ?\] ")[  " fi:lisp-mode-syntax-table)
(modify-syntax-entry ?\{ "(}  " fi:lisp-mode-syntax-table)
(modify-syntax-entry ?\} "){  " fi:lisp-mode-syntax-table)