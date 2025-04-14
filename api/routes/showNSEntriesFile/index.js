const fs = require('fs');
const config = require('../../config');

/*
 * Reads ./szch file where the zchains with their
 * zlatest's are saved.
 *
 * Returns:
 *     - the file, it's already in JSON format.
 *
 */
function showNSEntriesFile(req, res)
{
    var data = JSON.parse(fs.readFileSync(config.pairsFile));
    res.send(data);
};
module.exports = showNSEntriesFile;
