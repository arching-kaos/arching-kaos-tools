ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -Wall -Werror -Wextra -Wpedantic -ggdb -I$(top_srcdir)/include
#AM_CFLAGS = -Wall -Werror -Wextra -Wpedantic -ggdb -I$(top_srcdir)/include

lib_LTLIBRARIES = libaklog.la libaksettings.la libakfs.la libakdatetime.la libakutils.la

libaklog_la_SOURCES = $(top_srcdir)/src/ak_log.c $(top_srcdir)/src/ak_log_main.c

libaksettings_la_SOURCES = $(top_srcdir)/src/ak_settings.c

libakfs_LDADD = libaksettings.la libaklog.la
libakfs_la_SOURCES = $(top_srcdir)/src/ak_fs.c \
					 $(top_srcdir)/src/ak_fs_main.c \
					 $(top_srcdir)/src/ak_fs_maps_v3.c \
					 $(top_srcdir)/src/ak_fs_map_v3.c \
					 $(top_srcdir)/src/ak_fs_map_v4.c \
					 $(top_srcdir)/src/ak_fs_mt.c \
					 $(top_srcdir)/src/ak_fs_sha512sum.c

libakutils_la_SOURCES = $(top_srcdir)/src/ak_utils.c

libakdatetime_la_SOURCES = $(top_srcdir)/src/ak_datetime.c

#include_HEADERS = "$(wildcard include/*.h)"
include_HEADERS = $(top_srcdir)/include/libaklog.h \
				  $(top_srcdir)/include/libaksettings.h \
				  $(top_srcdir)/include/libakfs.h \
				  $(top_srcdir)/include/libak.h

bin_PROGRAMS = akfs akdefuse #akt akdefuse aklog
akfs_LDADD = libaklog.la libakfs.la libaksettings.la
akfs_SOURCES = src/ak_fs_main.c

akt_LDADD = libaklog.la libakfs.la libaksettings.la
akt_SOURCES = src/ak.c

akdefuse_CFLAGS = -I/usr/include/fuse3 -lfuse3 -lpthread
akdefuse_LDADD = libaklog.la libakfs.la
akdefuse_SOURCES = src/ak_fs_defuse.c

aklog_LDADD = libaklog.la
aklog_SOURCES = src/ak_log_main.c

check_PROGRAMS = test_aklog test_aksettings test_akfs test_akutils test_akdatetime
test_akdatetime_SOURCES = ./tests/test_akdatetime.c ./src/ak_datetime.c
test_akdatetime_LDADD = libakdatetime.la

test_akutils_SOURCES = ./tests/test_akutils.c ./src/ak_utils.c
test_akutils_LDADD = libakutils.la

test_aklog_SOURCES = ./tests/test_aklog.c ./src/ak_log.c
test_aklog_LDADD = libaklog.la

test_akfs_SOURCES = ./tests/test_akfs.c ./src/ak_fs.c
test_akfs_LDADD = libakfs.la libaklog.la

test_aksettings_SOURCES = ./tests/test_aksettings.c ./src/ak_settings.c ./src/ak_log.c
test_aksettings_LDADD = libaksettings.la

tests_test_main_CPPFLAGS = -I$(top_srcdir)/include

TESTS = $(check_PROGRAMS)

CLEANFILES = $(TESTS)

cppcheck:
		cppcheck --std=c99 --force --enable=all --check-library -I $(top_srcdir)/include/*.h $(top_srcdir)/include/*.h $(top_srcdir)/src/*.c $(top_srcdir)/tests/test*.c
