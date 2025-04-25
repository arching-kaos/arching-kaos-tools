ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -Wall -Werror -Wextra -Wpedantic -ggdb -I$(top_srcdir)/include
#AM_CFLAGS = -Wall -Werror -Wextra -Wpedantic -ggdb -I$(top_srcdir)/include

lib_LTLIBRARIES = libaklog.la libaksettings.la libakfs.la libakdatetime.la libakutils.la
libaklog_la_SOURCES = $(top_srcdir)/src/aklog.c

libaksettings_la_SOURCES = $(top_srcdir)/src/aksettings.c

libakfs_LDADD = libaksettings.la
libakfs_la_SOURCES = $(top_srcdir)/src/akfs.c $(top_srcdir)/src/aksettings.c $(top_srcdir)/src/akfs_sha512sum.c $(top_srcdir)/src/akfs_map_v3.c $(top_srcdir)/src/akfs_map_v4.c $(top_srcdir)/src/akfs_main.c

libakutils_la_SOURCES = $(top_srcdir)/src/akutils.c

libakdatetime_la_SOURCES = $(top_srcdir)/src/akdatetime.c

include_HEADERS = include/libaklog.h include/libaksettings.h include/libakfs.h

bin_PROGRAMS = akt akdefuse aklog akfs
akfs_LDADD = libaklog.la libakfs.la libaksettings.la
akfs_SOURCES = src/akfs_main.c
akt_SOURCES = src/ak.c
akt_LDADD = libaklog.la libakfs.la libaksettings.la
akt_SOURCES = src/ak.c
akdefuse_CFLAGS = -I/usr/include/fuse3 -lfuse3 -lpthread
akdefuse_LDADD = libaklog.la libakfs.la
akdefuse_SOURCES = src/akfs_defuse.c
aklog_LDADD = libaklog.la
aklog_SOURCES = src/aklog_main.c

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

cppcheck:
		cppcheck --std=c99 --force --enable=all --check-library -I $(top_srcdir)/include/*.h $(top_srcdir)/include/*.h $(top_srcdir)/src/*.c $(top_srcdir)/tests/test*.c
