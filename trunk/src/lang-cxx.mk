# lang-cxx.mk - Compile a C++ source file.

# Usage: quagmire/cxx-rules EXTENSION
define quagmire/cxx-rules

# FIXME: depmodes
%.o: %.$(1) | $(DEPDIR)
	$(COMPILE.cc) -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Po -c -o $@ $<

endef

CXX ?= g++
CXXFLAGS ?= -g -O2
