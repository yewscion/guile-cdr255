;;; Variables: guile-cdr255 https://sr.ht/~yewscion/guile-cdr255 Yewscion's Guile Library
(use-modules
 ;;; These are my commonly needed modules; remove unneeded ones.
 (guix packages)
 ((guix licenses) #:prefix license:)
 (guix download)
 (guix build-system gnu)
 (gnu packages)
 (gnu packages autotools)
 (gnu packages pkg-config)
 (gnu packages texinfo)
 (gnu packages guile)
 (gnu packages guile-xyz)
 (gnu packages admin)
 (guix gexp))

(package
  (name "guile-cdr255")
  (version "0.2.0")
  (source (local-file (string-append "./"
                                     name
                                     "-"
                                     version
                                     ".tar.bz2")))
  (build-system gnu-build-system)
  (arguments
   `(#:phases
     (modify-phases
      %standard-phases
      (add-before
       'check 'debug-tests
       (lambda* (#:key inputs #:allow-other-keys)
         (map (lambda (x)
                (display (string-append "Checking " x "…\n"))
                (system (string-append "cat " x)))
              '("./pre-inst-env"
                "./build-aux/test-driver.scm"
                "./tests/maintests.scm"))
         (system "./test-env --quiet-stderr guile --no-auto-compile -L . -e main ./build-aux/test-driver.scm")))
      ;; Java and Guile programs don't need to be stripped.
      (delete 'strip))))
  (native-inputs (list autoconf automake pkg-config texinfo tree))
  (inputs (list guile-3.0-latest))
  (synopsis "Yewscion's Guile Library")
  (description
   (string-append
    "A grab-bag collection of procedures I use in my projects."))
  (home-page
   "https://sr.ht/~yewscion/guile-cdr255")
  (license license:agpl3+))
;; Local Variables:
;; mode: scheme
;; End:
