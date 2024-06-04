const { spawn } = require('child_process');
const fs = require("fs");
const config = require("../../config");

/*
 * Gets a file chunk
 *
 * Returns:
 *  the chunk
 *
 */
function fetchFtr(tr, res){
    const command = spawn("cat",[config.workDir+"/ftr/"+tr]);
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
        res.set('Content-Type', 'application/json');

        if ( code === 0 ) {
            const path = config.workDir+"/ftr/"+tr;
            console.log(path)
            try {
                if(fs.existsSync(path)){
                    res.send(fs.readFileSync(path));
                }
            } catch (error) {
                res.send({"error":error.message});
            }
        } else if ( code === 2){
            res.send({"error":"The roof is on fire"});
        } else {
            res.send({"error":"invalid or unreachable"});
        }
    });
};
module.exports = (req, res) => {
    console.log(req.params)
    res.set('Content-Type', 'application/json');
    if ( (req.params.tr) && typeof req.params.tr === "string" && req.params.tr.length === 128 ){
        regex= /[a-f0-9]{128}/;
        if (regex.test(req.params.tr)){
            let tr = req.params.tr;
            if (tr === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" ){
                res.send({error:"Genesis block"});
            } else {
                fetchFtr(tr,res);
            }
        } else {
            res.send({error:"Invalid data: regexp failed to pass"});
        }
    } else {
        res.send({error:"Invalid data: no valid zblock was provided"});
    }
}
