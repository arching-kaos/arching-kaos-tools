const settings = require('../../settings');
module.exports = (req, res) => {
    res.send({
        message:"Hello! Welcome to Arching Kaos API! See available routes below!",
        routes:{
            GET:[
                {welcome:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+"/"},
                {gathered_zblocks:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/see"},
                {gathered_zchain_zlatest_pairs:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/seens"},
                {node_local_chain:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/chain"},
                {node_local_peers:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/peers"},
                {node_local_akid:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/akid"},
                {node_local_zlatest:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/zlatest"},
                {latest_known_mined_block:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/slatest"},
                {show_mined_block:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/sblock"},
                {getMerkleTree:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/mrk/:mkr"},
                {show_mined_block:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/sblock"}
            ],
            POST:[
                {send_me_a_zchain_link:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/szch"},
                {send_me_a_zblock:settings.DEF_PROTO+"["+settings.LOCAL_IP+"]:"+settings.PORT+settings.URL_PREFIX+"/sblk"},
            ]
        }
    });
}

