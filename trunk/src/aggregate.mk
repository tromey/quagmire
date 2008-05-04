# aggregate.mk - Build something requiring object files.

# quagmire/aggregate NAME DIR [SUFFIX] [TRANSFORM]
# NAME is the name of an aggregate object.
# DIR is the install directory base name, e.g. "bin" or "check".
# SUFFIX is an optional argument that appended to the aggregate's name.
# TRANSFORM is an optional argument; if non-empty means to apply
# program name transform at install time.
# This function updates the list of sources, arranges for the
# aggregate's objects to be built, and for the aggregate itself to be
# installed.
define quagmire/aggregate

# All sources for this aggregate.
quagmire/$(1)_SOURCES := $$($(1)_SOURCES) $$(dist_$(1)_SOURCES) $$(nodist_$(1)_SOURCES)

# Objects we automatically derive from sources.
$(1)_BASE_OBJECTS := $$(call quagmire/source2obj,$$(quagmire/$(1)_SOURCES))

# All objects, including any the user added on.
$(1)_OBJECTS := $$($(1)_BASE_OBJECTS) $$($(1)_EXTRA_OBJECTS)

# Expand the config headers for this aggregate.
$(foreach _doth,$($(1)_CONFIG_HEADERS),$(call quagmire/expand-once,header-$(_doth),$(call quagmire/config.h,$(_doth))))

# Look for package requirements.
$(if $($(1)_PACKAGES),$(call quagmire/package,$(1),$(1)_PACKAGES,$(3)))

# Add the sources to the list of all sources.  This is used to
# determine which language rules must be made available.
# FIXME this yields the wrong result if the user needs an explicit rule.
quagmire/all_sources += $(call quagmire/filter-ignorable,$$(quagmire/$(1)_SOURCES))

# Update the distributed source list as well.
quagmire/dist_sources += $$($(1)_SOURCES) $$(dist_$(1)_SOURCES)

# The objects of this program have a pre-dependency on the config
# headers and on all the source files.
$$($(1)_OBJECTS): | $($(1)_CONFIG_HEADERS) $$(quagmire/$(1)_SOURCES)


# Most aggregates are built by all, except when 'check' prefix is
# used.
ifneq ($(2),check)
# Normal case.
all: $(1)$(3)
else
# Only build for make check.
check: $(1)$(3)
endif

# Install the program if necessary.
ifneq ($(quagmire/instpfx-$(2)),none)
$(call quagmire/install,$(1),$(2),$(3),$(4))
endif

# Remove the program on 'mostlyclean'.
mostlyclean/$(1):
	rm -f $(1)$(3) $$($(1)_OBJECTS)
.PHONY: mostlyclean/$(1)
mostlyclean: mostlyclean/$(1)

endef


# quagmire/apply-aggregate FILE BASE SUBR
# Apply a subroutine to each aggregate in a list.
# BASE is the install directory basename, e.g. "bin".
# PRIMARY is the primary to look at.
# SUBR is the function to apply to each aggregate.
define quagmire/apply-aggregate
$(foreach _aggr,$($(1)_$(2)),$(call $(3),$(_aggr),$(1)))
endef
