# lang-cxx.mk - Compile a C++ source file.

# Usage: quagmire/cxx-rules NAME EXTENSION
# NAME is the munged name of the compiler.
# EXTENSION is the C++ file extension (no dot).
define quagmire/cxx-rules

%.o: %.$(2) | $(DEPDIR)
ifeq ($(quagmire/depmode-$(1)),gcc3)
	$(COMPILE.cc) -MT $$@ -MMD -MP -MF $(DEPDIR)/$$*.Po -c -o $$@ $$<
else
# All C++ compiler should accept -c -o.  If you know of one that
# doesn't, let us know.
	depmode=$(quagmire/depmode-$(1)) source="$$<" object="$$@" \
	DEPDIR="$$(DEPDIR)" libtool=no \
	$$(quagmire_dir)/depcomp $$(COMPILE.cc) -c -o $$@ $$<
endif

endef

CXX ?= g++
CXXFLAGS ?= -g -O2
