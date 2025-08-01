const http = require("node:http");

const welcomeMessage = require("./routes/default/index.js");
const getAKNSKey = require("./routes/getAKNSKey/index.js");
const getAKNSKeyFromBase = require("./routes/getAKNSKeyFromBase/index.js");
const getNodeInfo = require('./routes/getNodeInfo/index.js');
const getPeers = require('./routes/getPeers/index.js');
const getIPFSHash = require('./routes/getIPFSHash/index.js');
const getZlatest = require('./routes/getZLatest/index.js');
const getSblock = require('./routes/getSBlock/index.js');
const getChunk = require('./routes/getChunk/index.js');
const getLeaf = require('./routes/getLeaf/index.js');
const getMap = require('./routes/getMap/index.js');
const getSlatest = require('./routes/getSLatest/index.js');
const getRemoteNodeInfo = require('./routes/getRemoteNodeInfo/index.js');
const getRemotePeers = require('./routes/getRemotePeers/index.js');

const akLogMessage = require('./lib/akLogMessage');
const checkIfAllowedIP = require('./lib/checkIfAllowedIP/index.js');
const storeIncomingIP = require("./lib/storeIncomingIP/index.js");
akLogMessage('INFO', 'akLogMessage loaded');

const serverOptions = { keepAliveTimeout: 60000 };

function printRequest(req)
{
    storeIncomingIP(req.connection.remoteAddress);
    console.log(req.connection.remoteAddress);
    console.log(req.headers.host);
    console.log(req.headers);
    console.log(req.method, req.url);
    console.log('HTTP/' + req.httpVersion);
}

function respondError(res, errorMessage)
{
    res.writeHead(404, { 'Content-Type': 'application/json'});
    res.end(JSON.stringify({
        error: errorMessage
    }));
}

function testRootRoute(req, res)
{
    notImplemented(req, res);
}

function testRoute(req, res)
{
    respondError(res, "Mpla mpla");
}

function getRoutes(req, res)
{
    var args = req.url.split('/');
    if (args[1] === 'v0' && args.length > 2 && args[2] !== ""){
        switch(args[2])
        {
            case 'test': testRoute(req, res); break;
            case 'root': testRootRoute(req, res); break;
            case 'peers': getPeers(req, res); break;
            case 'node_info': getNodeInfo(req, res); break;
            case 'ipfs_hash': getIPFSHash(req, res); break;
            case 'ipfs': getIPFSHash(req, res); break;
            case 'zlatest': getZlatest(req, res); break;
            case 'sblock': getSblock(req, res); break;
            case 'slatest': getSlatest(req, res); break;
            case 'chunk': getChunk(req, res); break;
            case 'leaf': getLeaf(req, res); break;
            case 'map': getMap(req, res); break;
            case 'remote_node_info': getRemoteNodeInfo(req, res); break;
            case 'remote_peers': getRemotePeers(req, res); break;
            case 'ns_get': getAKNSKey(req, res); break;
            case 'ns_get_base': getAKNSKeyFromBase(req, res); break;
            default: notImplemented(req, res);
        }
    }
    else {
        welcomeMessage(req, res);
    }
}

function postRoutes(req, res)
{
    switch(req.url)
    {
        default: notImplemented(req, res);
    }
}

function notImplemented(req, res)
{
    res.writeHead(404, { 'Content-Type': 'application/json'});
    res.end(JSON.stringify({
        url: req.url,
        error: 'not implemented'
    }));
}

function processMethod(req, res)
{
    switch(req.method)
    {
        case 'GET': getRoutes(req, res); break;
        case 'POST': postRoutes(req, res); break;
        default: notImplemented(req, res);
    }
}

function requestParser(req, res)
{
    printRequest(req);
    akLogMessage('INFO', `Incoming from [${req.connection.remoteAddress}]:${req.socket._peername.port} @ ${req.headers.host}${req.url}`);
    if (checkIfAllowedIP(req.connection.remoteAddress)){
        res.setHeader('Access-Control-Allow-Origin', '*');
        processMethod(req, res);
    }
    else {
        res.end();
    }
}

const server = http.createServer(serverOptions, requestParser);

server.listen(8610);
