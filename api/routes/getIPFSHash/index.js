const { spawn } = require('child_process');
const fs = require("fs");
const config = require("../../config");
const akLogMessage = require("../../lib/akLogMessage");
akLogMessage('lol');

/*
 * Returns a cached ipfs_hash
 *
 * Returns:
 *     - JSON object
 *
 */
function fetchIPFShash(ipfs_hash, res)
{
    regex= /Qm[A-Za-z0-9]{44}/;
    if (regex.test(ipfs_hash)){
        const path = `${config.ipfsArtifactsDir}/${ipfs_hash}`;
        console.log(path)
        try
        {
            if(fs.existsSync(path))
            {
                res.writeHead(200); //, {'Content-Type': 'application/json'});
                // res.end(JSON.stringify(JSON.parse(fs.readFileSync(path))));
                res.end(fs.readFileSync(path));
            }
            else
            {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({error:"invalid or unreachable"}));
            }
        }
        catch (error)
        {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({error:error.message}));
        }
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"Invalid data: regexp failed to pass"}));
    }
};

function getIPFSHash(req, res)
{
    var args = req.url.split("/");
    if ( (args[2] === 'ipfs_hash'||args[2] === 'ipfs') && args[3] && typeof args[3] === "string" && args[3].length === 46 ){
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(args[3]))
        {
            if (args[3] === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" )
            {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({error:"Genesis block"}));
            }
            else
            {
                fetchIPFShash(args[3],res);
            }
        }
        else
        {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({error:"Invalid data: regexp failed to pass"}));
        }
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"Invalid data: no valid ipfs_hash was provided"}));
    }
}
module.exports = getIPFSHash;
