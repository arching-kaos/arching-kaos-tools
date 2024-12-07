#!/usr/bin/env bash

echo "Building lib/aklog.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include aklog.c -o lib/aklog.so && \
echo "Building tests/test_aklog" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aklog.c lib/aklog.so -o tests/test_aklog && \
echo "Running test_aklog" && \
time ./tests/test_aklog
rm ./tests/test_aklog
