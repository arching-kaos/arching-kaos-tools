const { env } = require("process");

const config = {
    port : 8610,
    session : {
        secret:'setabigsecrethere'
    },
    zblockDir : env.AK_ZBLOCKDIR,
    zchain:env.AK_ZCHAIN,
    zchainasc:env.AK_ZCHAINASC,
    zgenesis:env.AK_ZGENESIS,
    zgenesisasc:env.AK_ZGENESISASC,
    zlatest:env.AK_ZLATEST,
    zlist:env.AK_ZLIST,
    zzchain:env.AK_ZZCHAIN,
    binDir:env.AK_BINDIR,
    workDir:env.AK_WORKDIR,
    blocksFile : env.AK_ZBLOCKSFILE,
    pairsFile : env.AK_ZPAIRSFILE,
    minedBlocksDir: env.AK_MINEDBLOCKSDIR

}
module.exports = config; 
