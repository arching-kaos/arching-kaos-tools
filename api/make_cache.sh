#!/bin/bash
ak-find-latest-mined-sblock > $AK_CACHEDIR/ak-find-latest-mined-sblock.json
ak zchain --crawl > $AK_CACHEDIR/ak-get-chain-minified.json
ak-get-zlatest > $AK_CACHEDIR/ak-get-zlatest.json

