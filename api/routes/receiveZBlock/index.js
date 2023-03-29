/*
 * Accepts a ZBLOCK!
 * 
 * Checks:
 *     1. Exists,
 *     2. Length is 46 bytes,
 *     3. Matches regular expression /Qm[A-Za-z0-9]{44}/
 *
 * Returns:
 *     - errno on failure
 *     - on success the string is processed for further
 *    validation to the function getvalidity()
 *
 */
const getvalidity = require('../../validators/ZblockValidator')
module.exports = (req, res) => {
    console.log("okay we got called")
    if ( (req.body.zblock) && req.body.zblock.length === 46 ){
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(req.body.zblock)){
            getvalidity(req.body.zblock,res);
        } else {
            res.send({errno:"Invalid data"});
        }
    } else {
        res.send({errno:"Invalid data"});
    }
}
