(require 'ert)

(ert-deftest c-compiler-lex ()
  (let ((source "int       main(void) {
                     return 2
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
