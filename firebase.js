const admin = require('firebase-admin');

// Initialize Firebase Admin
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Function to create an anonymous user
const createAnonymousUser = async () => {
  try {
    const userRecord = await admin.auth().createUser({
      anonymous: true
    });
    return userRecord;
  } catch (error) {
    console.error('Error creating anonymous user:', error);
    throw error;
  }
};

// Function to verify Firebase ID token
const verifyIdToken = async (idToken) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    console.error('Error verifying ID token:', error);
    throw error;
  }
};

module.exports = {
  admin,
  createAnonymousUser,
  verifyIdToken
};
