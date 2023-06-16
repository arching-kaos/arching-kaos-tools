/*
 * To verify a block we simply put it on `enter`. `enter` will crawl
 * the zchain that is connected to the zblock we got. If it fails for
 * any reason we can check `logfollow` for that.
 */

const { spawn } = require("child_process");
const fs = require("fs");
const config = require("../../config.js");
console.log(config);

/*
 * Adds a latest given zblock to a file.
 *
 * Returns:
 *     - error if error
 *     - success:
 *         - adds the entry to the file
 *         - returns the whole file to the client
 *
 */
function addEntriesToFile(entry,res){
    var data = JSON.parse(fs.readFileSync(config.blocksFile));

    var duplicate_entry = 0;
    data.forEach(a=>{
        if ( a.zblock === entry.zblock ){
            duplicate_entry = 1;
            res.send({error:"already there"});
        }
    });

    if ( duplicate_entry === 0 ) {
        var all = [entry];
        for (var i = 0; i < data.length; i++){
            all[i+1] = data[i];
        }
        var json = JSON.stringify(all);
        fs.writeFile(config.blocksFile, json, 'utf8', finished);
        function finished(err) {
            console.log('finished writing file');
        }
        res.send(json);
    }
}
/*
 * After validation went through we examine the return code
 * of the application that run the test.
 *
 * Returns :
 *     - error on failure
 *     - on success we process with addEntriesToFile()
 *
 */
function continuethings(exitcode,sh,res){
    if (exitcode === 0){
        var entry = {zblock:sh};
        addEntriesToFile(entry,res);
    } else {
        res.send({error:"Invalid data"});
    }
}
/*
 * We send the data tested and the exit code to continuethings()
 *
 */
module.exports = (ch, res) => {
    const command = spawn("ak-enter",[ch]);
    response_string = "";
    command.stdout.on("data", data => {
        response_string = response_string + data;
        console.log(`${data}`);
    });

    command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
    });

    command.on('error', (error) => {
            console.log(`error: ${error.message}`);
    });

    command.on("close", code => {
        console.log(`child process exited with code ${code}`);
        continuethings(code,ch,res);
    });
};
