# base.mk - the base Makefile.

ifndef .FEATURES
$(error Quagmire-based builds require GNU make 3.81 or later)
endif

VPATH = $(srcdir)

# Ensure 'all' is the default target.
all:

# The user's "makefile".
include $(srcdir)/Quagmire.mk

# Quagmire.
include $(quagmire_dir)/post.mk
