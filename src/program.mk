# program.mk - Build a single program.

# @deffn quagmire/program name
# Define a program named @var{name}.
#
# A program can have several attributes, each indicated by a variable
# whose name is constructed from the program name.
# @itemize @fixme
# @item @var{name}_SOURCES
# @item @var{name}_OBJECTS
# @item @var{name}_INSTALLDIR
# @item @var{name}_INSTALLNAME
# @item @var{name}_LIBS
# @item @var{name}_CONFIG_HEADERS
# @end itemize
# FIXME: how to handle host/target/build programs?
# FIXME: per-program CFLAGS, etc?  [static pattern rules I guess]
#   ... esp renaming intermediate objects
#
# This rule uses several variables which can be overriden, either
# globally or using a target-specific setting:
# ... LINK
# ... .. maybe CC, CFLAGS
# ... LDFLAGS
# ... INSTALL -- mention name of install rule
# @end defun
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
