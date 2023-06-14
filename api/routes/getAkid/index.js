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
    const command = spawn("ak-config", ["get-published"]);
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
            res.send(buffer);
            console.log(`child process exited with code ${code}`);
    });
};
