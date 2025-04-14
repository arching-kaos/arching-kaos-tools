/*
 * Receives an SHA512SUM as a SBlock and if exists returns the SBlock content.
 *
 */

const { spawn } = require('child_process');
const fs = require('fs');
const config = require("../../config.js");

function getSBlock(req, res)
{
    var args = req.url.split("/");
    var sblock = args[3];
    regex= /[a-f0-9]{128}/
    if (regex.test(sblock)){
        genesisreg = /0{128}/
        if (!genesisreg.test(sblock)){
            var path = config.minedBlocksDir+"/"+sblock;
            const command = spawn("cat",[config.minedBlocksDir+"/"+sblock]);
            response_string = "";
            command.stdout.on("data", data => {
                response_string += data;
            });
            command.stderr.on("data", data => {
                console.log(`stderr: ${data}`);
            });
            command.on('error', (error) => {
                console.log(`error: ${error.message}`);
                response_string={err:"error.message"};
            });
            command.on("close", code => {
                if ( code === 0 ) {
                    res.writeHead(200, {'Content-Type': 'application/json'});
                    res.end(JSON.stringify(JSON.parse(fs.readFileSync(path))));
                } else {
                    res.writeHead(404, {'Content-Type': 'application/json'});
                    res.end(JSON.stringify({error:"Sblock not found"}));
                }
                console.log(`child process exited with code ${code}`);
            });
        } else {
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({sblock:"Genesis Block - Arching Kaos Net"}));
        }
    } else {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"No hash"}));
    }
}
module.exports = getSBlock;
