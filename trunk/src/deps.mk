# deps.mk - Manage the dependency directory.

DEPDIR ?= .deps

distclean/$(DEPDIR):
	rm -rf $(DEPDIR)
.PHONY: distclean/$(DEPDIR)
distclean: distclean/$(DEPDIR)
