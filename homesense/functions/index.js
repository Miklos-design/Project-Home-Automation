const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize the Firebase Admin SDK
admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  try {
    // Message payload
    const message = {
      notification: {
        title: 'Your water is boiled',
        body: 'The kettle has finished boiling your water.',
      },
      topic: 'kettle_notifications', // Topic to send the message to
    };

    // Send a message to devices subscribed to the provided topic.
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    res.status(200).send('Notification sent successfully');
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).send('Internal Server Error: ' + error.message);
  }
});
