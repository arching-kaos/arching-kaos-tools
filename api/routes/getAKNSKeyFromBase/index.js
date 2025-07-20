const { spawn } = require('child_process');
const fs = require('fs');
const config = require("../../config.js");

/*
 * Gets the local latest zblock AKA zlatest
 *
 * Returns:
 *     - JSON object
 *     { zlatest: "Qm..." }
 *
 */
function decodeBase64ToHex(base64String) {
    // Decode the Base64 string
    const binaryString = atob(base64String);

    // Convert the binary string to a byte array
    const byteArray = new Uint8Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
        byteArray[i] = binaryString.charCodeAt(i);
    }

    // Convert the byte array to a hex string representation
    return Array.from(byteArray)
        .map(byte => byte.toString(16).padStart(2, '0')) // Convert to hex and pad with zeros
        .join(''); // Join with spaces for readability
}

// Example usage


function replyIfOkay(key, res)
{
    const program = "ak-ns";
    const base64String = key;
    const decodedHexString = decodeBase64ToHex(base64String);
    formatted_key = decodedHexString.toUpperCase();
    const command = spawn(program, ["-rk", `${formatted_key}`]);

    var buffer = "";
    command.stdout.on("data", data => {
        buffer += data;
    });
    command.stderr.on("data", data => {
        console.log(`stderr: ${data}`);
    });
    command.on('error', (error) => {
        console.log(`error: ${error.message}`);
    });
    command.on("close", code => {
        console.log(`child process ${program} exited with code ${code}`);
        if (code === 0){
            buffer = buffer.trim()
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({
                key:`${formatted_key}`,
                resolved:`${buffer}`
            }));
        } else {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({error:"unreachable"}));
        }
    });
}

function getAKNSKeyFromBase(req, res)
{
    var args = req.url.split("/");
    var key = args[3];
    regex= /[a-zA-Z0-9+\/=]{29}/
    const base64Regex = /^[A-Z0-9+\/=]/i;
    if (base64Regex.test(key))
    {
    // key = key.toUpperCase();
    //   var path = config.akNSDir+"/"+key;
        try
        {
            replyIfOkay(key, res)
        }
        catch (error)
        {
            res.writeHead(404, {'Content-Type': 'application/json'});
            res.end(JSON.stringify({"error":error.message}));
        }
   }
   else
   {
       res.writeHead(404, {'Content-Type': 'application/json'});
       res.end(JSON.stringify({error:"No hash"}));
   }
}

module.exports = getAKNSKeyFromBase;

