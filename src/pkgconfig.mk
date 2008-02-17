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

# FIXME: should depend on tool path
.quagmire/pkg-config/min-version: | .quagmire/pkg-config
	@if $(PKG_CONFIG) --atleast-pkgconfig-version $(PKG_CONFIG_MIN_VERSION); then \
	  echo ok > $@; \
	else \
	  echo "Your version of pkg-config is too old." 1>&2; \
	  echo "You need version $(PKG_CONFIG_MIN_VERSION) or newer." 1>&2; \
	  exit 1; \
	fi

# Usage: quagmire/package TARGET SPECVAR
# TARGET is the target for which we are computing the information.
# SPECVAR is the name of the variable holding the pkg-config
# specification.
# FIXME: case where TARGET is in a subdir...
define quagmire/package

# Note that we don't share results across targets... but that is
# weird.  We should let the user unify these somehow, perhaps by
# treating packages as their own entities.

.quagmire/pkg-config/results/$(1): .quagmire/pkg-config/min-version | .quagmire/pkg-config/results
ifeq ($(findstring s,$(MAKEFLAGS)),)
	@echo -n "Checking pkg-config $$($(2))..."
endif
	@if $$(PKG_CONFIG) --exists $$($(2)); then \
	  $(if $(findstring s,$(MAKEFLAGS)),true,echo " found"); \
	else \
	  $(if $(findstring s,$(MAKEFLAGS)),:,echo " not found"); \
	  false; \
	fi
	@echo "$(1): CFLAGS += \\" > $$@
	@$$(PKG_CONFIG) --cflags $$($(2)) >> $$@
	@echo "$(1): CXXFLAGS += \\" >> $$@
	@$$(PKG_CONFIG) --cflags $$($(2)) >> $$@
	@echo "$(1): $(1)_LIBS += \\" >> $$@
	@$$(PKG_CONFIG) --libs $$($(2)) >> $$@

$(1): | .quagmire/pkg-config/results/$(1)

-include .quagmire/pkg-config/results/$(1)

# FIXME: namespace.  not just here but all clean targets.
mostlyclean/pkg-config-$(1):
	@rm -f .quagmire/pkg-config/results/$(1)
.PHONY: mostlyclean/pkg-config-$(1)
mostlyclean: mostlyclean/pkg-config-$(1)

endef
