/*
 * Accepts a zchain
 *
 * Checks:
 *     1. Exists,
 *     2. Length is 62 bytes,
 *     3. Matches regular expression /k51qzi5uqu5d[A-Za-z0-9]{50}/
 *
 * Returns:
 *     - errno on failure
 *     - on success the string is processed for further validation to the
 *     function getNSvalidity()
 *
 */

module.exports = (req, res) => {
    if ( (req.body.zchain) && req.body.zchain.length === 62 ){//&& req.body.block_signature.length === 46){
        regex= /k51qzi5uqu5d[A-Za-z0-9]{50}/
        if (regex.test(req.body.zchain)){ // && regex.test(req.body.block_signature)){
            getNSvalidity(req.body.zchain,res);
        } else {
            res.send({errno:"Invalid data"});
        }
    } else {
        res.send({errno:"Invalid data"});
    }
}
