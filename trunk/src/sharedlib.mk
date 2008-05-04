# sharedlib.mk - Build a shared library.

# quagmire/sharedlibrary NAME DIRNAME
# Define a shared library named NAME.
define quagmire/sharedlibrary
$(if $(or $($(1)_SOURCES),$(dist_$(1)_SOURCES),$(nodist_$(1)_SOURCES)),,$(error Library $(1) specified but no $(1)_SOURCES variable defined))

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
$(1): $$($(1)_OBJECTS) $$(filter $(quagmire/libs-ext-pattern),$$($(1)_LIBS))
	$$($(1)_LINK) $(LDFLAGS) -shared -o $$@ $$($(1)_OBJECTS) $$($(1)_LIBS)

endef
