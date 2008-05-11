# pkgconfig.mk - Handle pkg-config.

# The user can set this via configure.
PKG_CONFIG ?= pkg-config

# Minimum required version; the user can set this as needed.
PKG_CONFIG_MIN_VERSION ?= 0.9.0

.quagmire/pkg-config: | .quagmire
	@mkdir $@

# We name the result files after the user's target, so we need a
# separate directory in which to store them.
.quagmire/pkg-config/results: | .quagmire/pkg-config
	@mkdir $@

# Name of the pkg-config minimum version results file.  We pick a
# funny name here so that we depend on the tool's path.
quagmire/pkg-file-name := \
    .quagmire/pkg-config/min-version-$(call quagmire/tool-name,$(PKG_CONFIG))

$(quagmire/pkg-file-name): | .quagmire/pkg-config
	@if $(PKG_CONFIG) --atleast-pkgconfig-version $(PKG_CONFIG_MIN_VERSION); then \
	  echo ok > $@; \
	else \
	  echo "Your version of pkg-config is too old." 1>&2; \
	  echo "You need version $(PKG_CONFIG_MIN_VERSION) or newer." 1>&2; \
	  exit 1; \
	fi

# Usage: quagmire/package TARGET SPECVAR [SUFFIX]
# TARGET is the target for which we are computing the information.
# SPECVAR is the name of the variable holding the pkg-config
# specification.
# SUFFIX is an optional suffix to append to TARGET to get the real
# name of the target.
define quagmire/package

# Note that we don't share results across targets... but that is
# weird.  We should let the user unify these somehow, perhaps by
# treating packages as their own entities.

# Some convenience variables for the body of this function.
override quagmire/pkg-name1 := $(call quagmire/tool-name,$(1))
override quagmire/pkg-name2 := $(call quagmire/value-name,$($(2)))
override quagmire/pkg-stamp := \
	.quagmire/pkg-config/results/stamp-$$(quagmire/pkg-name1)-$$(quagmire/pkg-name2)
override quagmire/pkg-output := \
	.quagmire/pkg-config/results/output-$$(quagmire/pkg-name1)

# This makes sure that we re-run pkg-config when the specification
# changes.  We put both the target name and the spec var's contents
# into the name of the file.
$$(quagmire/pkg-stamp): | .quagmire/pkg-config/results
	@echo ok > $$@

# Depend on the stamp- file so that we re-run this whenever needed.
$$(quagmire/pkg-output): $$(quagmire/pkg-file-name) $$(quagmire/pkg-stamp) | quagmire/echo-n
	@$$(call quagmire/echo-n,"Checking pkg-config $$($(2))...")
	@if $$(PKG_CONFIG) --exists $$($(2)); then \
	  $(call quagmire/echo, found); \
	else \
	  $(call quagmire/echo, not found); \
	  false; \
	fi
	@echo "$(1)$(3): CFLAGS += \\" > $$@
	@$$(PKG_CONFIG) --cflags $$($(2)) >> $$@
	@echo "$(1)$(3): CXXFLAGS += \\" >> $$@
	@$$(PKG_CONFIG) --cflags $$($(2)) >> $$@
	@echo "$(1)$(3): $(1)_LIBS += \\" >> $$@
	@$$(PKG_CONFIG) --libs $$($(2)) >> $$@

# Ensure that pkg-config is run, then include the result.  Note that
# we have to hand-expand the output name in the body here.
$$(quagmire/pkg-output)-incl: $$(quagmire/pkg-output)
	@true $$(eval include .quagmire/pkg-config/results/output-$(call quagmire/tool-name,$(1)))

# .PHONY: $$(quagmire/pkg-output)-incl

# The objects corresponding to the target, and the target, pre-depend
# on the pkg-config results.
$$($(1)_OBJECTS): | $$(quagmire/pkg-output)-incl
$(1): | $$(quagmire/pkg-output)-incl

endef
