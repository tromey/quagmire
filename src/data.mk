# data.mk - Install data files.

# quagmire/data-directory DIR-VAR EXEC-OR-DATA PRIMARY
# Install some files.
# DIR-VAR is the name of the variable holding the directory,
#   e.g., "datadir".
# EXEC-OR-DATA is "exec" for install-exec, "data" for install-data.
# PRIMARY is the automake "primary", usually DATA or SCRIPTS
define quagmire/data-directory

all: $$($(1)_$(3))

# FIXME: the echo is old-style ... need to deal with the verbosity
# thing.  Unlike automake we don't use a leading space, since that
# looks weird with the other for loops.
install/$(2)-dir-$(1): $$($(1)_$(3)) | $$(DESTDIR)$$($(1))
	@list='$$($(1)_$(3))'; \
	for f in $$$$list; do \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "$$(INSTALL) $$$$f $$(DESTDIR)$$($(1))/$$$$f"); \
	  $$(INSTALL) $$$$f $$(DESTDIR)$$($(1))/$$$$f; \
	done
install-$(2): install/$(2)-dir-$(1)

# FIXME: the echo again
uninstall/$(2)-dir-$(1):
	@list='$$($(1)_$(3))'; \
	for f in $$$$list; do \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "rm -f $$(DESTDIR)$$($(1))/$$$$f"); \
	  rm -f $$(DESTDIR)$$($(1))/$$$$f; \
	done
uninstall: uninstall/$(2)-dir-$(1)

.PHONY: install/$(2)-dir-$(1) uninstall/$(2)-dir-$(1)

quagmire/all-install-dirs += $$($(1))

endef
