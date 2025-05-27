const express = require('express');
const router = express.Router();
const { createAnonymousUser, verifyIdToken } = require('../firebase');

// Route to create an anonymous user
router.post('/anonymous', async (req, res) => {
  try {
    const userRecord = await createAnonymousUser();
    res.status(201).json({
      success: true,
      user: {
        uid: userRecord.uid,
        isAnonymous: true
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Route to verify token
router.post('/verify-token', async (req, res) => {
  try {
    const { idToken } = req.body;
    if (!idToken) {
      return res.status(400).json({
        success: false,
        error: 'ID token is required'
      });
    }

    const decodedToken = await verifyIdToken(idToken);
    res.json({
      success: true,
      user: decodedToken
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      error: error.message
    });
  }
});

module.exports = router; 