const express = require('express');
const router = express.Router();
const driverRequestController = require('../controllers/driverRequestController');

router.post('/', driverRequestController.submitDriverRequest);
router.delete('/:id', driverRequestController.deleteDriverRequest);
router.get('/', driverRequestController.getDriverRequestList);

module.exports = router; 