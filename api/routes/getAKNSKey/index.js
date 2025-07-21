const { spawn } = require('child_process');
const fs = require('fs');
const config = require("../../config.js");

/*
 * Gets the local latest zblock AKA zlatest
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
function replyIfOkay(key, res)
{
    const program = "ak-ns";
    const command = spawn(program, ["-rj", key]);
    var buffer = "";
    command.stdout.on("data", data => {
        buffer += data;
    });
    command.stderr.on("data", data => {
        console.log(`stderr: ${data}`);
    });
    command.on('error', (error) => {
        console.log(`error: ${error.message}`);
    });
    command.on("close", code => {
        console.log(`child process ${program} exited with code ${code}`);
        if (code === 0){
            buffer = buffer.trim()
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.end(`${buffer}`);
        } else {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end({"error":"unreachable"});
        }
    });
}

function getAKNSKey(req, res)
{
    var args = req.url.split("/");
    var key = args[3];
    regex= /[a-fA-F0-9]{40}/
    if (regex.test(key))
    {
        key = key.toUpperCase();
        var path = config.akNSDir+"/"+key;
        try
        {
            if(fs.existsSync(path))
            {
                replyIfOkay(key, res)
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

module.exports = getAKNSKey;

