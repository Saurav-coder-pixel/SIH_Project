const express = require('express');
const router = express.Router();
const connectionController = require('../controllers/connection.controller');
const { protect } = require('../middleware/auth.middleware');

router.post('/connections/requests', protect, connectionController.createRequest);
router.get('/connections/requests', protect, connectionController.getRequests);
router.patch('/connections/requests/:id', protect, connectionController.respondToRequest);
router.get('/connections', protect, connectionController.getConnections);

module.exports = router;
