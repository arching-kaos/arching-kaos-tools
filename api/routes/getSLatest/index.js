const { spawn } = require('child_process');

/*
 * Gets the latest SBLOCK from superchain
 * LOL
 * sorry I was laughing at the term.. superchain
 */
function getSLatest(req, res) {
    const command = spawn("ak-schain-latest-cached");
    response_string = "";
    command.stdout.on("data", data => {
        response_string = response_string + data;
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
            res.end(JSON.stringify(JSON.parse(response_string)));
        } else {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end({"error":"unreachable"});
        }
    });
}

module.exports = getSLatest;
