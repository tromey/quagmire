# data.mk - Install data files.

# quagmire/data-directory DIR-NAME EXEC-OR-DATA PRIMARY
# Install some files.
# DIR-NAME is the base name of the variable holding the directory,
#   e.g., "data" where the variable is "datadir".
# EXEC-OR-DATA is "exec" for install-exec, "data" for install-data.
# PRIMARY is the automake "primary", usually DATA or SCRIPTS
define quagmire/data-directory

all: $$($(1)_$(3))

install/$(2)-dir-$(1): $$($(1)_$(3)) | $$(DESTDIR)$$($(1)dir)
	@list='$$($(1)_$(3))'; \
	for f in $$$$list; do \
	  if test -f $$(srcdir)/$$$$f; then src=$$(srcdir)/$$$$f; else src=$$$$f; fi; \
	  dest=`basename $$$$f`; \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "$$(INSTALL)$(if $(findstring DATA,$(3)), -m 0644) $$$$src $$(DESTDIR)$$($(1)dir)/$$$$dest"); \
	  $$(INSTALL)$(if $(findstring DATA,$(3)), -m 0644) $$$$src $$(DESTDIR)$$($(1)dir)/$$$$dest; \
	done
install-$(2): install/$(2)-dir-$(1)

uninstall/$(2)-dir-$(1):
	@list='$$($(1)_$(3))'; \
	for f in $$$$list; do \
	  dest=`basename $$$$f`; \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "rm -f $$(DESTDIR)$$($(1)dir)/$$$$dest"); \
	  rm -f $$(DESTDIR)$$($(1)dir)/$$$$dest; \
	done
uninstall: uninstall/$(2)-dir-$(1)

.PHONY: install/$(2)-dir-$(1) uninstall/$(2)-dir-$(1)

quagmire/all-install-dirs += $$($(1)dir)

endef
