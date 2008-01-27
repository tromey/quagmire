# defcompiler.mk - Define compiler configury.

# @deffn quagmire/defcompiler name
# @end defun
define quagmire/defcompiler
.quagmire/$(1)-compiler: | .quagmire
	@echo "quagmire/depmode-$(1) = gcc3" > .quagmire/$(1)-compiler

-include .quagmire/$(1)-compiler

endef
