# staticlib.mk - Build a static library.

# quagmire/library NAME DIRNAME
# Define a static library named NAME.
define quagmire/library
$(if $(or $($(1)_SOURCES),$(dist_$(1)_SOURCES),$(nodist_$(1)_SOURCES)),,$(error Library $(1) specified but no $(1)_SOURCES variable defined))

# Note that we don't use ranlib.  It isn't needed on modern systems.
# If you have a system that needs it, report a bug and we will fix it.
$(call quagmire/aggregate,$(1),$(2))

# The rule to build the library.
$(1): $$($(1)_OBJECTS) $$($(1)_LIBS)
ifneq ($$($(1)_LIBS),)
	@for i in $$($(1)_LIBS); do \
	  dir=`basename $$$${i}x` && \
	  rm -rf $$$${dir} && \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo "mkdir -p $$$${dir} && cd $$$${dir} && ar x ../$$$$i") && \
	  mkdir -p $$$${dir} && cd $$$${dir} && ar x ../$$$$i; \
	done
endif
	$(ARCHIVE) $$@ $$(patsubst %.a, %.ax/*, $$(notdir $$($(1)_LIBS))) $$($(1)_OBJECTS)
ifneq ($$($(1)_LIBS),)
	rm -rf $$(patsubst %.a, %.ax/*, $$(notdir $$($(1)_LIBS)))
endif
endef

AR ?= ar
ARCHIVE ?= $(AR) cru
