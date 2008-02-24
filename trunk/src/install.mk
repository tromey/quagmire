# install.mk - Install something.

# FIXME -- maybe path_prog equivalent here?
INSTALL ?= install

# quagmire/install AGGREGATE-NAME DIR-NAME [SUFFIX]
# FIXME -- need program transform too ... ?
define quagmire/install

$(1)_INSTALLNAME ?= $(1)

install/$(1): $(1) | $$(DESTDIR)$$($(2)dir)
	$$(INSTALL) $(1) $$(DESTDIR)$$($(2)dir)/$$($(1)_INSTALLNAME)$(3)

uninstall/$(1):
	-rm -f $$(DESTDIR)$$($(2)dir)/$$($(1)_INSTALLNAME)$(3)

.PHONY: install/$(1) uninstall/$(1)
install-exec: install/$(1)
uninstall: uninstall/$(1)

quagmire/all-install-dirs += $$($(2)dir)

endef


# quagmire/one-install-dir DIR
# Make a single install directory.
define quagmire/one-install-dir

$$(DESTDIR)$(1):
	mkdir -p $$@

installdirs: $$(DESTDIR)$(1)

endef
