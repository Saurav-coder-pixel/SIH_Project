const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const { protect } = require('../middleware/auth.middleware');

router.post('/reports', protect, adminController.createReport);
router.get('/admin/analytics/funnel', protect, adminController.getAnalyticsFunnel);

module.exports = router;
