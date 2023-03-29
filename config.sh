export AK_IPFS="$(which ipfs)"
export AK_ROOT=$HOME
export AK_WORKDIR="$AK_ROOT/.arching-kaos"
export AK_CONFIGDIR="$AK_WORKDIR/config"
export AK_BINDIR="$AK_WORKDIR/bin"
export AK_ZBLOCKDIR="$AK_WORKDIR/zblocks"
export AK_BLOCKDIR="$AK_WORKDIR/blocks"
export AK_DATADIR="$AK_WORKDIR/data"
export AK_ARCHIVESDIR="$AK_WORKDIR/archives"
export AK_GENESIS="$AK_CONFIGDIR/genesis"
export AK_GENESISASC="$AK_CONFIGDIR/genesis.asc"
export AK_ZGENESIS="$AK_CONFIGDIR/zgenesis"
export AK_ZGENESISASC="$AK_CONFIGDIR/zgenesisasc"
export AK_ZCHAIN="$AK_CONFIGDIR/zchain"
export AK_ZCHAINASC="$AK_CONFIGDIR/zchain.asc"
export AK_ZZCHAIN="$AK_CONFIGDIR/zzchain"
export AK_ZLIST="$AK_WORKDIR/zlist"
export AK_ZLATEST="$AK_WORKDIR/zlatest"
export AK_LOGSFILE="$AK_WORKDIR/logs"
export AK_FINGERPRINT="$(gpg --list-keys | grep test@test.test -1 | head -n1 | awk '{print $1}')"

