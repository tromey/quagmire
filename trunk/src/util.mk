# util.mk - Generic utility functions.

# quagmire/tool-name PROG
# Given a program name (e.g., $(CC)), munge the value to be
# file-system-safe and still try to avoid possible conflicts.
quagmire/tool-name = $(subst /,@_,$(subst @,@@,$(firstword $(1))))

quagmire/empty =
quagmire/space = $(quagmire/empty) $(quagmire/empty)

# quagmire/value-name VALUE
# Like tool-name but operates on arbitrary values, including lists.
quagmire/value-name = $(subst $(quagmire/space),@s,$(subst /,@_,$(subst @,@@,$(strip $(1)))))

# move-if-change FROM TO
# Expand to a move-if-change shell script.
quagmire/move-if-change = if test -r "$(1)" && cmp -s "$(1)" "$(2)"; then rm -f "$(1)"; else mv -f "$(1)" "$(2)"; fi

# echo STRING
# Echo the value STRING unless make -s is being used
ifneq (,$(findstring s,$(MAKEFLAGS)))
quagmire/do = $(1)
quagmire/echo = :
quagmire/echo-n = :

quagmire/echo-n: quagmire/do-nothing

else

quagmire/do = echo "$(1)" && $(1)
quagmire/echo = echo "$(1)"

# quagmire/echo-n TEXT
# A portable 'echo -n'.  Rules using this must pre-depend on the
# target 'quagmire/echo-n'.  This initial value ensures this dependency.
quagmire/echo-n = $(error quagmire/echo-n used -- missing dependency)

# For the time being just re-use what autoconf discovered.  Later, if
# need be, we can run a configury test here instead, using 'eval
# include'.
quagmire/echo-n:
	$(eval override quagmire/echo-n = echo $$(ECHO_N) $$(1) "$$(ECHO_C)")

endif

.PHONY: quagmire/echo-n
