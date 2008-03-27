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
	$(wildcard $(srcdir)/$(quagmire_relative)/*.mk) \
	$(wildcard $(srcdir)/$(quagmire_relative)/*depcomp)

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

dist: $(addprefix quagmire/dist-,$(DIST_FORMATS))
	$(if $(DIST_FORMATS),,$(error DIST_FORMATS is empty))
	$(am__remove_distdir)
.PHONY: dist


distcheck-hook:
.PHONY: distcheck-hook

DISTCHECK_CONFIGURE_FLAGS ?=

# FIXME: should 'make dvi' in the check.  should copy over commentary
# from automake.
# FIXME: support DIST_ARCHIVES stuff from automake as well
distcheck:
	$(MAKE) DIST_FORMATS=bzip2 dist
	bunzip2 -c $(distdir).tar.bz2 | tar xf -
	chmod -R a-w $(distdir); chmod a+w $(distdir)
	mkdir $(distdir)/_build
	mkdir $(distdir)/_inst
	chmod a-w $(distdir)
	dc_install_base=`cd $(distdir)/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
	  && dc_destdir="$${TMPDIR-/tmp}/am-dc-$$$$/" \
	  && $(MAKE) distcheck-hook \
	  && cd $(distdir)/_build \
	  && ../configure --srcdir=.. --prefix="$$dc_install_base" \
	    $(DISTCHECK_CONFIGURE_FLAGS) \
	  && $(MAKE) \
	  && $(MAKE) dvi \
	  && $(MAKE) check \
	  && $(MAKE) install \
	  && $(MAKE) installcheck \
	  && $(MAKE) uninstall \
	  && $(MAKE) distuninstallcheck_dir="$$dc_install_base" \
	        distuninstallcheck \
	  && chmod -R a-w "$$dc_install_base" \
	  && ({ \
	       (cd ../.. && umask 077 && mkdir "$$dc_destdir") \
	       && $(MAKE) DESTDIR="$$dc_destdir" install \
	       && $(MAKE) DESTDIR="$$dc_destdir" uninstall \
	       && $(MAKE) DESTDIR="$$dc_destdir" \
	            distuninstallcheck_dir="$$dc_destdir" distuninstallcheck; \
	      } || { rm -rf "$$dc_destdir"; exit 1; }) \
	  && rm -rf "$$dc_destdir" \
	  && $(MAKE) DIST_FORMATS=bzip2 dist \
	  && rm -rf $(distdir).tar.bz2 \
	  && $(MAKE) distcleancheck
	$(am__remove_distdir)
	@(echo "$(distdir).tar.bz2 archive ready for distribution"

.PHONY: distcheck

distuninstallcheck_listfiles = find . -type f -print
distuninstallcheck:
	@cd $(distuninstallcheck_dir) \
	&& test `$(distuninstallcheck_listfiles) | wc -l` -le 1 \
	   || { echo "ERROR: files left after uninstall:" ; \
	        if test -n "$(DESTDIR)"; then \
	          echo "  (check DESTDIR support)"; \
	        fi ; \
	        $(distuninstallcheck_listfiles) ; \
	        exit 1; } >&2
.PHONY: distuninstallcheck

distcleancheck_listfiles = find . -type f -print
distcleancheck: distclean
	@if test '$(srcdir)' = . ; then \
	  echo "ERROR: distcleancheck can only run from a VPATH build" ; \
	  exit 1 ; \
	fi
	@test `$(distcleancheck_listfiles) | wc -l` -eq 0 \
	  || { echo "ERROR: files left in build directory after distclean:" ; \
	       $(distcleancheck_listfiles) ; \
	       exit 1; } >&2
.PHONY: distcleancheck
