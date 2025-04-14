/*
 * Receives an SHA512SUM as a chunk's hash and if exists it
 * returns the chunk's content
 *
 */

const fs = require('fs');
const config = require("../../config.js");

function getChunk(req, res)
{
    var args = req.url.split("/");
    var hash = args[3];
    regex= /[a-f0-9]{128}/
    if (regex.test(hash))
    {
        var path = config.chunksDir+"/"+hash;
        try
        {
            if(fs.existsSync(path))
            {
                res.writeHead(200, {'Content-Type': 'application/json'});
                res.end(fs.readFileSync(path));
            }
            else
            {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({"error":"not found"}));
            }
        }
        catch (error)
        {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({"error":error.message}));
        }
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"No hash"}));
    }
}
module.exports = getChunk;
