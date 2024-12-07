#!/bin/bash

library="${1}"
library_capitals="$(echo ${library} | tr '[:lower:]' '[:upper:]')"
include_file="include/ak${library}.h"
test_file="tests/test_ak${library}.c"
implementation_file="ak${library}.c"
build_file="build_tree/ak_${library}_build.sh"

include_template(){
    cat > ${include_file} << EOF
#ifndef AK_${library_capitals}_H
#define AK_${library_capitals}_H

int ak_${library}();

#endif // AK_${library_capitals}_H
EOF

}

implementation_template(){
    cat > ${implementation_file} << EOF
#include <ak${library}.h>
#include <stdio.h>

int ak_${library}()
{
    printf("Testing: %s\n", __func__);
    return 0;
}
EOF
}

test_template(){
    cat > ${test_file} << EOF
#include <ak${library}.h>

int main()
{
    ak_${library}();
    return 0;
}
EOF
}

build_template(){
    cat > ${build_file} << EOF
echo "Building lib/ak${library}.so" && \
gcc -c -shared -Wextra -Wall -Werror -pedantic -ggdb -fPIC -I./include ak${library}.c -o lib/ak${library}.so && \
echo "Building tests/test_ak${library}" && \
gcc -Wextra -Wall -Werror -pedantic -ggdb -Wl,-rpath=lib -I./include tests/test_ak${library}.c lib/ak${library}.so -o tests/test_ak${library} && \
echo "Running test_ak${library}" && \
time ./tests/test_ak${library}
rm ./tests/test_ak${library}
EOF
    chmod +x ${build_file}
}

if [ ! -f ${include_file} ]
then
    include_template
else
    echo "ERROR: ${include_file} exists"
fi
if [ ! -f ${test_file} ]
then
    test_template
else
    echo "ERROR: ${test_file} exists"
fi
if [ ! -f ${implementation_file} ]
then
implementation_template
else
    echo "ERROR: ${implementation_file} exists"
fi
if [ ! -f ${build_file} ]
then
build_template
else
    echo "ERROR: ${build_file} exists"
fi
