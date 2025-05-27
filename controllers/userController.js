const User = require('../models/user');
const { verifyIdToken } = require('../firebase');

exports.createUser = async (req, res) => {
  try {
    const { name, surname, phoneNumber, idToken } = req.body;
    
    if (!name || !surname || !phoneNumber || !idToken) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Verify the Firebase token
    const decodedToken = await verifyIdToken(idToken);
    const firebaseUid = decodedToken.uid;

    // Check if user already exists
    const existingUser = await User.findOne({ where: { firebaseUid } });
    if (existingUser) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Create new user
    const user = await User.create({ 
      name, 
      surname, 
      phoneNumber,
      firebaseUid 
    });
    
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 