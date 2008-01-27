# install.mk - Install something.

# FIXME.
INSTALL ?= /usr/bin/install

# aggregate-name
# FIXME: need to run ranlib for archives, so need extra arg.
define quagmire/install

$(1)_INSTALLNAME ?= $(1)

install/$(1): $(1)
	$$(INSTALL) $(1) $$(DESTDIR)$$($(1)_INSTALLDIR)/$$($(1)_INSTALLNAME)

uninstall/$(1):
	-rm -f $$(DESTDIR)$$($(1)_INSTALLDIR)/$$($(1)_INSTALLNAME)

.PHONY: install/$(1) uninstall/$(1)
install-exec: install/$(1)
uninstall: uninstall/$(1)

# Use sort here to uniquify the list.
quagmire/all-install-dirs := $$(sort $$(quagmire/all-install-dirs) $$($(1)_INSTALLDIR)

endef
