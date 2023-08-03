const { spawn } = require('child_process');
const fs = require("fs");
const config = require("../../config");

/*
 * Gets the local latest zblock
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
function fetchZblock(zblock, res){
    const command = spawn("ak-zblock-cache",[zblock]);
    command.stdout.on("data", data => {
    });

    command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
    });

    command.on('error', (error) => {
            console.log(`error: ${error.message}`);
    });

    command.on("close", code => {
        console.log(`child process exited with code ${code}`);

        if ( code === 0 ) {
            const path = config.cacheDir+"/fzblocks/"+zblock;
            console.log(path)
            try {
                if(fs.existsSync(path)){
                    res.send(JSON.parse(fs.readFileSync(path)));
                }
            } catch (error) {
                res.send({"error":error.message});
            }
        } else if ( code === 2){
            res.send({"error":"The roof is on fire"});
        } else {
            res.send({"error":"invalid or unreachable"});
        }
    });
};
module.exports = (req, res) => {
    console.log(req.params)
    if ( (req.params.zblock) && req.params.zblock.length === 46 ){
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(req.params.zblock)){
            if (req.params.zblock === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" ){
                res.send({error:"Genesis block"});
            } else {
                fetchZblock(req.params.zblock,res);
            }
        } else {
            res.send({error:"Invalid data: regexp failed to pass"});
        }
    } else {
        res.send({error:"Invalid data: no valid zblock was provided"});
    }
}
