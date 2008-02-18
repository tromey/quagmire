# program.mk - Build a single program.

# quagmire/program NAME
# Define a program named NAME.
define quagmire/program
# FIXME: consider checking existence, not empty-ness
$(if $($(1)_SOURCES),,$(error Program $(1) specified but $(1)_SOURCES not defined))

$(call quagmire/aggregate,$(1))

# How to link this program.
# FIXME: try to compute it more intelligently?
$(1)_LINK ?= $$(LINK.c)

# The rule to build the program.
# FIXME: exeext.  that requires a rewriting addition to install.
$(1): $$($(1)_OBJECTS)
	$$($(1)_LINK) $(LDFLAGS) -o $$@ $$($(1)_OBJECTS) $$($(1)_LIBS)

endef