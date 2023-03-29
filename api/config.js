const process = require("process");
const env = process.env;

module.exports = {
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
    blocksFile : this.workDir+"/zBlocksFile",
    pairsFile : this.workDir+"/pairsFile",
    minedBlocksDir: env.AK_MINEDBLOCKSDIR

}

