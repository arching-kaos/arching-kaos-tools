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
    res.set('Content-Type', 'application/json');
    const path = config.workDir+"/ftr/"+tr;
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
    if ( (req.params.tr) && typeof req.params.tr === "string" && req.params.tr.length === 128 ){
        regex= /[a-f0-9]{128}/;
        if (regex.test(req.params.tr)){
            let tr = req.params.tr;
            fetchFtr(tr,res);
        } else {
            res.send({error:"Invalid data: regexp failed to pass"});
        }
    } else {
        res.send({error:"Invalid data: no valid zblock was provided"});
    }
}
