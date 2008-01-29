# lang-c.mk - Compile a C source file.

# FIXME: other depmodes
# FIXME: static patterns and renaming?
# FIXME: configury for CC
# FIXME: fails when $(CC) has spaces -- need make functionality??
# FIXME: needs secondary expansion
%.o: %.c | .quagmire/$(CC)-compiler $(DEPDIR)
	$(COMPILE.c) -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Po -c $(OUTPUT_OPTION) $<

CC ?= gcc
CFLAGS ?= -g -O2
CPPFLAGS ?= -I.

$(eval $(call quagmire/defcompiler,$(CC)))
