# links.mk - Handle AC_CONFIG_LINKS.

# quagmire/config.links SPEC
# Handle a single file generated by AC_CONFIG_LINKS.
# SPEC is the argument to that macro, after splitting on ":"s.
define quagmire/config.links

distclean/$(firstword $(1)):
	rm -f $(firstword $(1))
.PHONY: distclean/$(firstword $(1))
distclean: distclean/$(firstword $(1))

endef