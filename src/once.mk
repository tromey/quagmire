# once.mk - Code to expand a function call just once.

# quagmire/expand-once KEY VALUE
# If the expansion for KEY has already been done, return nothing.
# Otherwise, return VALUE. Must be used in an eval context.
# FIXME perhaps more efficient as a delayed function call
# rather than pre-expanding the args?
define quagmire/expand-once
$(if $(quagmire/expanded-$(1)),,
quagmire/expanded-$(1) := done
$(2)
)
endef
