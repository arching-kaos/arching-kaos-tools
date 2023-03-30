/*
 * After NS validation went through we examine the return code
 * of the application that run the test.
 *
 * Returns:
 *     - errno on failure
 *     - on success we process with addNSEntriesToFile()
 *
 */
function continuethingsNS(validitycode,sh,res,gotit){
    if (validitycode === 0){
        var entry = {
            zchain: sh,
            latest: JSON.parse(gotit).Path.replace('/ipfs/','')
        };
        addNSEntriesToFile(entry,res);
    } else {
        res.send({errno:"Invalid data"});
    }
}
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
const getNSvalidity = require('../../validators/ZchainValidator')

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
