# sources.mk - Transform source list to object list.

# quagmire/filter-ignorable LIST
# Filter out ignorable files from LIST.
quagmire/filter-ignorable = $(filter-out %.h %.hh %.hxx %.H,$(1))

# quagmire/source2obj SOURCE-LIST
# Transform a list of sources to a list of object files.
# The input list can contain any source files.
# FIXME: how to handle user-provided extensions?
# FIXME: handle OBJEXT?
# Header files in the list are ignored.
# FIXME: user-specified ignore list.
quagmire/source2obj = $(patsubst %.c,%.o,$(call quagmire/filter-ignorable,$(1)))
