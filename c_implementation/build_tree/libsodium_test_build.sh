gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include -lsodium tests/libsodium.c lib/aklog.so -o watah
