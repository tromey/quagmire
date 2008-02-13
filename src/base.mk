# base.mk - the base Makefile.

VPATH = $(srcdir)

# Ensure 'all' is the default target.
all:

# The user's "makefile".
include $(srcdir)/Quagmire

# Quagmire.
include $(quagmire_dir)/post.mk
