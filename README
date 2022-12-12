Arching Kaos Tools
==================

Description
-----------

Warning: this is a bunch of tools that may not make sense. :)

This is an installable repo which provides various tools for running Arching Kaos and using it.

Changes are mentioned in `git log` of the repo, as well as in [CHANGELOG](https://github.com/arching-kaos/arching-kaos-tools/blob/master/CHANGELOG) file.

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
- jq (v1.6)

`json_pp` is also used put you cat remove it and change it with `jq`

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
Update
------
```
git pull
./update.sh
```

Examples
--------

### Add a news article ( `news add` )

You could use ZCHAIN with NEWS model. Or MIXTAPE model, or make your own.
``` bash
$ news create
```

This would pop up a vim editor for you to write a news article or whatever is text or markdown format with a title.

Saving the file, will save it locally, add it to IPFS, sign it, pack detached signature with metadata on a JSON object. Then a block will be created packing your GPG public key, the news/add action with the JSON object and a detached signature of this, timestamp and finally an entry for the previous *zblock*. After that (!) we finally write this as a json object, add it to IPFS, sign it and pack a *zblock*. That, is published over our IPNS zchain key.

Other options... let's try help! 

``` console
$ news help
ak-news-cli
--------------
#TODO
All you need to know is that there are two options available:
help            Prints this help message
index           Prints an indexed table of your news files
import <file>   #TODO
add <file>      Creates a data file from the news file you point to
create          Vim is going to pop up, you will write and save your
                  newsletter and it's going to be saved
```

Clearly there is a TODO item. Import is not working so avoid it, or fix it.
Add is nice, you can add an already existing file directly. `news` is the second module after `mixtape`. Both modules need refactoring but they work at a level that someone can be productive with these tools.  

### Explore chains ( `enter` )

You can view your zchain as a JSON object using `enter`. There are some flags in order to either view other zchains or change the depth of view ( includes or ignores data object and action ).

``` console
$ enter -h
enter - Crawl an arching kaos chain
-----------------------------------
Usage:
        --help, -h                              Print this help and exit
        --chain <ipns-link>, -n <ipns-link>     Crawl specified chain
        --show-zblocks-only, -z                 Show only zblocks
        --no-verify, -nV                        Don't verify signatures
        <ipfs-link>                             Specify IPFS CID for entrance


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

TODO
----

Next things to come are:
- zblock manipulator to fix wrong previous block references and repack zblocks.
- zchain rebase-like procedure to move the zblocks to another seed or set another previous block (e.g. join chains)
- Clean up installation and filesystem usage
- Log rotate to gzip archives
- Filters for log searching for IPFS hashes or names
- Use of IPFS file system to store/pin sub chains, previous chains or other chains

Concepts under thought
----------------------

- Base chain, derived from personal ones.
- Daemon to monitor chains' states, update and sign new zblocks.
- Find a minimum agreement of what is valid or not. (important)
- Spam defence (e.g. how to protect the network from abuse cases) (important)
- Reduce size of all parts of chain (stringify JSON) (improvement)

