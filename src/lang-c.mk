# lang-c.mk - Compile a C source file.

# FIXME: static patterns and renaming?
# FIXME: needs secondary expansion

# quagmire/lang-c-rule NAME
# NAME is the munged name of the compiler
define quagmire/lang-c-rule
%.o: %.c | $(DEPDIR)
ifeq ($(quagmire/depmode-$(1)),gcc3)
	$$(COMPILE.c) -MT $$@ -MMD -MP -MF $$(DEPDIR)/$$*.Po -c -o $$@ $$<
else
	depmode=$(quagmire/depmode-$(1)) source="$$<" object="$$@" \
	DEPDIR="$$(DEPDIR)" libtool=no \
	$$(quagmire_dir)/depcomp $$(COMPILE.c) -c $$(OUTPUT_OPTION) $$<
endif
endef

CC ?= gcc
CFLAGS ?= -g -O2
CPPFLAGS ?= -I.

# We have to ensure that the depcomp variable is set before we can
# expand the %.o rule.
$(eval $(call quagmire/defcompiler,$(call quagmire/tool-name,$(CC)),$(CC)))
$(eval $(call quagmire/lang-c-rule,$(call quagmire/tool-name,$(CC))))
