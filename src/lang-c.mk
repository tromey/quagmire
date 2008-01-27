# lang-c.mk - Compile a C source file.

# FIXME: other depmodes
# FIXME: static patterns and renaming?
# FIXME: configury for CC
# FIXME: needs secondary expansion
%.o: %.c | .quagmire/$(CC)-compiler $(DEPDIR)
	$(COMPILE.c) -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Po $(OUTPUT_OPTION) $<
	@echo got $(quagmire/depmode-$(CC))

CC ?= gcc
CFLAGS ?= -g -O2
CPPFLAGS ?= -I.

$(eval $(call quagmire/defcompiler,$(CC)))
