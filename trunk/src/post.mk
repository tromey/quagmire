# post.mk - Include after user code.

# The base of the standard rules.
quagmire/do-nothing: ; @true
.PHONY: quagmire/do-nothing

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

# Initial value.
quagmire/all-install-dirs :=

include $(quagmire_dir)/once.mk
include $(quagmire_dir)/checks.mk
# Could be include-once...?
include $(quagmire_dir)/checkfunc.mk
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
# least one.
include $(quagmire_dir)/configuration.mk
$(foreach _file,$(quagmire_config_files),$(eval $(call quagmire/config.status,$(subst :, ,$(_file)))))

# ifdef CONFIG_HEADERS
# $(foreach _doth,$(CONFIG_HEADERS),$(eval $(call quagmire/config.h,$(_doth))))
# endif

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

# Use sort to uniquify here.
$(foreach _dir,$(sort $(quagmire/all-install-dirs)),$(eval $(call quagmire/one-install-dir,$(_dir))))
