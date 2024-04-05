const { spawn } = require('child_process');
const akLogMessage = require('../../lib/akLogMessage');

module.exports = (req, res) => {
    akLogMessage('INFO', `Incoming from [${req.socket._peername.address}]:${req.socket._peername.port} @ ${req.get('host')}${req._parsedOriginalUrl.pathname}`);
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
            res.send(JSON.parse(buffer));
            console.log(`child process exited with code ${code}`);
    });
};
