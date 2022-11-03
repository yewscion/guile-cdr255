# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][kac], and this project adheres to
[Semantic Versioning][semver].

## [Unreleased]
### Added
- Noting.

### Changed
- Nothing.

### Removed
- Nothing.

## [0.2.0]
### Added
- `(cdr255 userlib)`: A library of utility procedures that are meant to be
  useful for quickly writing user scripts.
- `(cdr255 gamelib)`: A library of game-specific abstractions, for use in
  possible future projects.
- `(cdr255 combinators)`: Implementations of [combinators], for
  easy use in future projects.
- All procedures are fully documented in `doc/guile-cdr255.texi`, which is
  installed alongside the package.
- Actual Unit Testing.
### Changed
- Entire structure of project now adheres to my standards.
- No longer using [guile-hall]. Now using my standard augmented version of
  [autotools].

### Removed
- `bin/` (and `bin/set-gitconfig`, the sole script inside of it), as this
  will be migrated into the [yewscion-scripts] project (as it should be).

## [0.1.1]
### Added
- `configure.ac` file to repo.
- `Makefile.am` file to repo.
- `build-aux/test-driver.scm` file to repo.

### Changed
- Nothing.

### Removed
- Nothing.

## [0.1.0]
### Added
- Initial Project Files.
- Integration with [guile-hall].
- [Workaround][high-uid-issue] to a limitation in [GNU tar][gnu-tar].

### Changed
- Various minor changes to templates.
- `guix.scm` now uses `local-file` to load the tarball.
- Actual license in LICENSE.

### Removed
- Unneeded temporary files from git repo.

[0.2.0]: https://git.sr.ht/~yewscion/guile-cdr255/refs/0.2.0
[0.1.1]: https://git.sr.ht/~yewscion/guile-cdr255/refs/0.1.1
[0.1.0]: https://git.sr.ht/~yewscion/guile-cdr255/refs/0.1.0
[Unreleased]: https://git.sr.ht/~yewscion/guile-cdr255/log
[guile-hall]: https://gitlab.com/a-sassmannshausen/guile-hall
[high-uid-issue]: https://gitlab.com/a-sassmannshausen/guile-hall/-/issues/61
[gnu-tar]: https://www.gnu.org/software/tar/
[combinators]: #
[yewscion-scripts]: #
[autotools]: #
<!-- Local Variables: -->
<!-- mode: markdown -->
<!-- coding: utf-8-unix -->
<!-- End: -->
