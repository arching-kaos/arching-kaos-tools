const fs = require("node:fs");
const config = require("../../config");

function storeIncomingIP(ip_address)
{
    fs.appendFileSync(`${config.peersDir}/incomingRequests`, `${ip_address}\n`);
}
module.exports = storeIncomingIP;
