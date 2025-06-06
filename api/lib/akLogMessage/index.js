const { spawn } = require('child_process');
const config = require('../../config')

function akLogMessage(type, message)
{
    const command = spawn(
        "ak-log",
        ["-m", "ak-daemon", type, message]
    );

    var buffer = "";
    command.stdout.on("data", data => {
        console.log(`stdout: ${data}`);
    });

    command.stderr.on("data", data => {
        buffer = buffer + data;
    });

    command.on('error', (error) => {
        console.log(`error: ${error.message}`);
    });

    command.on("close", (code) => {
        console.log(buffer);
        if (config.printDebug === "yes") console.log(buffer);
        console.log(`child process exited with code ${code}`);
    });
};
module.exports = akLogMessage;
