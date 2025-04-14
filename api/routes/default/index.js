const rsettings = require('../../settings');
const settings = rsettings();

function welcome(req, res)
{
    res.writeHead(404, { 'Content-Type': 'application/json'});
    res.end(JSON.stringify({
        message:"Hello! Welcome to Arching Kaos API! See available routes below!",
        version:"0.0.0",

        routes:{
            GET:[
                {welcome:settings.DEF_PROTO+req.headers.host+"/"},
                {peers:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/peers"},
                {node_info:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/node_info"},
                {ipfs_hash:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/ipfs_hash/<hash>"},
                {zlatest:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/zlatest"},
                {sblock:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/sblock/<hash>"},
                {slatest:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/slatest"},
                {chunk:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/chunk/<hash>"},
                {leaf:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/leaf/<hash>"},
                {map:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/map/<hash>"},
            ],
            oldGET:[
                {gathered_zblocks:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/see"},
                {node_local_chain:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/chain"},
                {node_local_peers:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/peers"},
                {node_local_info:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/node_info"},
                {node_local_zlatest:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/zlatest"},
                {latest_known_mined_block:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/slatest"},
                {show_mined_block:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/sblock"},
                {getMerkleTree:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/mrk/:mkr"},
            ],
            oldPOST:[
                {send_me_a_zblock:settings.DEF_PROTO+req.headers.host+settings.URL_PREFIX+"/announce/zblock"},
            ]
        }
    }));
}
module.exports = welcome;
