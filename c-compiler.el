(defun c-compiler-lex (source-text)
  (let ((regex-constant (rx (1+ digit)))
        (regex-ident    (rx (1+ (in "a-z" "A-Z" "_"))))
	(regex-whitespace (rx (0+ whitespace))))
    (with-temp-buffer
      (insert source-text)
      (goto-char (point-min))
      (cl-loop until (eobp)
	       collect (cond
			;; identifiers and keywords
			((looking-at-p regex-ident)
			 (let ((ident (buffer-substring (point) (re-search-forward regex-ident))))
			   (pcase ident
			     ("void"    '(keyword . "void"))
			     ("int"     '(keyword . "int"))
			     ("return"  '(keyword . "return"))
			     (_         `(identifier . ,ident)))))
			;; delimiters
			((looking-at-p (rx (in "(" ")" "{" "}" ";")))
			 (let ((char (char-to-string (char-after))))
			   (forward-char 1)
			   `(delim . ,char)))
			;; constants
			((looking-at-p regex-constant)
			 (let ((num (buffer-substring (point) (re-search-forward regex-constant))))
			   `(constant . ,(string-to-number num))))
			;; nothing was matched
			(t (error "syntax error")))
	       ;; skip over boundaries/whitespace following the last match
	       do (re-search-forward regex-whitespace)))))
