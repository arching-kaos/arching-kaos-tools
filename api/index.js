const http = require("node:http");

const welcomeMessage = require("./routes/default/index.js");
const getNodeInfo = require('./routes/getNodeInfo/index.js');
const getPeers = require('./routes/getPeers/index.js');
const getZblock = require('./routes/getZblock/index.js');
const getZlatest = require('./routes/getZLatest/index.js');
const getSblock = require('./routes/getSBlock/index.js');
const getSlatest = require('./routes/getSLatest/index.js');

const akLogMessage = require('./lib/akLogMessage');

const serverOptions = { keepAliveTimeout: 60000 };

function printRequest(req)
{
    console.log(req.connection.remoteAddress);
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
            case 'zblock': getZblock(req, res); break;
            case 'zlatest': getZlatest(req, res); break;
            case 'sblock': getSblock(req, res); break;
            case 'slatest': getSlatest(req, res); break;
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

function checkIfAllowedIP(address)
{
    return address.startsWith('fc') ? true : false;
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
