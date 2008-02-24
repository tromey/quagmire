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
check: all
installcheck: quagmire/do-nothing
.PHONY: all install-exec install-data install mostlyclean clean \
	distclean installdirs check installcheck

# Documentation rules.
info: quagmire/do-nothing
dvi: quagmire/do-nothing
ps: quagmire/do-nothing
pdf: quagmire/do-nothing
html: quagmire/do-nothing
all: info

install-info: quagmire/do-nothing
install-dvi: quagmire/do-nothing
install-ps: quagmire/do-nothing
install-pdf: quagmire/do-nothing
install-html: quagmire/do-nothing
install-data: install-info

.PHONY: info dvi ps pdf html \
	install-info install-dvi install-ps install-pdf install-html


# Directory variables are those ending in 'dir', but not srcdir or
# builddir.
quagmire/dir-vars := $(filter-out %srcdir %builddir,$(filter %dir,$(.VARIABLES)))

# Directory prefixes are directory variables with the 'dir' stripped
# off.
quagmire/dir-prefixes := $(patsubst %dir,%,$(quagmire/dir-vars))

ifdef checkdir
$(error Do not define variable named "checkdir")
endif
ifdef noinstdir
$(error Do not define variable named "noinstdir")
endif

# We map each directory prefix to either 'data' or 'exec', so we can
# easily decide which install sub-target will install objects in this
# directory.  For standard directories, we simply hard-code the
# answer.  For user directories, we use the "exec" substring, as
# Automake does.  We also map non-installing prefixes to 'none'.
quagmire/instpfx-bin := exec
quagmire/instpfx-data := data
quagmire/instpfx-dataroot := data
quagmire/instpfx-doc := data
quagmire/instpfx-dvi := data
quagmire/instpfx-html := data
quagmire/instpfx-include := data
quagmire/instpfx-info := data
quagmire/instpfx-lib := exec
quagmire/instpfx-libexec := exec
quagmire/instpfx-locale := data
quagmire/instpfx-localstate := data
quagmire/instpfx-man := data
quagmire/instpfx-oldinclude := data
quagmire/instpfx-pdf := data
quagmire/instpfx-ps := data
quagmire/instpfx-sbin := exec
quagmire/instpfx-sharedstate := data
quagmire/instpfx-sysconf := exec

# Non-installing fake names.
quagmire/instpfx-check := none
quagmire/instpfx-noinst := none

# Compute the remaining install values.
$(foreach _pfx,$(quagmire/dir-prefixes),$(if $(quagmire/instpfx-$(_pfx)),,$(eval quagmire/instpfx-$(_pfx) := $(if $(findstring exec,$(_pfx)),exec,data))))


# This tracks all the directories into which we may install an object.
# This is used for 'installdirs'.
quagmire/all-install-dirs :=


OBJEXT ?= o
EXEEXT ?=

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

# Programs.
include $(quagmire_dir)/program.mk  # FIXME lazily include once
$(foreach _pfx,$(quagmire/dir-prefixes),$(eval $(call quagmire/apply-aggregate,$(_pfx),PROGRAMS,quagmire/program)))

# Static libraries.
include $(quagmire_dir)/staticlib.mk  # FIXME lazily include once
$(foreach _pfx,$(quagmire/dir-prefixes),$(eval $(call quagmire/apply-aggregate,$(_pfx),LIBRARIES,quagmire/library)))

# Shared libraries.
include $(quagmire_dir)/sharedlib.mk  # FIXME lazily include once
$(foreach _pfx,$(quagmire/dir-prefixes),$(eval $(call quagmire/apply-aggregate,$(_pfx),SHARED_LIBRARIES,quagmire/sharedlibrary)))


# No point in doing this conditionally since we will always have at
# least one: the Makefile.
include $(quagmire_dir)/configuration.mk
$(foreach _file,$(quagmire_config_files),$(eval $(call quagmire/config.status,$(subst :, ,$(_file)))))

include $(quagmire_dir)/compile.mk
include $(quagmire_dir)/tags.mk
include $(quagmire_dir)/data.mk

# This must come before the data installation code.
include $(quagmire_dir)/texi.mk

# Install data.
$(foreach _dir,$(quagmire/dir-prefixes),$(if $($(_dir)_DATA),$(eval $(call quagmire/data-directory,$(_dir),data,DATA))))

# Install scripts.
$(foreach _dir,$(quagmire/dir-prefixes),$(if $($(_dir)_SCRIPTS),$(eval $(call quagmire/data-directory,$(_dir),exec,SCRIPTS))))

include $(quagmire_dir)/help.mk
include $(quagmire_dir)/dist.mk

# Create targets that make install directories.  We use sort to
# uniquify the list.
$(foreach _dir,$(sort $(quagmire/all-install-dirs)),$(eval $(call quagmire/one-install-dir,$(_dir))))
