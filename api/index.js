#!/usr/bin/env node
/*
 * Quick API
 * Author: Kaotisk Hund <kaotisk@arching-kaos.com>
 * Description: Provides a quick API implementation.
 * License: MIT
 */

/*
 * Loading configuration
 *
 */
const config = require('./config');

/*
 * PORT we run the service on.
 *
 * Default: 8610
 *
 */
const DEFAULT_PORT = 8610;
const PORT = config.port || DEFAULT_PORT;

/*
 * Split the prefix of each API call in segments for better management
 *
 * To add a new route, use URL_PREFIX and start your route with '/'
 *
 * LOCAL_IP and DEF_PROTO as well as PORT and URL_PREFIX are used to generate
 * visitable links.
 *
 */
const API_VERSION = "v0";
const URL_PREFIX = "/"+API_VERSION;
const DEF_PROTO="http://";
const LOCAL_IP="127.0.0.1";

/* Requiring packages */
const { spawn } = require('child_process');
const logger = require('morgan');
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');
const multer = require('multer');
const upload = multer();
const session = require('express-session');
// Delete this (maybe)
const cookieParser = require('cookie-parser');

// We start our server ... 
const app = express();

// Set logger format output
app.use(logger('combined'));

// Port number to listen to
const server = app.listen(PORT);

// Use CORS
app.use(cors());

// Whitelist of IPs
// var iplist = fs.readFileSync(config.ipList)

// Parsers
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));

// for parsing multipart/form-data
app.use(upload.array()); 

// Cookie!
app.use(cookieParser());

app.use(session({
    secret: config.session.secret,
    resave: false,
    saveUninitialized: true
}));

// Function for adding stuff...
function genericaddtest(req,res){
    console.table(req.body)
    var myobj = req.body;
    res.send(myobj);
}
// POST data
app.post('/test', cors(corsOptions), genericaddtest);

const routes = require('./routes');

//Routes.provideTheAppHere(app);
app.use('/', routes);





/*
 * After NS validation went through we examine the return code
 * of the application that run the test.
 *
 * Returns:
 *     - error on failure
 *     - on success we process with addNSEntriesToFile()
 *
 */
function continuethingsNS(validitycode,sh,res,gotit){
    if (validitycode === 0){
        var entry = {
            zchain: sh,
            latest: JSON.parse(gotit).Path.replace('/ipfs/','')
        };
        addNSEntriesToFile(entry,res);
    } else {
        res.send({error:"Invalid data"});
    }
}

/*
 * After validation went through we examine the return code
 * of the application that run the test.
 *
 * Returns :
 *     - error on failure
 *     - on success we process with addEntriesToFile()
 *
 */
function continuethings(exitcode,sh,res){
    if (exitcode === 0){
        var entry = {zblock:sh};
        addEntriesToFile(entry,res);
    } else {
        res.send({error:"Invalid data"});
    }
}



/*
 * Adds a latest resolved IPFS path for a given IPNS link
 * to a file.
 *
 * Returns:
 *     - error if error
 *     - success:
 *         - adds the entry to the file
 *         - returns the whole file to the client
 *
 */
function addNSEntriesToFile(entry,res){
    var data = JSON.parse(fs.readFileSync(config.pairsFile));
    var duplicate_entry = 0;
    data.forEach(a=>{
        if ( a.zchain === entry.zchain && a.latest=== entry.latest ){
            duplicate_entry = 1;
            res.send({error:"already there"});
        }
    });

    if ( duplicate_entry === 0 ) {
        // Store it as the first array element of our new list
        var all = [entry];

        // Append the previous entries
        for (var i = 0; i < data.length; i++){
            all[i+1] = data[i];
        }

        // Turn additional back into text
        var json = JSON.stringify(all);

        // Write out the file
        fs.writeFile(config.pairsFile, json, 'utf8', finished);

        // Callback for when file is finished
        function finished(err) {
            console.log('finished writing file');
        }
        res.send(json);
    }
}

/*
 * Adds a latest given zblock to a file.
 *
 * Returns:
 *     - error if error
 *     - success:
 *         - adds the entry to the file
 *         - returns the whole file to the client
 *
 */
function addEntriesToFile(entry,res){
    var data = JSON.parse(fs.readFileSync(config.blocksFile));

    var duplicate_entry = 0;
    data.forEach(a=>{
        if ( a.zblock === entry.zblock ){
            duplicate_entry = 1;
            res.send({error:"already there"});
        }
    });

    if ( duplicate_entry === 0 ) {
        var all = [entry];
        for (var i = 0; i < data.length; i++){
            all[i+1] = data[i];
        }
        var json = JSON.stringify(all);
        fs.writeFile(config.blocksFile, json, 'utf8', finished);
        function finished(err) {
            console.log('finished writing file');
        }
        res.send(json);
    }
}


app.use(cors);
var corsOptions = {
    origin: '*',
    optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
}
