# deps.mk - Create and remove the dependency directory.

DEPDIR ?= .deps

$(DEPDIR):
	@mkdir $(DEPDIR)

distclean/$(DEPDIR):
	rm -rf $(DEPDIR)
.PHONY: distclean/$(DEPDIR)
distclean: distclean/$(DEPDIR)
