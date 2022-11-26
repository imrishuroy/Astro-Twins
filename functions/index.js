const functions = require("firebase-functions");
const admin = require("firebase-admin");
// const { initializeApp } = require('firebase-admin/app');
const {RtcTokenBuilder, RtcRole} = require("agora-access-token");
const APP_ID = "f888802a9eb54b4cbf5f477c0342bc07";
const APP_CERTIFICATE = "efc2a723e2c2467193738793af60d54f";
admin.initializeApp();


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

// trigger FCM notification

exports.sendCallNotification = functions.https.onCall(async (data, context) => {

    const receiverId = data.receiverId;
    const callerName = data.callerName;
    const callerPhoto = data.callerPhoto;

    const receiverDoc = await admin.firestore().collection('users').doc(receiverId).get();

    //return receiverDoc.get('userId');

    // const payload = {'sessionId': sessionId, 'name': name, 'callerId': callerId, 'callerName': callerName, 'callerPhoto': callerPhoto};
    const payload = {'callerName': callerName, 'callerPhoto': callerPhoto,};

    await admin.messaging().sendToDevice(
        receiverDoc.get('tokens'),
        {
            notification: {
              title: 'Incoming Call',
              body: `${callerName} is calling you`,
            },

            data: payload,
          },
          {
            // Required for background/quit data-only messages on iOS
            contentAvailable: true,
            // Required for background/quit data-only messages on Android
            priority: "high",
          }
       );
});

// exports.listFruit = functions.https.onCall(() => {
//     return ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"];
//   });
  




// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//     functions.logger.info("Hello logs!", {structuredData: true});
//     response.send("Hello from Firebase!");
//   });