const config = require('../../config');
const fs = require('fs');

module.exports = (req, res) => {
    const path = config.peersFile;
    if(fs.existsSync(path)){
        res.send(JSON.parse(fs.readFileSync(path)));
    } else {
        res.send({"error":"404"})
    }
};
