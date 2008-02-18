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
