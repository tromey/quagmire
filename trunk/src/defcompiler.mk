# defcompiler.mk - Define compiler configury.

# quagmire/compiler-name CC
# Given a compiler (e.g., $(CC)), munge the value to be
# file-system-safe and still try to avoid possible conflicts.
quagmire/compiler-name = $(subst /,@_,$(subst @,@@,$(firstword $(1))))

# quagmire/defcompiler NAME CC
# Define a rule to compute the dependency mode for a compiler.
# CC is the compiler.
# NAME is the result of calling quagmire/compiler-name on the compiler.
define quagmire/defcompiler
.quagmire/$(1)-compiler: | .quagmire
	@$(quagmire_dir)/check-depcomp $(quagmire_dir)/depcomp \
		"quagmire/depmode-$(1)" "$(2)" > $$@

-include .quagmire/$(1)-compiler

endef
