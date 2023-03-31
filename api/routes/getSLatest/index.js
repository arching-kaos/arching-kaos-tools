const { spawn } = require('child_process');
const os = require("os");
const HomeDir = os.userInfo().homedir;

/*
 * Gets the latest SBLOCK from superchain
 * LOL
 * sorry I was laughing at the term.. superchain
 */
module.exports = (req, res) => {
    const command = spawn("ak-find-latest-mined-sblock");
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
            res.send(JSON.parse(response_string));
            console.log(`child process exited with code ${code}`);
    });
}
