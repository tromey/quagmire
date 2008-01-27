# configuration.mk - Handle the configuration.

.quagmire/make-vars.mk: | .quagmire/make
	@cat $^ > $@.tmp
	@mv $@.tmp $@

.quagmire/make: .quagmire
	@mkdir .quagmire/make

include .quagmire/make-vars.mk
