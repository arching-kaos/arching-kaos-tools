/*
 * Receives an SHA512SUM as a map's hash and if exists it
 * returns the map's content
 *
 */

const { spawn } = require('child_process');
const config = require("../../config.js");
const checkIfAllowedIP = require('../../lib/checkIfAllowedIP/index.js');

module.exports = (req, res) => {
    var args = req.url.split("/");
    var ip = "";
    if ( args.length === 4 )
    {
        ip = args[3];
    }
    if (checkIfAllowedIP(ip))
    {
        const command = spawn("curl", ["--retry-max-time","3","-s",`http://[${ip}]:8610/v0/peers`]);
        var buffer = "";
        command.stdout.on("data", data => {
            buffer = buffer + data;
        });

        command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
        });

        command.on('error', (error) => {
            console.log(`error: ${error.message}`);
        });

        command.on("close", code => {
            if ( code === 0 )
            {
                res.writeHead(200, { 'Content-Type': 'application/json'});
                res.end(buffer);
            }
            else
            {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({error:"Peer unreachable"}));
            }
            console.log(`child process exited with code ${code}`);
        });
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"No IP"}));
    }
}

