# -*- makefile-gmake -*-

bin_PROGRAMS = ekeyring cxxtest
noinst_PROGRAMS = cxxtest2
check_PROGRAMS = cxxtest3

lib_LIBRARIES = libzardoz.a

libzardoz.a_SOURCES = zardoz.c

cxxtest_SOURCES = cxxtest.cc generated.h
cxxtest2_SOURCES = cxxtest2.cc generated.h
cxxtest3_SOURCES = cxxtest3.cc generated.h

generated.h:
	echo "#define VAR 0" > $@

cxxtest2.cc: cxxtest.cc
	cp $(srcdir)/cxxtest.cc $@

cxxtest3.cc: cxxtest.cc
	cp $(srcdir)/cxxtest.cc $@

distclean:
	rm -f generated.h cxxtest2.cc cxxtest3.cc

ekeyring_SOURCES = ekeyring.c something.h
ekeyring_PACKAGES = gnome-keyring-1
ekeyring_CONFIG_HEADERS = config.h

config.h_FUNCTIONS = strcmp strdup
config.h_HEADERS = string.h nothing.h strings.h sys/types.h

data_SCRIPTS = ekeyring.c
data_DATA = something.h

EXTRA_DIST = README.simple

#ekeyring_LIBS = `pkg-config --libs gnome-keyring-1`
#ekeyring: CFLAGS += `pkg-config --cflags gnome-keyring-1`
