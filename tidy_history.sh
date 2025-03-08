#!/usr/bin/env bash
source lib/_ak_fm
source lib/_ak_script

tmp=$(_ak_make_temp_file)

ipfs files ls -l /zarchive >> $tmp
ak ipfs -r files ls -l /zarchive >> $tmp

_ak_fm_sort_uniq_file $tmp

cat $tmp | grep -v '/' | awk '{print $1 " " $2 }' | while read ttt hhh
do
    trt="$(echo -n ${ttt} | cut -d '-' -f 1)"
    trh="$(echo -n ${ttt} | cut -d '-' -f 2)"
    if [ -n "${trh}" ] && [ "${trh}" == "${hhh}" ]
    then
        echo "${trt} ${hhh}"
    else
        echo "Hash not exist in filename" >&2
        echo "${trt} ${hhh}"
    fi
done > $AK_ZLATEST_HISTORY

rm $tmp
