const express = require('express');
const router = express.Router();
const passengerRequestController = require('../controllers/passengerRequestController');

router.post('/', passengerRequestController.submitPassengerRequest);
router.delete('/:id', passengerRequestController.deletePassengerRequest);
router.get('/:userId', passengerRequestController.getPassengerTaxiRequest);
router.get('/', passengerRequestController.getPassengerRequestList);

module.exports = router; 