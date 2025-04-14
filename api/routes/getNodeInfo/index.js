const { spawn } = require('child_process');

function getNodeInfo(req, res)
{
    const command = spawn("ak-config", ["--get-published"]);
    var buffer = "";
    command.stdout.on("data", data => {
        console.log(`stdout: ${data}`);
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
};
module.exports = getNodeInfo;
