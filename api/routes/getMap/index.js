/*
 * Receives an SHA512SUM as a map's hash and if exists it
 * returns the map's content
 *
 */

const fs = require('fs');
const config = require("../../config.js");

function getMap(req, res)
{
    var args = req.url.split("/");
    var hash = args[3];
    regex= /[a-f0-9]{128}/
    if (regex.test(hash))
    {
        var path = config.mapsDir+"/"+hash;
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
module.exports = getMap;
