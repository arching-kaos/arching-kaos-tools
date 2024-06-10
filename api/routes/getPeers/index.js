const config = require('../../config');
const fs = require('fs');

module.exports = (req, res) => {
    const path = config.peersFile;
    if(fs.existsSync(path)){
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(JSON.parse(fs.readFileSync(path))));
    } else {
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end({"error":"No peers :("})
    }
};
