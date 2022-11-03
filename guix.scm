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
   `(#:tests? #t
     #:phases
     (modify-phases
      %standard-phases
      ;; This allows the paths for guile and java to be embedded in the scripts
      ;; in bin/
      (add-before
       'patch-usr-bin-file 'remove-script-env-flags
       (lambda* (#:key inputs #:allow-other-keys)
         (substitute*
          (find-files "./bin")
          (("#!/usr/bin/env -S guile \\\\\\\\")
           "#!/usr/bin/env guile \\"))))
      ;; Java and Guile programs don't need to be stripped.
      (delete 'strip))))
  (native-inputs (list autoconf automake pkg-config texinfo))
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
