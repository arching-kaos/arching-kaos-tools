const settings = require('../settings');
const {Router} = require('express');
const cors = require('cors');
const hi = require('./default');
const seeNSEntriesFile = require('./showNSEntriesFile');
const seeEntriesFile = require('./showEntriesFile');
const getSLatest = require('./getSLatest');
const getZLatest = require('./getZLatest');
const getSBlock = require('./getSBlock');
const getZChain = require('./getZChain');
const receiveZBlock = require('./receiveZBlock');
const receiveZChain = require('./receiveZChain');
const getZblock = require('./getZblock');
const getMrk = require('./getMrk');
const getTr = require('./getTr');
const getNodeInfo = require('./getNodeInfo');
const getPeers = require('./getPeers');
const getInnerIPFSContent = require('./getInnerIPFSContent');
const corsOptions = {
    origin: '*',
    optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
};
const router = new Router();
// Basic route, welcomes and provides the available routes to the visitor
router.route('/').get(hi);

/*
 * Replies with contents of files
 *
 */
// Gathered zchain zlatest pairs
router.route(settings.URL_PREFIX+'/seens').get(seeNSEntriesFile);
// Gathered zblocks
router.route(settings.URL_PREFIX+'/see').get(seeEntriesFile);
// Latest known mined block
router.route(settings.URL_PREFIX+'/slatest').get(getSLatest);
// Shows a mined block (provided that /sblock?sblock=SHA512 hash)
router.route(settings.URL_PREFIX+'/sblock/:sblock').get(getSBlock);
// Outputs node's local chain
router.route(settings.URL_PREFIX+'/zchain').get(getZChain);
// Returns latest zblock from node's local chain
router.route(settings.URL_PREFIX+'/zlatest').get(getZLatest);
// Returns local node's info
router.route(settings.URL_PREFIX+'/node_info').get(getNodeInfo);
// Returns local node's peers
router.route(settings.URL_PREFIX+'/peers').get(getPeers);
// Returns content
router.route(settings.URL_PREFIX+'/content').get(getInnerIPFSContent);
// Returns zblock
router.route(settings.URL_PREFIX+'/zblock/:zblock').get(getZblock);
// Returns a mrk
router.route(settings.URL_PREFIX+'/mrk/:mrk').get(getMrk);
// Returns a tr
router.route(settings.URL_PREFIX+'/tr/:tr').get(getTr);
// Send a block to the node (zchain block)
router.route(settings.URL_PREFIX+'/sblk').post(receiveZBlock);
// Send a zchain link to the node (refering to a valid zchain out there)
router.route(settings.URL_PREFIX+'/szch').post(receiveZChain);

router.route('/*').get((req,res)=>{console.log(req.url);res.send({error:"404"})});
router.route('/*').post((req,res)=>{console.log(req.url);res.send({error:"404"})});
router.route('/*').put((req,res)=>{console.log(req.url);res.send({error:"404"})});
router.route('/*').delete((req,res)=>{console.log(req.url);res.send({error:"404"})});
router.route('/*').patch((req,res)=>{console.log(req.url);res.send({error:"404"})});
module.exports = router;
