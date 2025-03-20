const fs = require("node:fs");
const config = require("../../config");

module.exports = (ip_address) => {
    fs.appendFileSync(`${config.peersDir}/incomingRequests`, `${ip_address}\n`);
}
