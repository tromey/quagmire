# aggregate.mk - Build something requiring object files.

define quagmire/aggregate

# Objects we automatically derive from sources.
$(1)_BASE_OBJECTS := $$(call quagmire/source2obj,$$($(1)_SOURCES))

# All objects, including any the user added on.
$(1)_OBJECTS := $$($(1)_BASE_OBJECTS) $$($(1)_EXTRA_OBJECTS)

# Expand the config headers for this aggregate.
$(foreach _doth,$($(1)_CONFIG_HEADERS),$(call quagmire/expand-once,header-$(_doth),$(call quagmire/config.h,$(_doth))))

# Look for package requirements.
$(if $($(1)_PACKAGES),$(call quagmire/package,$(1),$(1)_PACKAGES))

# Add the sources to the list of all sources.  This is used to
# determine which language rules must be made available.
# FIXME this yields the wrong result if the user needs an explicit rule.
quagmire/all_sources += $(call quagmire/filter-ignorable,$$($(1)_SOURCES))

# The objects of this program have a pre-dependency on the config
# headers.
$(if $($(1)_CONFIG_HEADERS),$$($(1)_OBJECTS): | $($(1)_CONFIG_HEADERS))

# If the aggregate has an install directory, build it with 'all'.
# Otherwise, don't build it, and assume that if it is needed,
# something will depend on it.  This lets us handle 'make check'
# nicely as well.

ifdef $(1)_INSTALLDIR
# Normal case.
all: $(1)

# Install the program if necessary.
$(if $($(1)_INSTALLDIR),$(call quagmire/install,$(1)))

endif


# Remove the program on 'mostlyclean'.
mostlyclean/$(1):
	rm -f $(1) $$($(1)_OBJECTS)
.PHONY: mostlyclean/$(1)
mostlyclean: mostlyclean/$(1)

endef
