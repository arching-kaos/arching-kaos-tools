echo "Building lib/akutils.so" && \
    gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include src/akutils.c -o lib/libakutils.so && \
    echo "Building tests/test_akutils" && \
    gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_akutils.c lib/libakutils.so -o tests/test_akutils && \
    echo "Running test_akutils" && \
    time ./tests/test_akutils && \
    rm ./tests/test_akutils
