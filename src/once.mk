# once.mk - Code to expand a function call just once.

# quagmire/expand-once KEY VALUE
# If the expansion for KEY has already been done, return nothing.
# Otherwise, return VALUE. Must be used in an eval context.
define quagmire/expand-once
$(if $(quagmire/expanded-$(1)),,
quagmire/expanded-$(1) := done
$(2)
)
endef
