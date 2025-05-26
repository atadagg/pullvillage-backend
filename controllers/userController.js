const User = require('../models/user');

exports.createUser = async (req, res) => {
  try {
    const { firebaseId, name, surname, phoneNumber } = req.body;
    if (!firebaseId || !name || !surname || !phoneNumber) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const user = await User.create({ firebaseId, name, surname, phoneNumber });
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 