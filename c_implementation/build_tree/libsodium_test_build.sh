gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include -lsodium tests/libsodium.c lib/libaklog.so -o watah
