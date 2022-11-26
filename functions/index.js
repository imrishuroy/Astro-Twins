const functions = require("firebase-functions");
const express = require("express");
const {RtcTokenBuilder, RtcRole} = require("agora-access-token");
const APP_ID = "f888802a9eb54b4cbf5f477c0342bc07";
const APP_CERTIFICATE = "efc2a723e2c2467193738793af60d54f";

exports.generateAccessToken = functions.https.onRequest((req, res) => {
    res.header("Access-Control-Allow-Origin", "*");
    const channelName = req.query.channelName;
    if(!channelName) {
        return res.status(500).json({error: "channelName is required"});   
    }
    let uid = req.query.uid;
    if(!uid || uid == '') {
        uid = 0;
    }

    let role = RtcRole.SUBSCRIBER;
    if(req.query.role == "publisher") {
        role = RtcRole.PUBLISHER;
    }

    let expireTime = req.query.expireTime;
    if(!expireTime || expireTime == "") {
        expireTime = 3600;
    }else{
        expireTime = parseInt(expireTime, 10);
    }

    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expireTime;

    const token = RtcTokenBuilder.buildTokenWithUid(APP_ID, APP_CERTIFICATE, channelName, uid, role, privilegeExpiredTs);

    res.send({token: token});
    //return res.json({token: token});

});

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//     functions.logger.info("Hello logs!", {structuredData: true});
//     response.send("Hello from Firebase!");
//   });