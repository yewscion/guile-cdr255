(define-module (cdr255 userlib)
  #:version (0 1 1)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 regex)
  #:export (add-section-to-filename
            apply-recursive-regexp-replacement
            assignment-string->assignment-list
            clean-assignment-list
            dereference-env
            dereference-env-in-assignment-list
            dereference-env-in-string
            dereference-envs-in-assignment-list
            dump-string-to-file
            find-file-extension
            get-file-as-string
            iteratively-replace-regexp
            remove-c-multiline-comments-from-string
            remove-empty-strings
            remove-regexp-from-string
            remove-substring-from-assignment-list
            replace-regexp-in-string
            set-env-from-list))
(define (dereference-env variable)
  "Return the value of the variable in the environment, or an empty string.

This is an ACTION.

Arguments
=========
VARIABLE <string>: The variable to be dereferenced.

Returns
=======
A <string> representing the value of the variable. If the variable is unset in
the current environment, the string is an empty string.

Impurities
==========
Depends on the state of the environment."
  (let ((value (getenv variable)))
    (cond ((not value)
           ".")
          (else
           value))))
(define (dereference-env-in-string variable string-to-work-on)
  "Take a string and an environment variable, and replace the environment
variable with the value in the current environment.

This is an ACTION.

Arguments
=========
VARIABLE <string>: The Environment Variable itself.
STRING-TO-WORK-ON <string>: The original string.

Returns
=======
A <string> with all instances of \"$VARIABLE\" replaced by the value thereof.

Impurities
============
Depends on the local environment state."
  (string-replace-substring string-to-work-on
                            (string-append "$" variable)
                            (dereference-env variable)))
(define (get-file-as-string file)
  "Slurp the contents of a file and return them as a string.

This is an ACTION.

Arguments
=========
FILE <string>: The name of the file to slurp.

Returns
=======
A <string> representing the contents of the FILE.

Impurities
==========
Depends on the state of the FILE."
  (call-with-input-file file get-string-all))
