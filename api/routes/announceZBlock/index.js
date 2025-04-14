/*
 * Accepts a ZBLOCK!
 * 
 * Checks:
 *     1. Exists,
 *     2. Length is 46 bytes,
 *     3. Matches regular expression /Qm[A-Za-z0-9]{44}/
 *
 * Returns:
 *     - error on failure
 *     - on success the string is processed for further
 *    validation to the function getvalidity()
 *
 */
const getvalidity = require('../../validators/ZblockValidator')
function announceZBlock(req, res)
{
    console.log(req);
    if ( (req.body.zblock) && typeof req.body.zblock === "string" && req.body.zblock.length === 46 ){
        let zblock = req.body.zblock;
        regex= /Qm[A-Za-z0-9]{44}/;
        if (regex.test(zblock)){
            getvalidity(zblock,res);
        } else {
            res.send({error:"Invalid data"});
        }
    } else {
        res.send({error:"Invalid data"});
    }
}
module.exports = announceZBlock;
