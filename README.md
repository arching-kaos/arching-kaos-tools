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
Defaults
--------

Installs binaries and scripts on your $HOME folder.

TODO
----

 - [x] - Install on zsh (export ~/bin to $PATH in .zshrc file)
 - [x] - Install on bash (the same but to .bashrc file
 - [ ] - Make a useful tool of this

Tools

- IPFS tool (installer, checker, updater, swarm settings)
 - [x] - Installer
 - [x] - Checker
 - [x] - Updater
 - [x] - Swarm setting

- Rename IPFS tool to storage or something
 - [ ] - Modular (call per command)
 - [ ] - installer
 - [ ] - checker
 - [ ] - updater
 - [ ] - swarm setting

Examples
--------

You could use ZCHAIN with NEWS model. Or MIXTAPE model, or make your own.

Podman (or Docker)
------------------

There is a ContainerFile that you can use to build an image which you can then deploy in a container.

Use:

```
podman build -f ContainerFile -t arching-kaos-tools .
```

