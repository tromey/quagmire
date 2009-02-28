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
$(eval $(call quagmire/cxx-rules,$(call quagmire/tool-name,$(CXX)),cxx))
endif

ifneq ($(filter %.C,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,$(call quagmire/tool-name,$(CXX)),C))
endif

ifneq ($(filter %.cpp,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,$(call quagmire/tool-name,$(CXX)),cpp))
endif

ifneq ($(filter %.cc,$(quagmire/all_sources)),)
$(eval $(call quagmire/cxx-rules,$(call quagmire/tool-name,$(CXX)),cc))
endif

# Other languages here.

# Pre-create dependency directories.
quagmire/all_objects := $(call quagmire/source2obj,$(quagmire/all_sources))
quagmire/all_depdirs := $(dir $(patsubst %.$(OBJEXT),$(DEPDIR)/%,$(quagmire/all_objects)))

$(quagmire/all_objects): | $(quagmire/all_depdirs)

$(filter-out $(DEPDIR),$(sort $(quagmire/all_depdirs))):
	@mkdir -p $@

# Include dependency files.
-include $(patsubst %.$(OBJEXT),$(DEPDIR)/%.Po,$(quagmire/all_objects))

# Arrange for object files to pre-depend on configuration headers.
quagmire/config_headers =
$(foreach _file,$(quagmire_header_files),$(eval quagmire/config_headers += $$(firstword $$(subst :, ,$(_file)))))

$(quagmire/all_objects): | $(quagmire/config_headers)


# Create directories for object files.  Note that we have to use full
# paths here, to avoid VPATH handling.
$(foreach _dir,$(abspath $(filter-out ./,$(sort $(dir $(quagmire/all_objects))))),$(eval $(call quagmire/create-directory,$(_dir))))

# Make each object pre-depend on its directory.  Again, we have to use
# full paths.
$(foreach _file,$(quagmire/all_objects),$(if $(filter-out ./,$(dir $(_file))),$(eval $(_file): | $(abspath $(dir $(_file))))))

endif
