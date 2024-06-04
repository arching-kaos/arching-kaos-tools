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
    res.send(fs.readFileSync(config.workDir+"/ipfs/"+zblock));
};
module.exports = (req, res) => {
    console.log(req.query)
    if ( (req.query.ipfs) && typeof req.query.ipfs === "string" && req.query.ipfs.length === 46 ){
        let ipfs = req.query.ipfs;
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(ipfs)){
            if (ipfs === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" ){
                res.send({error:"Genesis block"});
            } else {
                fetchZblock(ipfs,res);
            }
        } else {
            res.send({error:"Invalid data: regexp failed to pass"});
        }
    } else {
        res.send({error:"Invalid data: no valid zblock was provided"});
    }
}
