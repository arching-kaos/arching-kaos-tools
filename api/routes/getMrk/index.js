const fs = require("fs");
const config = require("../../config");

/*
 * Gets a local merkle leaf
 *
 * Returns:
 *  the merkle leaf
 *
 */
function fetchFmrk(mrk, res){
    res.set('Content-Type', 'application/json');
    const path = config.workDir+"/fmrk/"+mrk;
    // console.log(path)
    try {
        if(fs.existsSync(path)){
            res.send(fs.readFileSync(path));
        }
    } catch (error) {
        res.send({"error":error.message});
    }
};

module.exports = (req, res) => {
    console.log(req.params)
    res.set('Content-Type', 'application/json');
    if ( (req.params.mrk) && typeof req.params.mrk === "string" && req.params.mrk.length === 128 ){
        regex= /[a-f0-9]{128}/;
        if (regex.test(req.params.mrk)){
            let mrk = req.params.mrk;
            fetchFmrk(mrk,res);
        } else {
            res.send({error:"Invalid data: regexp failed to pass"});
        }
    } else {
        res.send({error:"Invalid data: no valid zblock was provided"});
    }
}
