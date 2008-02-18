# configh.mk - Rule for a config.h.

# quagmire/config.h HEADER
# Define a rule to create the config.h-style header named HEADER.
# This is made by searching for a series of functions.
define quagmire/config.h

$(if $($(1)_FUNCTIONS),,$(error $(1) specified but $(1)_FUNCTIONS is empty))

# A couple convenience variables.
quagmire/cfgh-header := $(call quagmire/tool-name,$(1))
quagmire/cfgh-stamp := \
	.quagmire/stamp-$$(quagmire/cfgh-header)

# This is used to ensure that we re-compute config.h whenever the list
# of functions changes.  FIXME: it would be nice not to have to run
# this on every single build.
$$(quagmire/cfgh-stamp): quagmire/do-nothing
	@echo '$$($(1)_FUNCTIONS)' > $$@.tmp
	@$(call quagmire/move-if-change,$$@.tmp,$$@)

$(1): $$(quagmire/cfgh-stamp) $$(foreach _fn,$$($(1)_FUNCTIONS),$$(call quagmire/checkfunc,$$(_fn)))
ifeq (,$(findstring s,$(MAKEFLAGS)))
	@echo "Creating $(1)"
endif
	@rm -f $(1)
	@cat $$(foreach _fn,$$($(1)_FUNCTIONS),$$(call quagmire/checkfunc,$$(_fn))) > $(1).tmp
	@mv $(1).tmp $(1)

# Delete config headers on distclean.
distclean/$(1):
	rm -f $(1)
.PHONY: distclean/$(1)
distclean: distclean/$(1)

endef
