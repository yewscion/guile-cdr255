# Template Variables: guile-cdr255
################################################################################

# Set Up Guile Variables

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat

## Directory for Uncompiled Guile Modules
moddir=$(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)

## Directory for Compiled Guile Modules
godir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

## Same as above, but for transient Compiled Guile Modules
ccachedir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

## Handle substitution of fully-expanded Guile Autoconf variables.
do_subst = $(SED)					\
  -e 's,[@]GUILE[@],$(GUILE),g'				\
  -e 's,[@]guilemoduledir[@],$(guilemoduledir),g'	\
  -e 's,[@]guileobjectdir[@],$(guileobjectdir),g'	\
  -e 's,[@]localedir[@],$(localedir),g'

## Handle Special Build Reqs
SUFFIXES = .scm .go
.scm.go:
	$(AM_V_GEN)$(top_builddir)/pre-inst-env $(GUILE_TOOLS) \
	compile $(GUILE_WARNINGS) -o "$@" "$<"

################################################################################

# Set Up Other Variables

## Enable local m4 cache
ACLOCAL_AMFLAGS = -I m4

## Documentation Compilation
info_TEXINFOS = doc/guile-cdr255.texi

## Extra Files for Distribution
EXTRA_DIST =  Changelog.md \
              LICENSE \
              COPYING \
              NEWS \
              AUTHORS \
              README.org \
              README.md \
              Changelog.md \
              ChangeLog \
              COPYING \
              m4/tar-edited.m4 \
              guix.scm \
              pre-inst-env.in \
              doc/version.texi.in \
              doc/fdl-1.3.texi \
              doc/procedure-types.texi

## Cleaning Up

### Clean Up Compiled Guile Modules
clean-go:
	-$(RM) $(GOBJECTS)
.PHONY: clean-go

### Filelist for make clean
CLEANFILES =					\
  $(GOBJECTS)					\
  $(TESTS:tests/%.scm=%.log)				
################################################################################
# Define Inputs

# ## Define Guile files
GUILESOURCES = $(srcdir)/cdr255/combinators.scm \
	       $(srcdir)/cdr255/gametools.scm   \
	       $(srcdir)/cdr255/userlib.scm

## Don't Distribute, Don't Install
nodist_noinst_SCRIPTS = pre-inst-env
################################################################################

# Define Outputs

## Compiled Guile Modules (foo.go)
GOBJECTS = $(GUILESOURCES:%.scm=%.go)

## These are the actual Modules to Install, with directory structures intact
## (nobase). They are tied to the appropriate dir above.
nobase_mod_DATA = $(GUILESOURCES) $(NOCOMPSOURCES)
nobase_go_DATA = $(GOBJECTS)

## Make sure source files are installed first, so that the mtime of
## installed compiled files is greater than that of installed source
## files.  See
## <http://lists.gnu.org/archive/html/guile-devel/2010-07/msg00125.html>
## for details.
guile_install_go_files = install-nobase_goDATA
$(guile_install_go_files): install-nobase_modDATA

## Symlinks Can Go Here, along with other end-of-install changes
# install-data-hook:
# 	$(LN_S) $(DESTDIR)$(bindir)/realfile $(DESTDIR)$(bindir)/link
# 	chmod +x $(DESTDIR)$(javadir)/guile-cdr255.jar

## Sources and Extras
EXTRA_DIST += $(GUILESOURCES) $(NOCOMP_SOURCES)
################################################################################

# Tests
TEST_EXTENSIONS = .scm
TESTS = tests/maintests.scm
AM_TESTS_ENVIRONMENT = abs_top_srcdir="$(abs_top_srcdir)" GUILE_AUTO_COMPILE=0

SCM_LOG_DRIVER =                                 \
   $(top_srcdir)/test-env --quiet-stderr         \
   $(GUILE) --no-auto-compile -L $(top_srcdir) -e main \
       $(top_srcdir)/build-aux/test-driver.scm

# Tell 'build-aux/test-driver.scm' to display only source file names,
# not indivdual test names.
AM_SCM_LOG_DRIVER_FLAGS = --brief=yes 
