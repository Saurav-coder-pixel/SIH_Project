const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message.controller');
const { protect } = require('../middleware/auth.middleware');

router.post('/conversations/messages', protect, messageController.sendMessage);
router.get('/conversations/:connectionId/messages', protect, messageController.getMessages);

module.exports = router;
