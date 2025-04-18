#!/usr/bin/env bash

echo "Building lib/aklog.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include src/aklog.c -o lib/libaklog.so && \
echo "Building tests/test_aklog" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aklog.c lib/libaklog.so -o tests/test_aklog && \
echo "Running test_aklog" && \
time ./tests/test_aklog # && \
# rm ./tests/test_aklog
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aklogwrite.c lib/libaklog.so -o tests/test_aklogwrite && \
echo "Running test_aklogwrite" && \
time ./tests/test_aklogwrite && \
rm ./tests/test_aklogwrite
