# staticlib.mk - Build a static library.

# @deffn quagmire/library name
# Define a static library named @var{name}.
#
# A library has a few attributes, each indicated by a variable whose
# name is constructed from the library name.
# @itemize @fixme
# @item @var{name}_SOURCES
# @item @var{name}_OBJECTS
# @item @var{name}_INSTALLDIR
# @item @var{name}_INSTALLNAME
# @end itemize
# extra vars
#  archive = ar c
# @end defun
define quagmire/library
$(if $(1)_SOURCES,,$(error Library $(1) specified but $(1)_SOURCES not defined))

$(call quagmire/aggregate,$(1))

# FIXME: configure test for AR?
# FIXME: ranlib, or do we care?

# The rule to build the library.
$(1): $$($(1)_OBJECTS)
	$(ARCHIVE) lib$(1).a $$($(1)_OBJECTS)

endef

AR ?= ar
ARCHIVE ?= $(AR) cru
