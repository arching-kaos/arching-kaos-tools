const { spawn } = require('child_process');

/*
 * Gets the local latest zblock AKA zlatest
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
function getZLatest(req, res)
{
    const command = spawn("ak-get-zlatest");
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
        console.log(`child process exited with code ${code}`);
        if (code === 0){
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({zlatest:`${buffer}`}));
        } else {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end({"error":"unreachable"});
        }
    });
}

module.exports = getZLatest;
