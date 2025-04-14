const { spawn } = require('child_process');

/*
 * Gets the local chain as minified version
 *
 * Returns:
 *     - A JSON array representing the nodes' arching-kaos-zchain
 *
 */
function getZChain(req, res)
{
    const command = spawn("ak", ["zchain", "--crawl"]);
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
        res.send(JSON.parse(response_string)/*.reverse()*/);
            console.log(`child process exited with code ${code}`);
    });
};

module.exports = getZChain;
