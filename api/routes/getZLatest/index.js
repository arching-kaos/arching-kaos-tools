const { spawn } = require('child_process');

/*
 * Gets the local latest zblock
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
module.exports = (req, res) => {
    const command = spawn("ak-get-latest");
    command.stdout.on("data", data => {
            res.send({zlatest:`${data}`});
    });

    command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
    });

    command.on('error', (error) => {
            console.log(`error: ${error.message}`);
    });

    command.on("close", code => {
            console.log(`child process exited with code ${code}`);
    });
};