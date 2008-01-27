# once.mk - Code to expand a function call just once.

# @deffn quagmire/expand-once key value
# If the expansion for @var{key} has already been done, return
# nothing.  Otherwise, return @var{value}. Must be used in an eval
# context.
# @end defun
# FIXME perhaps more efficient as a delayed function call
# rather than pre-expanding the args?
define quagmire/expand-once
$(if $(quagmire/expanded-$(1)),,
quagmire/expanded-$(1) := done
$(2)
)
endef
