const express = require('express');
const router = express.Router();
const locationController = require('../controllers/location.controller');
const { protect } = require('../middleware/auth.middleware');

router.post('/geocode', locationController.geocodeAddress);
router.post('/update', protect, locationController.updateLocation);

module.exports = router;