(define (assignment-string->assignment-list assignment-string)
  "Take a string and turn it into a list of the assignments.

This is a CALCULATION.

Arguments
=========
ORIGIN <string>: The original string, which should have statements delimited by
newlines ('\n') and assigments using '='.

Returns
=======
A <<list> of <lists> of <strings>>, in the form:

'((variable assignment)(variable assignment))

Impurities
==========
None."
  (clean-assignment-list
   (map (lambda (x)
          (string-split x #\=))
        (string-split assignment-string #\newline))))
(define (set-env-from-list assignment-list)
  "Set environment variables according to the assignment list.

This is an ACTION.

Arguments
=========
ASSIGNMENT-LIST <<list> of <lists> of <strings>>: A list of assignments in the
form:

'((variable assignment)(variable assignment))

Returns
=======
#<undefined>

Impurities
==========
Entirely based on manipulating an outside environment."
  (map (lambda (x)
         (setenv (car x) (cadr x)))
       assignment-list))
(define (clean-assignment-list unclean-list)
  "Take a list and remove the non-assignment members.

This is a CALCULATION.

Assignment members are those that are exactly '(a b), where a and b are both
strings and a should be set to equal b.

Arguments
=========
UNCLEAN-LIST <<list> of <lists> of <strings>>: A list containing both assignment
and non-assignment members.

Returns
=======
A <<list> of <lists> of <strings>> entirely consisting of assignment members.

Impurities
===========
None."
  (filter
   (lambda (x)
     (and
      (= (length x) 2)
      (string? (car x))
      (string? (cadr x))
      (not (string-index (car x) #\ ))
      (if (>= (string-length (car x)) 6)
          (not (string= (substring (car x) 0 6) "export")))))
   unclean-list))
(define (dereference-env-in-assignment-list variable assignment-list)
  "Dereference an environment variable across all elements of an assignment list.

This is an ACTION.

Arguments
=========
VARIABLE <string>: The variable to be dereferenced.

ASSIGNMENT-LIST <<list> of <lists> of <strings>>: A list of assignments in the
form:

'((variable assignment)(variable assignment))

Returns
=======
A <<list> of <lists> of <strings>> with all instances of VARIABLE in the string
replaced by the value of that variable in the environment. If the variable is
unset, VARIABLE is removed from the string.

Impurities
==========
Depends on the state of the environment."
  (map (lambda (x)
         (list (dereference-env-in-string variable (car x))
               (dereference-env-in-string variable (cadr x))))
       assignment-list))
(define (remove-substring-from-assignment-list substring assignment-list)
  "Remove a substring across all elements of an assignment list.

This is a CALCULATION.

Arguments
=========
SUBSTRING <string>: The substring to be removed.
ASSIGNMENT-LIST <<list> of <lists> of <strings>>: A list of assignments in the
form:

'((variable assignment)(variable assignment))

Returns
=======
A <<list> of <lists> of <strings>> with the SUBSTRING removed from every string.

Impurities
==========
None."
  (map (lambda (x)
         (list (string-replace-substring (car x) substring "")
               (string-replace-substring (cadr x) substring "")))
       assignment-list))
(define (dereference-envs-in-assignment-list list-of-variables assignment-list)
  "Dereference all variables given across all members of an assignment list.

This is an ACTION.

Arguments
=========
LIST-OF-VARIABLES <<list> of <string>>: The variables to be dereferenced.
 
ASSIGNMENT-LIST <<list> of <lists> of <strings>>: A list of assignments in the
form:

'((variable assignment)(variable assignment))

Returns
=======

A <<list> of <lists> of <strings>> with all instances of each member of the
LIST-OF-VARIABLES in the string replaced by the value of that variable in the
environment. If the variable is unset, the member is removed from the string.

Impurities
==========
Depends on the state of the environment."
  (cond ((= (length list-of-variables) 1)
         (dereference-env-in-assignment-list
          (car list-of-variables)
          assignment-list))
        (else
         (dereference-envs-in-assignment-list
          (cdr list-of-variables)
          (dereference-env-in-assignment-list
           (car list-of-variables)
           assignment-list)))))
(define (dump-string-to-file file string)
  "Dump a STRING to a specific FILE.

This is an ACTION.

Arguments
=========
FILE <string>: The path and name of the file to save the string to.
STRING <string>: The (intended) contents of the file.

Returns
=======
Unspecified.


Impurities
==========
Write to a file on disk."
  (call-with-output-file file
    (lambda (port)
      (put-string port
                  string))))
(define (replace-regexp-in-string regexp replacement original-string)
  "Replace matches of REGEXP with REPLACEMENT in ORIGINAL-STRING.

This is a CALCULATION.

Arguments
=========

REGEXP<string>: A POSIX-extended regular expression string, escaped for guile
scheme.

REPLACEMENT<string>: A literal replacement for matches to REGEXP; will appear
in the result verbatim.

ORIGINAL-STRING<string>: The string before any modification.

Returns
=======
A <string> representing ORIGINAL-STRING with all matches of REGEXP replaced
by REPLACEMENT.

Impurities
==========
None."
  (regexp-substitute/global #f regexp original-string 'pre replacement
                            'post))
(define (remove-regexp-from-string regexp original-string)
  "Remove all matches of REGEXP from the ORIGINAL-STRING.

This is a CALCULATION.

Arguments
=========
REGEXP<string>: A POSIX-extended regular expression string, escaped for guile
scheme.

ORIGINAL-STRING<string>: The string before any modification.

Returns
=======
A <string> representing ORIGINAL-STRING with all matches of REGEXP removed.

Impurities
==========
None."
  (replace-regexp-in-string regexp "" original-string))
(define (apply-recursive-regexp-replacement original-string
                                            replacement-alist)
  "Apply recursive edits to ORIGINAL STRING as defined by REPLACEMENT-ALIST.

This is a CALCULATION.

Arguments
=========
ORIGINAL-STRING<string>: The string before any modification.

REPLACEMENT-ALIST<<alist> of <strings>>: An association list that pairs a
                                         POSIX-extended regular expression
                                         string with what it should be
                                         replaced by, in the order that the
                                         replacements should be made.

Returns
=======
A <string> representing ORIGINAL-STRING after all of the replacements have
been applied.

Impurities
==========
None."
  (cond ((= (length replacement-alist) 0)
         original-string)
        (else
         (let ((current (car replacement-alist)))
           (apply-recursive-regexp-replacement
            (replace-regexp-in-string (car current)
                                      (cadr current)
                                      original-string)
            (cdr replacement-alist))))))
(define (remove-c-multiline-comments-from-string original-string)
  "Remove all C-Style Multiline Comments from ORIGINAL-STRING.

This is a CALCULATION.

Arguments
=========
ORIGINAL-STRING<string>: The string before any modification.

Returns
=======

A <string> representing ORIGINAL-STRING with all C-Style Multiline Comments
Removed.

Impurities
==========
None."
  (let ((replacement-alist '(("\n" "⍝")
                             ("/\\*\\*" "")
                             ("⍝ +\\*[^⍝]+" "")
                             (" +\\*⍝" "⍝")
                             (" *⍝ +⍝" "⍝")
                             (" *⍝+" "⍝")
                             ("⍝+" "\n"))))
    (apply-recursive-regexp-replacement original-string
                                        replacement-alist)))

(define (find-file-extension filename)
  "Isolate the file extension in FILENAME.

This is a CALCULATION.

Arguments
=========
FILENAME<string>: The filename/path for which to find an extension.

Returns
=======
A <string> representing the file extension (with dot) present in
FILENAME. #false if no extension is found.

Impurities
==========
None."
  (let ((index (string-rindex filename #\.)))
    (if index
        (string-drop filename index)
        index)))
(define (add-section-to-filename section filename)
  "Add SECTION to FILENAME, before the extension (if it exists).

This is a CALCULATION.

Arguments
=========
SECTION<string>: The section to add before the extesion of the filename.
FILENAME<string>: The original filename to add the extension to.

Returns
=======

A <string> representing FILENAME with SECTION added before the
extension. Assumes a dot delimited filename.

Impurities
==========
None."
  (let ((extension (find-file-extension (basename filename)))
        (directory (if (string= (dirname filename) ".")
                       ""
                       (string-append
                        (dirname filename)
                        "/"))))
    (string-append directory
                   (if extension
                       (basename filename extension)
                       (basename filename))
                   "."
                   section
                   (if extension
                       extension))))
(define (remove-empty-strings original-list)
  "Remove all empty strings from ORIGINAL-LIST.

This is a CALCULATION.

Arguments
=========
ORIGINAL-LIST<<list> of <strings>>: A parsed list of strings that may have
                                    empties.

Returns
=======
A <<list> of <strings>> including every non-empty-string from ORIGINAL-LIST.

Impurities
==========
None."
  (filter (lambda (x) (not (string= "" x)))
          original-list))
(define (iteratively-replace-regexp regexp original-list replacement-list)
  "Replace all matches for REGEXP in each member of ORIGINAL-LIST with each
member of REPLACEMENT-LIST.

This is a CALCULATION.

Arguments
=========
REGEXP<string>: A POSIX-extended regular expression string, escaped for guile
scheme.

ORIGINAL-LIST<<list> of <strings>>: The original list, containing parts that
match REGEXP.

REPLACEMENT-LIST<<list> of <strings>>: The list of substitutions for REGEXP,
that will replace matches in ORIGINAL-LIST.

Returns
=======

A <<list> of <strings>> representing each member of ORIGINAL-LIST with each
member of REPLACEMENT-LIST in the place of REGEXP matches. Will return a list
of size (* (length original-list) (length replacement-list)).

Impurities
==========
None."
  (apply append (map
                 (lambda (x)
                   (map (lambda (y)
                          (replace-regexp-in-string regexp x y))
                        original-list)) replacement-list)))
