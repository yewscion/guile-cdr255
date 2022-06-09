(hall-description
  (name "cdr255")
  (prefix "guile")
  (version "0.1.1")
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
         (tests ((directory "tests" ((scheme-file "tests")))))
         (programs
           ((directory "scripts" ((in-file "set-gitconfig")))))
         (documentation
           ((text-file "Changelog")
            (directory
              "doc"
              ((texi-file "cdr255") (texi-file "fdl-1.3")))
            (text-file "LICENSE")
            (text-file "NEWS")
            (text-file "AUTHORS")
            (org-file "README")
            (symlink "ChangeLog" "Changelog")
            (symlink "COPYING" "LICENSE")))
         (infrastructure
           ((directory "m4" ((m4-file "tar-edited")))
            (scheme-file "guix")
            (scheme-file "hall")
            (in-file "pre-inst-env")))))
