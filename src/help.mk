# Print help for users.

# As we add targets, update help.
# FIXME: allow user-defined help as well.  What is a good way?
help:
	@echo "Targets supported by all quagmire-based builds:"
	@echo "   all            Build everything [default]"
	@echo "   install        Copy deliverables to install tree"
	@echo "   mostlyclean    Delete easy-to-rebuild objects"
	@echo "   clean          Delete everything built by 'all'"
	@echo "   distclean      Delete everything built by 'configure', plus 'clean'"
	@echo "   check          Run test suite"
	@echo
	@echo "Less-frequently-used targets:"
	@echo "   installdirs    Make directories in install tree"
	@echo "   TAGS           Make TAGS file for Emacs"
	@echo "   dist           Make distribution tar"
	@echo "   distcheck      Make distribution tar and run consistency checks"

.PHONY: help
