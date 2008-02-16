# post.mk - Include after user code.

# The base of the standard rules.
quagmire/do-nothing: ; @true
.PHONY: quagmire/do-nothing

all: quagmire/do-nothing
install-exec: quagmire/do-nothing
install-data: quagmire/do-nothing
install: install-exec install-data | all
mostlyclean: quagmire/do-nothing
clean: quagmire/do-nothing | mostlyclean
distclean: quagmire/do-nothing | clean
.PHONY: all install-exec install-data install mostlyclean clean distclean

# Initial value.
quagmire/all-install-dirs :=

include $(quagmire_dir)/once.mk
include $(quagmire_dir)/checks.mk
# Could be include-once...?
include $(quagmire_dir)/checkfunc.mk
include $(quagmire_dir)/configh.mk
include $(quagmire_dir)/sources.mk

include $(quagmire_dir)/defcompiler.mk

# Could be lazily included once.
include $(quagmire_dir)/pkgconfig.mk
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

include $(quagmire_dir)/help.mk

installdirs:
	@list='$(quagmire/all-install-dirs)'; \
	for dir in $$list; do \
	  mkdir $(DESTDIR)$$dir; \
	done
.PHONY: installdirs
