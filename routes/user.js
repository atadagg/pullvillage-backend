const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { authenticateToken } = require('../middleware/auth');

// User creation doesn't require auth (they're creating their profile after Firebase auth)
router.post('/', userController.createUser);

// Protect other user routes if you add them in the future
// router.get('/', authenticateToken, userController.getUsers);
// router.put('/:id', authenticateToken, userController.updateUser);

module.exports = router; 