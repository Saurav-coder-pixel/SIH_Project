const express = require('express');
const router = express.Router();
const profileController = require('../controllers/profile.controller');
const { protect } = require('../middleware/auth.middleware');

router.get('/users/me', protect, profileController.getMyProfile);
router.patch('/profiles/me', protect, profileController.updateMyProfile);
router.get('/profiles/:id', protect, profileController.getPublicProfile);

module.exports = router;
