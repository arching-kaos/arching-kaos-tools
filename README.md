Arching Kaos Tools
==================

Description
-----------

This is an installable repo which provides various tools for running Arching Kaos and using it.

Requirements
------------
Some Linx machine which has installed bash or zsh, gpg, wget, curl, git and which.
Other shells maybe are working.

- bash (v5.1.8) or zsh (v5.8)
- gpg (v2.3.4)
- wget (v1.21.2)
- curl (v7.79.1)
- git (v2.34.1)
- which (v2.21)

Clone
-----

Write on your bash/zsh:
```
git clone https://github.com/arching-kaos/arching-kaos-tools
```

Install
-------
```
cd arching-kaos-tools
sh install.sh
```

Examples
--------

### Add a news article ( `news add` )

You could use ZCHAIN with NEWS model. Or MIXTAPE model, or make your own.
``` bash
news add
```

This would pop up a vim editor for you to write a news article or whatever is text or markdown format with a title.

Saving the file, will save it locally, add it to IPFS, sign it, pack detached signature with metadata on a JSON object. Then a block will be created packing your GPG public key, the news/add action with the JSON object and a detached signature of this, timestamp and finally an entry for the previous *zblock*. After that (!) we finally write this as a json object, add it to IPFS, sign it and pack a *zblock*. That, is published over our IPNS zchain key.

### Explore chains ( `enter` )

You can view your zchain as a JSON object using `enter`. There are some flags in order to either view other zchains or change the depth of view ( includes or ignores data object and action ).

``` bash
$ enter -h
enter - Crawl an arching kaos chain
-----------------------------------
Usage:
        --help, -h                              Print this help and exit
        --chain <ipns-link>, -n <ipns-link>     Crawl specified chain
        --show-zblocks-only, -z                 Show only zblocks
	--no-verify, -nV                        Don't verify signatures

Note that combined flags don't work for now
Running with no flags crawls your chain
```

Podman (or Docker)
------------------

There is a ContainerFile that you can use to build an image which you can then deploy in a container.

Use:

```
podman build -f ContainerFile -t arching-kaos-tools .
```

