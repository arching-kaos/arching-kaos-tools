ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -I$(top_srcdir)/include

lib_LTLIBRARIES = libaklog.la libaksettings.la libakfs.la libakdatetime.la libakutils.la
libaklog_la_SOURCES = $(top_srcdir)/src/aklog.c
libakfs_la_SOURCES = $(top_srcdir)/src/akfs.c
libakutils_la_SOURCES = $(top_srcdir)/src/akutils.c
libakdatetime_la_SOURCES = $(top_srcdir)/src/akdatetime.c
libaksettings_la_SOURCES = $(top_srcdir)/src/aksettings.c

include_HEADERS = include/libaklog.h include/libaksettings.h include/libakfs.h

bin_PROGRAMS = ak
ak_LDADD = libaklog.la
ak_SOURCES = src/ak.c

check_PROGRAMS = test_aklog test_aksettings test_akfs test_akutils test_akdatetime
test_akdatetime_SOURCES = ./tests/test_akdatetime.c ./src/akdatetime.c
test_akdatetime_LDADD = libakdatetime.la

test_akutils_SOURCES = ./tests/test_akutils.c ./src/akutils.c
test_akutils_LDADD = libakutils.la

test_aklog_SOURCES = ./tests/test_aklog.c ./src/aklog.c
test_aklog_LDADD = libaklog.la

test_akfs_SOURCES = ./tests/test_akfs.c ./src/akfs.c
test_akfs_LDADD = libakfs.la libaklog.la

test_aksettings_SOURCES = ./tests/test_aksettings.c ./src/aksettings.c ./src/aklog.c
test_aksettings_LDADD = libaksettings.la

tests_test_main_CPPFLAGS = -I$(top_srcdir)/include

TESTS = $(check_PROGRAMS)

CLEANFILES = $(TESTS)

