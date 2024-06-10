const { spawn } = require('child_process');
const fs = require("fs");
const config = require("../../config");

/*
 * Returns a cached zblock
 *
 * Returns:
 *     - JSON object
 *
 */
function fetchZblock(zblock, res){
    regex= /Qm[A-Za-z0-9]{44}/;
    if (regex.test(zblock)){
        const command = spawn("ak-zblock",["--cache",zblock]);

        command.on("close", code => {
            console.warn(`child process exited with code ${code}`);

            if ( code === 0 ) {
                const path = config.cacheDir+"/fzblocks/"+zblock;
                console.log(path)
                try {
                    if(fs.existsSync(path)){
                        var buffer = fs.readFileSync(path);
                        res.writeHead(200, {'Content-Type': 'application/json'});
                        res.end(JSON.stringify(JSON.parse(buffer)));
                    }
                } catch (error) {
                    res.writeHead(404, {'Content-Type': 'application/json'});
                    res.end({"error":error.message});
                }
            } else if ( code === 2){
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end({"error":"The roof is on fire"});
            } else {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end({"error":"invalid or unreachable"});
            }
        });
    } else {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"Invalid data: regexp failed to pass"}));
    }
};

module.exports = (req, res) => {
    var args = req.url.split("/");
    if ( (args[2] === 'zblock') && args[3] && typeof args[3] === "string" && args[3].length === 46 ){
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(args[3])){
            if (args[3] === "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH" ){
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({error:"Genesis block"}));
            } else {
                fetchZblock(args[3],res);
            }
        } else {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({error:"Invalid data: regexp failed to pass"}));
        }
    } else {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({error:"Invalid data: no valid zblock was provided"}));
    }
}
