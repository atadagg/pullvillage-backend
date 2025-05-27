const express = require('express');
const router = express.Router();
const passengerRequestController = require('../controllers/passengerRequestController');
const { authenticateToken } = require('../middleware/auth');

// Protect all routes with authentication middleware
router.use(authenticateToken);

router.post('/', passengerRequestController.submitPassengerRequest);
router.delete('/:id', passengerRequestController.deletePassengerRequest);
router.get('/:firebaseUid', passengerRequestController.getPassengerTaxiRequest);
router.get('/', passengerRequestController.getPassengerRequestList);

module.exports = router; 