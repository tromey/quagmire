# data.mk - Install data files.

# quagmire/data-directory DIR-NAME EXEC-OR-DATA PRIMARY PREFIX
# Install some files.
# DIR-NAME is the base name of the variable holding the directory,
#   e.g., "data" where the variable is "datadir".
# EXEC-OR-DATA is "exec" for install-exec, "data" for install-data.
# PRIMARY is the automake "primary", usually DATA or SCRIPTS
# PREFIX is a prefix used for the variable name, either empty,
# "nodist_" or "dist_".
define quagmire/data-directory

all: $$($(4)$(1)_$(3))

install/$(2)-dir-$(4)$(1): $$($(4)$(1)_$(3)) | $$(DESTDIR)$$($(1)dir)
	@list='$$($(4)$(1)_$(3))'; \
	for f in $$$$list; do \
	  if test -f $$(srcdir)/$$$$f; then src=$$(srcdir)/$$$$f; else src=$$$$f; fi; \
	  dest=`basename $$$$f`; \
	  $(call quagmire/do,$$(INSTALL)$(if $(findstring DATA,$(3)), -m 0644) $$$$src $$(DESTDIR)$$($(1)dir)/$$$$dest); \
	done
install-$(2): install/$(2)-dir-$(4)$(1)

uninstall/$(2)-dir-$(4)$(1):
	@list='$$($(4)$(1)_$(3))'; \
	for f in $$$$list; do \
	  dest=`basename $$$$f`; \
	  $(call quagmire/do,rm -f $$(DESTDIR)$$($(1)dir)/$$$$dest); \
	done
uninstall: uninstall/$(2)-dir-$(4)$(1)

.PHONY: install/$(2)-dir-$(4)$(1) uninstall/$(2)-dir-$(4)$(1)

quagmire/all-install-dirs += $$($(1)dir)

ifeq ($(4),dist_)
quagmire/dist_sources += $$($(4)$(1)_$(3))
endif

endef
