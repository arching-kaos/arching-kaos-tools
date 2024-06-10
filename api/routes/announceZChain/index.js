/*
 * Accepts a zchain
 *
 * Checks:
 *     1. Exists,
 *     2. Length is 62 bytes,
 *     3. Matches regular expression /k51qzi5uqu5d[A-Za-z0-9]{50}/
 *
 * Returns:
 *     - error on failure
 *     - on success the string is processed for further validation to the
 *     function getNSvalidity()
 *
 */
const getNSvalidity = require('../../validators/ZchainValidator');

module.exports = (req, res) => {
    console.log(req);
    if ( (req.body.zchain) && typeof req.body.zchain === "string" && req.body.zchain.length === 62 ){
        let zchain = req.body.zchain;
        regex= /k51qzi5uqu5d[A-Za-z0-9]{50}/
        if (regex.test(zchain)){
            getNSvalidity(zchain,res);
        } else {
            res.send({error:"Invalid data"});
        }
    } else {
        res.send({error:"Invalid data"});
    }
}
