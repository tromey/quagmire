# install.mk - Install something.

# FIXME -- maybe path_prog equivalent here?
INSTALL ?= install

# quagmire/install AGGREGATE-NAME DIR-NAME [SUFFIX] [TRANSFORM]
# Install AGGREGATE-NAME.  DIR-NAME is the directory prefix.
# SUFFIX is optional; if specified is the suffix to apply to the
# install name.
# TRANSFORM is optional; if not empty means the program name
# transformation should be applied. 
define quagmire/install

# We strip the directory component because we don't want to try to
# install using the build subdirectory, if any.
$(1)_INSTALLNAME ?= $(notdir $(1))
# This does an extra exec in the transform case, but presents a nicer
# command line to the user.
override $(1)_REALINSTALLNAME = $(if $(4),$$(shell echo $$($(1)_INSTALLNAME) | sed '$$(program_transform_name)'),$$($(1)_INSTALLNAME))

install/$(1): $(1) | $$(DESTDIR)$$($(2)dir)
	$$(INSTALL) $(1) $$(DESTDIR)$$($(2)dir)/$$($(1)_REALINSTALLNAME)$(3)

uninstall/$(1):
	-rm -f $$(DESTDIR)$$($(2)dir)/$$($(1)_REALINSTALLNAME)$(3)

.PHONY: install/$(1) uninstall/$(1)
# Aggregates are always installed by install-exec, regardless of
# directory.
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
