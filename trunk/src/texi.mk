# texi.mk - Handle texinfo.

ifneq ($(TEXINFOS),)

TEXI2DVI ?= texi2dvi
TEXI2DVIFLAGS ?=

# For now we only support --no-split info files.
ifeq ($(findstring --no-split,$(MAKEINFO_FLAGS)),)
MAKEINFO_FLAGS += --no-split
endif

quagmire/texi-bases := $(patsubst %.texi,%.info,$(patsubst %.texinfo,%.info,$(TEXINFOS)))
quagmire/texi-infos := $(addsuffix .info,$(quagmire/texi-bases))
quagmire/texi-dvis := $(addsuffix .dvi,$(quagmire/texi-bases))
quagmire/texi-pdfs := $(addsuffix .pdf,$(quagmire/texi-bases))
# FIXME: no html or ps support yet
# quagmire/texi-htmls := $(addsuffix .html,$(quagmire/texi-bases))
# quagmire/texi-pss := $(addsuffix .ps,$(quagmire/texi-bases))

info: $(quagmire/texi-infos)
dvi: $(quagmire/texi-dvis)
pdf: $(quagmire/texi-pdfs)

clean/info:
	rm -f $(quagmire/texi-infos) $(quagmire/texi-dvis) $(quagmire/texi-pdfs)
clean: clean/info
.PHONY: clean/info

%.dvi: %.texi
	$(TEXI2DVI) -o $@ $(TEXI2DVIFLAGS) $<

%.dvi: %.texinfo
	$(TEXI2DVI) -o $@ $(TEXI2DVIFLAGS) $<

%.pdf: %.texi
	$(TEXI2DVI) --pdf -o $@ $(TEXI2DVIFLAGS) $<

%.pdf: %.texinfo
	$(TEXI2DVI) --pdf -o $@ $(TEXI2DVIFLAGS) $<

# FIXME: install-{dvi,pdf} not implemented.

infodir_DATA += $(quagmire/texi-infos)

endif
