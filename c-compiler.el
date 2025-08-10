(require 'cl-macs)

(defun c-compiler-compile (file)
  (with-temp-buffer
    (insert-file-contents file)
    (c-compiler-lex (buffer-string))))

(defun c-compiler-lex (source-text)
  (let ((regex-constant (rx (1+ digit)))
        (regex-ident    (rx (1+ (in "a-z" "A-Z" "_"))))
	(regex-whitespace (rx (0+ (any blank "\n"))))
	(regex-comments "//.*"))
    (with-temp-buffer
      (insert source-text)
      (goto-char (point-min))
      (cl-loop until (eobp)
	       ;; skip over boundaries/whitespace/comments following
	       ;; the last match
	       do (re-search-forward regex-whitespace)
	       do (if (looking-at-p regex-comments)
		      (progn
			;; skip to the end of the line then possibly
			;; consume more whitespace
			(move-end-of-line nil)
			(re-search-forward regex-whitespace)))
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
			(t (error "syntax error")))))))
