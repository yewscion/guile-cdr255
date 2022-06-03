(hall-description
  (name "cdr255")
  (prefix "guile")
  (version "0.1.0")
  (author "Christopher Rodriguez")
  (copyright (2022))
  (synopsis "User library and utility scripts.")
  (description
    (string-append
      "Mostly a guile library, this is a personal project to make maintaining "
      "multiple systems easier and the creation of new scripts easier."))
  (home-page
    "https://sr.ht/~yewscion/guile-cdr255")
  (license agpl3+)
  (dependencies `())
  (files (libraries
           ((directory "cdr255" ((scheme-file "userlib")))))
         (tests ((directory "tests" ())))
         (programs
           ((directory "scripts" ((in-file "set-gitconfig")))))
         (documentation
           ((directory
              "doc"
              ((texi-file "fdl-1.3") (texi-file "cdr255")))))
         (infrastructure
           ((directory "m4" ((m4-file "tar-edited")))
            (scheme-file "guix")
            (scheme-file "hall")))))
