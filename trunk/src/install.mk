# install.mk - Install something.

# FIXME -- maybe path_prog equivalent here?
INSTALL ?= install

# quagmire/install aggregate-name
define quagmire/install

$(1)_INSTALLNAME ?= $(1)

install/$(1): $(1) | $$(DESTDIR)$$($(1)_INSTALLDIR)
	$$(INSTALL) $(1) $$(DESTDIR)$$($(1)_INSTALLDIR)/$$($(1)_INSTALLNAME)

uninstall/$(1):
	-rm -f $$(DESTDIR)$$($(1)_INSTALLDIR)/$$($(1)_INSTALLNAME)

.PHONY: install/$(1) uninstall/$(1)
install-exec: install/$(1)
uninstall: uninstall/$(1)

quagmire/all-install-dirs += $$($(1)_INSTALLDIR)

endef


# quagmire/one-install-dir DIR
# Make a single install directory.
define quagmire/one-install-dir

$$(DESTDIR)$(1):
	mkdir -p $$@

installdirs: $$(DESTDIR)$(1)

endef
