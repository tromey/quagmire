# sources.mk - Transform source list to object list.

# Filter out ignorable files.
quagmire/filter-ignorable = $(filter-out %.h %.hh %.hxx %.H,$(1))

# @deffun quagmire/source2obj source-list
# Transform a list of sources to a list of object files.
# The input list can contain any source files.
# FIXME: how to handle user-provided extensions?
# FIXME: handle OBJEXT?
# Header files in the list are ignored.
# FIXME: user-specified ignore list.
# @end defun
quagmire/source2obj = $(patsubst %.c,%.o,$(call quagmire/filter-ignorable,$(1)))
