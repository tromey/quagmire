# Handle pkg-config.

PKG_CONFIG ?= pkg-config

PKG_CONFIG_MIN_VERSION ?= 0.9.0

.quagmire/pkg-config: | .quagmire
	@mkdir $@

# We name the result files after the user's target, so we need a
# separate directory in which to store them.
.quagmire/pkg-config/results: | .quagmire/pkg-config
	@mkdir $@

# FIXME: verbosity level here...
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
# FIXME: case where TARGET is in a subdir...
define quagmire/package

# Note that we don't share results across targets... but that is
# weird.  We should let the user unify these somehow, perhaps by
# treating packages as their own entities.

# FIXME: print something here?
.quagmire/pkg-config/results/$(1): .quagmire/pkg-config/min-version | .quagmire/pkg-config/results
	@$$(PKG_CONFIG) --exists $$($(2))
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
