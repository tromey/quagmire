# compile.mk - Emit needed compilation rules.

ifdef quagmire/all_sources

include $(quagmire_dir)/defcompiler.mk
include $(quagmire_dir)/deps.mk

# C.
ifneq ($(filter %.c,$(quagmire/all_sources)),)
include $(quagmire_dir)/lang-c.mk
endif

# C++.
ifneq ($(filter %.cxx %.C %.cpp %.cc,$(quagmire/all_sources)),)
include $(quagmire_dir)/lang-cxx.mk

$(eval $(call quagmire/defcompiler,$(call quagmire/tool-name,$(CXX)),$(CXX)))
endif

ifneq ($(filter %.cxx,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,cxx))
endif

ifneq ($(filter %.C,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,C))
endif

ifneq ($(filter %.cpp,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,cpp))
endif

ifneq ($(filter %.cc,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,cc))
endif

# Other languages here.

# Pre-create dependency directories.
quagmire/all_objects := $(call quagmire/source2obj,$(quagmire/all_sources))
quagmire/all_objdeps := $(dir $(patsubst %.$(OBJEXT),$(DEPDIR)/%,$(quagmire/all_objects)))

$(quagmire/all_objects): | $(quagmire/all_objdeps)

$(sort $(quagmire/all_objdeps)):
	@mkdir -p $@

# Include dependency files.
-include $(addsuffix .$(OBJEXT),$(quagmire/all_objdeps))

endif
