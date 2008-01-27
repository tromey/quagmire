# checkfunc.mk - Link test for a function.

# FIXME: gnu make needs a toupper macro.
# FIXME: use portable sed construct from autoconf instead of tr?
# FIXME: libraries
.quagmire/function/%-frag: .quagmire/function/%.c
ifeq (,$(findstring s,$(MAKEFLAGS)))
	@echo -n "Checking for function $(*F)... "
endif
	@upper=`echo '$(*F)' | tr a-z A-Z`; \
	if $(CC) $(CFLAGS) $(CPPFLAGS) $< -o .quagmire/function/$(*F).exe >> .quagmire/function/$(*F).log 2>&1; then \
	  result="#define HAVE_$$upper 1"; msg=found; \
	  rm .quagmire/function/$(*F).log; \
	else \
	  result="#undef HAVE_$$upper"; msg="not found"; \
	fi; \
	rm -f .quagmire/function/$(*F).exe 2> /dev/null; \
	echo $$result > $@; \
	$(if $(findstring s,$(MAKEFLAGS)),true,echo $$msg)

.quagmire/function/%.c: | .quagmire/function
	@rm -f $@.tmp
	@echo "#undef $(*F)" > $@.tmp
	@echo "char $(*F) ();" >> $@.tmp
	@echo "char (*f)() = $(*F);" >> $@.tmp
	@echo "int main () { return f != $(*F); }" >> $@.tmp
	@mv $@.tmp $@

.PRECIOUS: .quagmire/function/%.c

.quagmire/function: | .quagmire
	@mkdir .quagmire/function

# A function that can be used in a config.h dependency list.
quagmire/checkfunc = .quagmire/function/$(1)-frag
