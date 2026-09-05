const LocationService = require('../services/location.service');
const User = require('../models/User');

/**
 * @route   POST /api/location/geocode
 * @desc    Geocodes an address query using internal location-service abstraction.
 *          Frontend calls ONLY this endpoint, never Google Maps directly.
 */
exports.geocodeAddress = async (req, res) => {
  try {
    const { address } = req.body;
    if (!address) {
      return res.status(400).json({ success: false, error: 'Address query is required' });
    }

    const result = await LocationService.geocode(address);
    return res.status(200).json({
      success: true,
      locality_name: result.locality_name,
      // For geocoding requests initiated by user, return coordinates for location picker
      coordinates: result.coordinates
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   POST /api/location/update
 * @desc    Updates authenticated user's current location coordinates & locality name
 */
exports.updateLocation = async (req, res) => {
  try {
    const { coordinates, locality_name, search_radius_km } = req.body;

    if (!coordinates || !Array.isArray(coordinates) || coordinates.length !== 2) {
      return res.status(400).json({ success: false, error: 'Valid [lng, lat] coordinates array required' });
    }

    const updateData = {
      location: {
        type: 'Point',
        coordinates
      }
    };

    if (locality_name) {
      updateData.locality_name = locality_name;
    }

    if (search_radius_km && typeof search_radius_km === 'number') {
      updateData.search_radius_km = search_radius_km;
    }

    const updatedUser = await User.findByIdAndUpdate(
      req.user._id,
      { $set: updateData },
      { new: true }
    );

    return res.status(200).json({
      success: true,
      message: 'Location updated successfully',
      locality_name: updatedUser.locality_name,
      search_radius_km: updatedUser.search_radius_km
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
