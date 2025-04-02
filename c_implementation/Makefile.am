ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = -I$(top_srcdir)/include


# Link each test to the library
#$(test_programs): % : %.c
# 	$(CC) $(AM_CPPFLAGS) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(LDFLAGS) libmylib.la
#
#
# Build shared library from root dir sources

lib_LTLIBRARIES = libaklog.la
libaklog_la_SOURCES = $(top_srcdir)/src/aklog.c
include_HEADERS = include/libaklog.h

## Build tests (no SUBDIRS needed)
check_PROGRAMS = test_aklog
test_aklog_SOURCES = ./tests/test_aklog.c
test_aklog_LDADD = libaklog.la
tests_test_main_CPPFLAGS = -I$(top_srcdir)/include  # For tests too

# Enable 'make check' to run tests
TESTS = $(check_PROGRAMS)

# Optional: Clean test binaries aggressively
CLEANFILES = $(TESTS)

