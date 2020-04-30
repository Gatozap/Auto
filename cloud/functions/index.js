const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
var db = admin.firestore();
db.settings({ timestampsInSnapshots: true });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.sendNotification = functions.https.onRequest((request, response) => {


    console.log(request.body);
    // Listing all tokens as an array.
    console.log('Push notification event triggered');

    //  Grab the current value of what was written to the Realtime Database.

    // Create a notification
    const payload = {
        notification: {
            title: request.body['title'],
            body: request.body['message'],
            sound: "default",
        },
        data: {
            title: request.body['title'],
            sender: request.body['sender'],
            behaivior: request.body['behaivior'],
            message: request.body['message'],
            topic: request.body['topic'],
            image: request.body['image'],
            data: request.body['data'],
            sended_at: request.body['sended_at'],
        }

    };

    //Create an options object that contains the time to live for the notification and the priority
    const options = {
        priority: "high",
        timeToLive: 60 * 60 * 24
    };

    response.send(request.body);
    return admin.messaging().sendToTopic(request.body['topic'], payload, options);
});
