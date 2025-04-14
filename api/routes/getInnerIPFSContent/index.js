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
    res.writeHead(200, { 'Content-Type': 'application/json'});
    var path = config.workDir+"/ipfs/"+zblock;
    res.end(JSON.stringify(JSON.parse(fs.readFileSync(path))));
};

function getInnerIPFSContent(req, res)
{
    console.log(req.query)
    if ( (req.query.ipfs) && typeof req.query.ipfs === "string" && req.query.ipfs.length === 46 ){
        let ipfs = req.query.ipfs;
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(ipfs)){
            if (ipfs === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" ){
                res.writeHead(200, { 'Content-Type': 'application/json'});
                res.end(JSON.stringify({error:"Genesis block"}));
            } else {
                fetchZblock(ipfs,res);
            }
        } else {
            res.writeHead(404, { 'Content-Type': 'application/json'});
            res.end(JSON.stringify({error:"Invalid data: regexp failed to pass"}));
        }
    } else {
        res.writeHead(404, { 'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"Invalid data: no valid zblock was provided"}));
    }
}
module.exports = getInnerIPFSContent;
