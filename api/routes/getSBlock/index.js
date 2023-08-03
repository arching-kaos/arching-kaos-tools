/*
 * Receives an SHA512SUM as a SBlock and if exists returns the SBlock content.
 *
 */

const { spawn } = require('child_process');
const fs = require('fs');
const config = require("../../config.js");

module.exports = (req, res) => {
    regex= /[a-f0-9]{128}/
    if (regex.test(req.params.sblock)){
        genesisreg = /0{128}/
        if (!genesisreg.test(req.params.sblock)){
            var path = config.minedBlocksDir+"/"+req.params.sblock;
            const command = spawn("cat",[config.minedBlocksDir+"/"+req.params.sblock]);
            response_string = "";
            command.stdout.on("data", data => {
                response_string = response_string+data;
            });

            command.stderr.on("data", data => {
                console.log(`stderr: ${data}`);
            });

            command.on('error', (error) => {
                console.log(`error: ${error.message}`);
                response_string={err:"error.message"};
            });

            command.on("close", code => {
                if ( code === 0 ) {
                    res.send(JSON.parse(fs.readFileSync(path)));
                } else {
                    res.send({"error":"Sblock not found"})
                }
                console.log(`child process exited with code ${code}`);
            });
        } else {
            res.send({sblock:"Genesis Block - Arching Kaos Net"});
        }
    } else {
        res.send({"error":"No hash"})
    }
}

