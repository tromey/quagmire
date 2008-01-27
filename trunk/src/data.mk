# data.mk - Install data files.

# Arg: dir-var
define quagmire/data-directory

all: $$($(1)_DATA)

install/data-dir-$(1):
	@list='$$($(1)_DATA)'; \
	for f in $$$$list; do \
	  $$(INSTALL) $$$$f $$(DESTDIR)$$($(1))/$$$$f; \
	done
install-data: install/data-dir-$(1)

uninstall/data-dir-$(1):
	@list='$$($(1)_DATA)'; \
	for f in $$$$list; do \
	  rm -f $$(DESTDIR)$$($(1))/$$$$f; \
	done
uninstall: uninstall/data-dir-$(1)

.PHONY: install/data-dir-$(1) uninstall/data-dir-$(1)

endef

$(eval $(foreach _dir,$(DIRECTORY_VARIABLES),$(call quagmire/data-directory,$(_dir)dir)))
