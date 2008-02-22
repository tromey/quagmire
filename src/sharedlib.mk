# sharedlib.mk - Build a shared library.

# quagmire/sharedlibrary NAME DIRNAME
# Define a shared library named NAME.
define quagmire/sharedlibrary
$(if $(1)_SOURCES,,$(error Library $(1) specified but $(1)_SOURCES not defined))

$(call quagmire/aggregate,$(1),$(2))

# FIXME: configury checks.
# FIXME: name of the library itself?

# Ensure flags are set.  FIXME: should be per-language.
$(1): CFLAGS += -fPIC
$(1): CXXFLAGS += -fPIC

# How to link this program.
# FIXME: try to compute it more intelligently?
$(1)_LINK ?= $$(LINK.c)

# The rule to build the library.
$(1): $$($(1)_OBJECTS)
	$$($(1)_LINK) $(LDFLAGS) -shared -o $$@ $$($(1)_OBJECTS) $$($(1)_LIBS)

endef
