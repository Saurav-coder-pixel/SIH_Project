const express = require('express');
const router = express.Router();
const needController = require('../controllers/need.controller');
const { protect } = require('../middleware/auth.middleware');

router.post('/needs', protect, needController.createNeed);
router.get('/needs/me', protect, needController.getMyNeeds);
router.get('/needs/:id/matches', protect, needController.getNeedMatches);
router.post('/matches/:id/feedback', protect, needController.recordMatchFeedback);

module.exports = router;
