echo "Building lib/aklogcatter.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include aklogcatter.c -o lib/aklogcatter.so && \
echo "Building tests/test_aklogcatter" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aklogcatter.c lib/aklog.so lib/aklogcatter.so -o tests/test_aklogcatter && \
echo "Running test_aklogcatter" && \
time ./tests/test_aklogcatter && \
rm ./tests/test_aklogcatter
