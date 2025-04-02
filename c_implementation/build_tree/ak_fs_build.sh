#!/usr/bin/env bash

echo "Building lib/akfs.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include ./src/akfs.c -o lib/libakfs.so && \
echo "Building tests/test_akfs" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_akfs.c lib/libakfs.so -o tests/test_akfs && \
echo "Running test_akfs" && \
time ./tests/test_akfs && \
rm ./tests/test_akfs

echo "Building tests/test_akfs_mkdir.c" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_akfs_mkdir.c lib/libakfs.so -o tests/test_akfs_mkdir && \
echo "Running test_akfs_mkdir" && \
time ./tests/test_akfs_mkdir && \
rm ./tests/test_akfs_mkdir
