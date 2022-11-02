(define-module (cdr255 userlib)
  #:version (0 1 1)
  #:export (bluebird))
(define (bluebird action procedure)
  "Create a procedure that is the result of applying ACTION on the result of
PROCEDURE.

This is a CALCULATION.

This is an implementation of the B combinator (S(KS)K).

Arguments
=========
ACTION <procedure>: A monadic procedure, the second one to be applied to the
arguments.

PROCEDURE <procedure>: A procedure that returns one result, which is used as
the input to ACTION.

Returns
=======
A <procedure> that will take all arguments passed to it, apply PROCEDURE to
those arguments, and then apply ACTION to the result.

Impurities
==========
None."
  (lambda* (#:rest args)
    (apply action (list (apply procedure args)))))
