# defcompiler.mk - Define compiler configury.

# quagmire/defcompiler NAME CC
# Define a rule to compute the dependency mode for a compiler.
# CC is the compiler.
# NAME is the result of calling quagmire/tool-name on the compiler.
define quagmire/defcompiler

# Only do this once per compiler.
ifndef quagmire/depmode-$(1)

.quagmire/$(1)-compiler: | .quagmire
	@$(quagmire_dir)/check-depcomp $(quagmire_dir)/depcomp \
		"quagmire/depmode-$(1)" "$(2)" > $$@

-include .quagmire/$(1)-compiler

endif

endef
