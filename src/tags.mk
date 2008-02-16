# tags.mk - Run etags.

ETAGS ?= etags
ETAGSFLAGS ?=
ETAGS_ARGS ?=
ETAGS_SOURCES ?= $(quagmire/all_sources)
TAGS_DEPENDENCIES ?=

TAGS: $(ETAGS_SOURCES) $(TAGS_DEPENDENCIES)
	$(ETAGS) $(ETAGSFLAGS) $(ETAGS_ARGS) $(ETAGS_SOURCES)

clean/TAGS:
	rm -f TAGS
clean: clean/TAGS
.PHONY: clean/TAGS
