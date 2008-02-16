# dist.mk - make dist
# Lots of this is taken directly from Automake.

# User can override this.
# Valid values are gzip bzip2 zip
# Automake supplies compress and shar as well, but I suspect those are
# obsolete and I have left them out.
DIST_FORMATS ?= bzip2

# The wildcard here is quite bogus.
quagmire/dist-files = Quagmire configure.ac configure \
	$(wildcard $(srcdir)/*.m4) \
	$(wildcard $(srcdir)/quagmire/*.mk) \
	$(wildcard $(srcdir)/quagmire/*depcomp)

# FIXME: common files, quagmire files, texinfo ... anything else?
DISTFILES = $(quagmire/all_sources) $(quagmire/dist-files) $(EXTRA_DIST)

distdir = $(if $(PACKAGE_TARNAME),$(if $(PACKAGE_VERSION),$(PACKAGE_TARNAME)-$(PACKAGE_VERSION),$(error PACKAGE_VERSION not defined)),$(error PACKAGE_TARNAME not defined))

am__remove_distdir = \
  { test ! -d $(distdir) \
    || { find $(distdir) -type d ! -perm -200 -exec chmod u+w {} ';' \
         && rm -fr $(distdir); }; }

# FIXME: gnits-like NEWS checking
distdir:
	$(am__remove_distdir)
	mkdir -p $(distdir)
	@list='$(DISTFILES)'; for file in $$list; do \
	  if test -f $$file || test -d $$file; then d=.; else d=$(srcdir); fi; \
	  if test -d $$d/$$file; then \
	    dir=`echo "/$$file" | sed -e 's,/[^/]*$$,,'`; \
	    if test -d $(srcdir)/$$file && test $$d != $(srcdir); then \
	      cp -pR $(srcdir)/$$file $(distdir)$$dir || exit 1; \
	    fi; \
	    cp -pR $$d/$$file $(distdir)$$dir || exit 1; \
	  else \
	    mkdir -p `dirname $(distdir)/$$file`; \
	    test -f $(distdir)/$$file \
	    || cp -p $$d/$$file $(distdir)/$$file \
	    || exit 1; \
	  fi; \
	done
	-find $(distdir) -type d ! -perm -777 -exec chmod a+rwx {} \; -o \
	  ! -type d ! -perm -444 -links 1 -exec chmod a+r {} \; -o \
	  ! -type d ! -perm -400 -exec chmod a+r {} \; -o \
	  ! -type d ! -perm -444 -exec $(install_sh) -c -m a+r {} {} \; \
	|| chmod -R a+r $(distdir)

.PHONY: distdir

GZIP_ENV = --best
# FIXME: gnu tar dependency
quagmire/dist-gzip: distdir
	tar chof - $(distdir) | GZIP=$(GZIP_ENV) gzip -c >$(distdir).tar.gz
.PHONY: quagmire/dist-gzip

# FIXME: gnu tar dependency
quagmire/dist-bzip2: distdir
	tar chof - $(distdir) | bzip2 -9 -c >$(distdir).tar.bz2
.PHONY: quagmire/dist-bzip2

quagmire/dist-zip: distdir
	rm -f $(distdir).zip
	zip -rq $(distdir).zip $(distdir)
.PHONY: quagmire/dist-zip

# These are all user-visible.
dist-gzip: DIST_FORMATS = gzip
dist-gzip: dist-all
dist-bzip2: DIST_FORMATS = bzip2
dist-bzip2: dist-all
dist-zip: DIST_FORMATS = zip
dist-zip: dist-all

dist: dist-all

dist-all: $(addprefix quagmire/dist-,$(DIST_FORMATS))
	$(if $(DIST_FORMATS),,$(error DIST_FORMATS is empty))
	$(am__remove_distdir)

.PHONY: dist-gzip dist-bzip2 dist-zip dist dist-all
