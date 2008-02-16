# staticlib.mk - Build a static library.

# quagmire/library NAME
# Define a static library named NAME.
define quagmire/library
$(if $(1)_SOURCES,,$(error Library $(1) specified but $(1)_SOURCES not defined))

# Note that we don't use ranlib.  It isn't needed on modern systems.
# If you have a system that needs it, report a bug and we will fix it.
$(call quagmire/aggregate,$(1))

# The rule to build the library.
$(1): $$($(1)_OBJECTS)
	$(ARCHIVE) $$@ $$($(1)_OBJECTS)

endef

AR ?= ar
ARCHIVE ?= $(AR) cru
