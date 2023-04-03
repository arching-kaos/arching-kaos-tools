const { spawn } = require('child_process');
const fs = require("fs");
const config = require("../../config");

/*
 * Gets the local latest zblock
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
module.exports = (req, res) => {
    const command = spawn("ak-zblock-cache",[req.query.zblock]);
    command.stdout.on("data", data => {
    });

    command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
    });

    command.on('error', (error) => {
            console.log(`error: ${error.message}`);
    });

    command.on("close", code => {
        console.log(`child process exited with code ${code}`);

        if ( code == 0 ) {
            res.send(JSON.parse(fs.readFileSync(config.zblockDir+"/"+req.query.zblock)));
        } else {
            res.send({"error":"error"});
        }
    });
};
