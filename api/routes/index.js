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
const getAkid = require('./getAkid');
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
router.route(settings.URL_PREFIX+'/sblock').get(getSBlock);
// Outputs node's local chain
router.route(settings.URL_PREFIX+'/zchain').get(getZChain);
// Returns latest zblock from node's local chain
router.route(settings.URL_PREFIX+'/zlatest').get(getZLatest);
// Returns local node's akid
router.route(settings.URL_PREFIX+'/akid').get(getAkid);
// Returns content
router.route(settings.URL_PREFIX+'/content').get(getInnerIPFSContent);
// Returns zblock
router.route(settings.URL_PREFIX+'/zblock').get(getZblock);
// Send a block to the node (zchain block)
router.route(settings.URL_PREFIX+'/sblk').post(receiveZBlock);
// Send a zchain link to the node (refering to a valid zchain out there)
router.route(settings.URL_PREFIX+'/szch').post(receiveZChain);

router.route('/*').get((req,res)=>{console.log(req.url);res.send({errno:"404"})});
module.exports = router;
