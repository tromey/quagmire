# post.mk - Include after user code.

# FIXME: can't seem to set this with ?= here... ?
.DEFAULT_GOAL = all

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

include once.mk
include checks.mk
# Could be include-once...?
include checkfunc.mk
include configh.mk
include sources.mk

include defcompiler.mk

# Could be lazily included once.
include pkgconfig.mk
include aggregate.mk

ifdef PROGRAMS
include program.mk
$(foreach _prog,$(PROGRAMS),$(eval $(call quagmire/program,$(_prog))))
endif

ifdef LIBRARIES
include staticlib.mk
$(foreach _lib,$(LIBRARIES),$(eval $(call quagmire/library,$(_lib))))
endif

ifdef SHARED_LIBRARIES
include sharedlib.mk
$(foreach _lib,$(SHARED_LIBRARIES),$(eval $(call quagmire/sharedlibrary,$(_lib))))
endif

# ifdef CONFIG_HEADERS
# $(foreach _doth,$(CONFIG_HEADERS),$(eval $(call quagmire/config.h,$(_doth))))
# endif

include compile.mk
include tags.mk
include data.mk

include help.mk

installdirs:
	@list='$(quagmire/all-install-dirs)'; \
	for dir in $$list; do \
	  mkdir $(DESTDIR)$$dir; \
	done
.PHONY: installdirs
