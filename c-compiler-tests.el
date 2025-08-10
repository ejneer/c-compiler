(require 'ert)

(ert-deftest c-compiler-lex ()
  (let ((source "int       main(void) {
                     // a comment
                     return 2 // an inline comment
                 }")
	(expected '((keyword . "int")
		    (identifier . "main")
		    (delim . "(")
		    (keyword . "void")
		    (delim . ")")
		    (delim . "{")
		    (keyword . "return")
		    (constant . 2)
		    (delim . "}"))))
    (should (equal (c-compiler-lex source) expected))))
