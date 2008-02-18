# post.mk - Include after user code.

# The base of the standard targets.
quagmire/do-nothing: ; @true
.PHONY: quagmire/do-nothing

# The standard user-visible targets.  Note that we don't want to
# supply rules for these directly; we want to let the user supply his
# own as needed.
all: quagmire/do-nothing
install-exec: quagmire/do-nothing
install-data: quagmire/do-nothing
install: install-exec install-data | all
installdirs: quagmire/do-nothing
mostlyclean: quagmire/do-nothing
clean: quagmire/do-nothing | mostlyclean
distclean: quagmire/do-nothing | clean
check: quagmire/do-nothing
installcheck: quagmire/do-nothing
.PHONY: all install-exec install-data install mostlyclean clean \
	distclean installdirs check installcheck

# This tracks all the directories into which we may install an object.
# This is used for 'installdirs'.
quagmire/all-install-dirs :=

include $(quagmire_dir)/util.mk

include $(quagmire_dir)/once.mk
include $(quagmire_dir)/checks.mk
# Could be include-once...?
include $(quagmire_dir)/checkfunc.mk
include $(quagmire_dir)/checkheader.mk
include $(quagmire_dir)/configh.mk
include $(quagmire_dir)/sources.mk

# Could be lazily included once.
include $(quagmire_dir)/pkgconfig.mk
include $(quagmire_dir)/install.mk
include $(quagmire_dir)/aggregate.mk

ifdef PROGRAMS
include $(quagmire_dir)/program.mk
$(foreach _prog,$(PROGRAMS),$(eval $(call quagmire/program,$(_prog))))
endif

ifdef LIBRARIES
include $(quagmire_dir)/staticlib.mk
$(foreach _lib,$(LIBRARIES),$(eval $(call quagmire/library,$(_lib))))
endif

ifdef SHARED_LIBRARIES
include $(quagmire_dir)/sharedlib.mk
$(foreach _lib,$(SHARED_LIBRARIES),$(eval $(call quagmire/sharedlibrary,$(_lib))))
endif

# No point in doing this conditionally since we will always have at
# least one: the Makefile.
include $(quagmire_dir)/configuration.mk
$(foreach _file,$(quagmire_config_files),$(eval $(call quagmire/config.status,$(subst :, ,$(_file)))))

include $(quagmire_dir)/compile.mk
include $(quagmire_dir)/tags.mk
include $(quagmire_dir)/data.mk

# Directory variables are those ending in 'dir'.
quagmire/dir-vars := $(filter %dir,$(.VARIABLES))

# Install data.
$(foreach _dir,$(quagmire/dir-vars),$(if $($(_dir)_DATA),$(eval $(call quagmire/data-directory,$(_dir),data,DATA))))

# Install scripts.
$(foreach _dir,$(quagmire/dir-vars),$(if $($(_dir)_SCRIPTS),$(eval $(call quagmire/data-directory,$(_dir),exec,SCRIPTS))))

include $(quagmire_dir)/help.mk
include $(quagmire_dir)/dist.mk

# Create targets that make install directories.  We use sort to
# uniquify the list.
$(foreach _dir,$(sort $(quagmire/all-install-dirs)),$(eval $(call quagmire/one-install-dir,$(_dir))))
