# checks.mk - Manage the .quagmire directory.

.quagmire:
	@mkdir .quagmire

distclean/.quagmire:
	rm -rf .quagmire
.PHONY: distclean/.quagmire
distclean: distclean/.quagmire
