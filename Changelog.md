# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this projectadheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial Project Files.
- Integration with [guile-hall][guile-hall].
- [Workaround][high-uid-issue] to a limitation in [GNU tar][gnu-tar].

### Changed
- Various minor changes to templates.
- `guix.scm` now uses `local-file` to load the tarball.
- Actual license in LICENSE.

### Removed
- Unneeded temporary files from git repo.

[Unreleased]: https://git.sr.ht/~yewscion/guile-cdr255/log
[guile-hall]: https://gitlab.com/a-sassmannshausen/guile-hall
[high-uid-issue]: https://gitlab.com/a-sassmannshausen/guile-hall/-/issues/61
[gnu-tar]: https://www.gnu.org/software/tar/

<!-- Local Variables: -->
<!-- mode: markdown -->
<!-- coding: utf-8-unix -->
<!-- End: -->
