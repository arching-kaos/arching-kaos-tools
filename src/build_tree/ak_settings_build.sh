echo "Building lib/aksettings.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include aksettings.c -o lib/aksettings.so && \
echo "Building tests/test_aksettings" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aksettings.c lib/aksettings.so -o tests/test_aksettings && \
echo "Running test_aksettings" && \
time ./tests/test_aksettings && \
rm ./tests/test_aksettings
