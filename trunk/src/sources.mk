# sources.mk - Transform source list to object list.

# quagmire/filter-ignorable LIST
# Filter out ignorable files from LIST.
quagmire/filter-ignorable = $(filter-out %.h %.hh %.hxx %.H,$(1))

# quagmire/source2obj SOURCE-LIST
# Transform a list of sources to a list of object files.  The input
# list can contain any source files.  Header files in the list are
# ignored.  This simply removes the ignored files and then replaces
# all remaining suffixes with the object extension.  This way, users
# can easily extend the list of suffixes -- nothing special needs to
# be done here.
# FIXME: user-specified ignore list.
quagmire/source2obj = $(addsuffix .$(OBJEXT),$(basename $(call quagmire/filter-ignorable,$(1))))
