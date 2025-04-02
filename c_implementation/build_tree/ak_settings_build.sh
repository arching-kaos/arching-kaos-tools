echo "Building lib/aksettings.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include src/aksettings.c -o lib/libaksettings.so && \
echo "Building tests/test_aksettings" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aksettings.c lib/libaklog.so lib/libaksettings.so -o tests/test_aksettings && \
echo "Running test_aksettings" && \
time ./tests/test_aksettings && \
rm ./tests/test_aksettings
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_aksettings_read.c lib/libaklog.so lib/libaksettings.so -o tests/test_aksettings_read && \
echo "Running test_aksettings_read" && \
time ./tests/test_aksettings_read && \
rm ./tests/test_aksettings_read
