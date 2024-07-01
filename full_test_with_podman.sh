#!/bin/bash

if [ ! -z $1 ] && [ -n "$1" ]
then
    tag="$(bash ./test_with_podman.sh "$1" | tail -n 2 | head -n 1 | cut -d ' ' -f 3)"
    name="$(echo -n $tag | cut -d ':' -f 1 | cut -d '/' -f 2)"
    container="akt-test-$name"
    podman run --name $container -d -p 8620:8610 --cap-add=NET_ADMIN --device /dev/net/tun $tag
    podman exec -it $container bash
    podman container stop $container
    podman container rm $container
else
    echo "Provide one of the following distros as an argument to work with"
    find podman -type f | sed -e 's/^podman\/ContainerFile\./* /g'
fi
