/*
 * Receives an SHA512SUM as a map's hash and if exists it
 * returns the map's content
 *
 */

const { spawn } = require('child_process');
const config = require("../../config.js");

module.exports = (req, res) => {
    var args = req.url.split("/");
    var ip = "";
    if ( args.length === 4 )
    {
        ip = args[3];
    }
    var test = /^fc[0-9a-z]{1,2}:([0-9a-z]{1,4}:){1,6}[0-9a-z]{1,4}/
    if (test.test(ip))
    {
        const command = spawn("curl", ["--retry-max-time","3","-s",`http://[${ip}]:8610/v0/node_info`]);
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
            res.writeHead(200, { 'Content-Type': 'application/json'});
            res.end(buffer);
            console.log(`child process exited with code ${code}`);
        });
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"No IP"}));
    }
}

