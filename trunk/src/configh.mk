# configh.mk - Rule for a config.h.

# quagmire/config.h HEADER
# Define a rule to create the config.h-style header named HEADER.
# This is made by searching for a series of functions.
define quagmire/config.h

# FIXME: need to depend on the list of functions as well.
$(1): $$(foreach _fn,$$($(1)_FUNCTIONS),$$(call quagmire/checkfunc,$$(_fn)))
ifeq (,$(findstring s,$(MAKEFLAGS)))
	@echo "Creating $(1)"
endif
	@rm -f $(1)
	@$$(if $$^,cat $$^ > $(1).tmp,$$(error No config dependencies found for $(1)))
	@mv $(1).tmp $(1)

# Delete config headers on distclean.
distclean/$(1):
	rm -f $(1)
.PHONY: distclean/$(1)
distclean: distclean/$(1)

endef
