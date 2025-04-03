ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -I$(top_srcdir)/include

lib_LTLIBRARIES = libaklog.la libaksettings.la
libaklog_la_SOURCES = $(top_srcdir)/src/aklog.c
libaksettings_la_SOURCES = $(top_srcdir)/src/aksettings.c
include_HEADERS = include/libaklog.h include/libaksettings.h

bin_PROGRAMS = ak
ak_LDADD = libaklog.la
ak_SOURCES = src/ak.c

check_PROGRAMS = test_aklog
test_aklog_SOURCES = ./tests/test_aklog.c
test_aklog_LDADD = libaklog.la

tests_test_main_CPPFLAGS = -I$(top_srcdir)/include

TESTS = $(check_PROGRAMS)

CLEANFILES = $(TESTS)

