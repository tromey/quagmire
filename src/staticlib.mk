# staticlib.mk - Build a static library.

# quagmire/library NAME DIRNAME
# Define a static library named NAME.
define quagmire/library
$(if $(or $($(1)_SOURCES),$(dist_$(1)_SOURCES),$(nodist_$(1)_SOURCES)),,$(error Library $(1) specified but no $(1)_SOURCES variable defined))

# Prepare a list of convenience libraries that are merged into $(1).
override quagmire/conv-libs = $$(filter-out /%, $$(filter %.a, $$($(1)_LIBS)))
override quagmire/conv-lib-dirs = $$(patsubst %.a, %.ax, $$(notdir $$(quagmire/conv-libs)))
override quagmire/conv-lib-files = $$(patsubst %.a, %.ax/*, $$(notdir $$(quagmire/conv-libs)))

# Note that we don't use ranlib.  It isn't needed on modern systems.
# If you have a system that needs it, report a bug and we will fix it.
$(call quagmire/aggregate,$(1),$(2))

# The rule to build the library.
$(1): $$($(1)_OBJECTS) $$(quagmire/conv-libs)
ifneq ($$(quagmire/conv-libs),)
	@for i in $$(quagmire/conv-libs); do \
	  dir=`basename $$$${i}x` && \
	  rm -rf $$$${dir} && \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "mkdir -p $$$${dir} && cd $$$${dir} && ar x ../$$$$i") && \
	  mkdir -p $$$${dir} && cd $$$${dir} && ar x ../$$$$i; \
	done
endif
	$(ARCHIVE) $$@ $$(quagmire/conv-lib-files) $$($(1)_OBJECTS)
ifneq ($(quagmire/conv-libs),)
	rm -rf $$(quagmire-conv/lib-dirs)
endif
endef

AR ?= ar
ARCHIVE ?= $(AR) cru
