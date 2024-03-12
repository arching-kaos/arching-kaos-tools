const { spawn } = require('child_process');
const config = require('../../config');
const fs = require('fs');

module.exports = (req, res) => {
//    const command = spawn("ak-config", ["get-published"]);
    const path = config.peersFile;
    if(fs.existsSync(path)){
        res.send(JSON.parse(fs.readFileSync(path)));
    } else {
        res.send({"error":"404"})
    }
//    var buffer = "";
//    command.stdout.on("data", data => {
//        buffer = buffer + data;
//    });
//
//    command.stderr.on("data", data => {
//            console.log(`stderr: ${data}`);
//    });
//
//    command.on('error', (error) => {
//            console.log(`error: ${error.message}`);
//    });
//
//    command.on("close", code => {
//            res.send(JSON.parse(fs.Read));
//            console.log(`child process exited with code ${code}`);
//    });
};
