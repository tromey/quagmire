# -*- makefile-gmake -*-

bin_PROGRAMS = ekeyring cxxtest
noinst_PROGRAMS = cxxtest2
check_PROGRAMS = cxxtest3

lib_LIBRARIES = libzardoz.a

libzardoz.a_SOURCES = zardoz.c sub/sub.c

cxxtest_SOURCES = cxxtest.cc
nodist_cxxtest_SOURCES = generated.h
nodist_cxxtest2_SOURCES = cxxtest2.cc generated.h
nodist_cxxtest3_SOURCES = cxxtest3.cc generated.h

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
dist_data_DATA = something.h

EXTRA_DIST = README.simple
