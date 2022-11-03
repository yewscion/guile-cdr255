(define-module (tests-cdr255)
  #:use-module (srfi srfi-64)
  #:use-module (cdr255 userlib))

(module-define! (resolve-module '(srfi srfi-64))
		'test-log-to-file #f)

(test-begin "test-userlib")
(define test-assign-string "Hello=World\nFoo=Bar")
(display (assignment-string->assignment-list test-assign-string))
(test-equal "Split Assignment String"
  '(("Hello" "World") ("Foo" "Bar"))
  (assignment-string->assignment-list test-assign-string))

(test-end "test-userlib")
