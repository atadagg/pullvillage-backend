const express = require('express');
const router = express.Router();
const driverRequestController = require('../controllers/driverRequestController');
const { authenticateToken } = require('../middleware/auth');

// Protect all routes with authentication middleware
router.use(authenticateToken);

router.post('/', driverRequestController.submitDriverRequest);
router.delete('/:id', driverRequestController.deleteDriverRequest);
router.get('/', driverRequestController.getDriverRequestList);

module.exports = router; 