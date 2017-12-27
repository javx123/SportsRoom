const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database. 
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

var gameRef;



    exports.notifyCancelledGame = functions.database.ref('/games/{pushId}').onDelete(event => {
    var result = event.data.previous.val()
    console.log("game deleted", event.params.pushId, result);
    var resultGameTitle = result.gameID
    console.log(resultGameTitle)
    var topic = "/topics/" + resultGameTitle

	var payload = {
  notification: {
    title: "Your game has been cancelled",
    body: `${result.title} has been cancelled by the organizer`
  }
}
  admin.messaging().sendToTopic(topic, payload)
  .then(function(response) {
    console.log("Successfully sent message:", response);
  })
  .catch(function(error) {
    console.log("Error sending message:", error);
  });
});

    exports.getMessage = functions.database.ref('/games/{pushId}/chatroom/{newEvent}').onWrite(event => {
    result = event.data.val()
    console.log(result)
    console.log(result.messageBody)
  });
