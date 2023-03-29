const { spawn } = require('child_process');
const config = require("../../config.js");


/*
 * Gets a SBLOCK from superchain
 * LOL
 *
 */
module.exports = (req, res) => {
    regex= /[a-f0-9]{128}/
    if (regex.test(req.query.sblock)){
        genesisreg = /0{128}/
        if (!genesisreg.test(req.query.sblock)){
            const command = spawn("cat",[config.minedBlocksDir+req.query.sblock]);
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
                smt = JSON.stringify(response_string);
                res.send({hrefPrevious:"http://127.0.0.1:8610/v0/sblock?sblock="+smt.previous,sblock:smt});
        //                res.send(JSON.parse(response_string));
                console.log(`child process exited with code ${code}`);
            });
        } else {
            res.send({sblock:"Genesis Block - Arching Kaos Net"});
        }
    } else {
        res.send({"error":"No hash"})
    }
}

