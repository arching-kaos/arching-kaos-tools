#!/usr/bin/env bash

curl -s -o soe "http://[`cjdns-online`]:8610/v0/peers" | jq
