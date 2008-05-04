# program.mk - Build a single program.

# quagmire/program NAME DIRNAME
# Define a program named NAME.
# DIRNAME is the base of the install directory, e.g. "bin" or "check".
define quagmire/program
# FIXME: consider checking existence, not empty-ness
$(if $($(1)_SOURCES),,$(error Program $(1) specified but $(1)_SOURCES not defined))

$(call quagmire/aggregate,$(1),$(2),$(EXEEXT),yes)

# How to link this program.
# FIXME: try to compute it more intelligently?
$(1)_LINK ?= $$(if $$(filter %.cxx %.C %.cpp %.cc,$$($(1)_SOURCES)),$$(LINK.cc),$$(LINK.c))

# The rule to build the program.
# FIXME: exeext.  that requires a rewriting addition to install.
$(1)$(EXEEXT): $$($(1)_OBJECTS) $$(filter $(quagmire/libs-ext-pattern),$$($(1)_LIBS))
	$$($(1)_LINK) $(LDFLAGS) -o $$@ $$($(1)_OBJECTS) $$($(1)_LIBS)

endef
