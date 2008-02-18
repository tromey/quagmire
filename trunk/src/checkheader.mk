# checkheader.mk - Compile test for a header file.

.quagmire/header: |.quagmire
	@mkdir .quagmire/header

.quagmire/header/%-frag: .quagmire/header/%.c
ifeq (,$(findstring s,$(MAKEFLAGS)))
	@echo -n "Checking for header $*... "
endif
	@upper=`echo '$*' | tr a-z./ A-Z__`; \
	if $(CC) $(CFLAGS) $(CPPFLAGS) $< -c -o .quagmire/header/$*.o > .quagmire/header/$*.log 2>&1; then \
	  result="#define HAVE_$$upper 1"; msg=found; \
	  rm .quagmire/header/$*.log; \
	else \
	  result="#undef HAVE_$$upper"; msg="not found"; \
	fi; \
	rm -f .quagmire/header/$*.o 2> /dev/null; \
	echo $$result > $@; \
	$(if $(findstring s,$(MAKEFLAGS)),true,echo $$msg)

.quagmire/header/%.c: | .quagmire/header
	@rm -f $@.tmp
	@mkdir -p $(@D)
	@echo "#include <$*>" > $@.tmp
	@echo "int x;" >> $@.tmp
	@mv $@.tmp $@

.PRECIOUS: .quagmire/header/%.c


# A function that can be used in a config.h dependency list.
quagmire/checkheader = .quagmire/header/$(1)-frag
