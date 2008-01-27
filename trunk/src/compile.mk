# compile.mk - Emit needed compilation rules.

ifdef quagmire/all_sources

include deps.mk

# C.
ifneq ($(filter %.c,$(quagmire/all_sources)),)
include lang-c.mk
endif

# C++.
ifneq ($(filter %.cxx %.C %.cpp %.cc,$(quagmire/all_sources)),)
include lang-cxx.mk
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


# Include dependency files.
-include $(patsubst %.o,$(DEPDIR)/%.Po,$(call quagmire/source2obj,$(quagmire/all_sources)))

endif
