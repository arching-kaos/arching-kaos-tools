const fs = require('fs');
const config = require('../../config');

/*
 * Reads ./lol file where the zblocks are saved
 *
 * Returns:
 *     - the file, it's already in JSON format.
 *
 */
function showEntriesFile(req, res)
{
    var data = JSON.parse(fs.readFileSync(config.blocksFile));
    res.send(data);
};
module.exports = showEntriesFile;
