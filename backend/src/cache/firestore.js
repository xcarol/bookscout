const admin = require('firebase-admin');

// Initialize a default dummy app for now
admin.initializeApp({
  // TODO: Add credentials here later (e.g. credential: admin.credential.cert(serviceAccount))
});

const db = admin.firestore();

// Export the db instance so we can wire it up later
module.exports = {
  db,
};
