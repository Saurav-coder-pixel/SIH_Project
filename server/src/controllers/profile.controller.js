const User = require('../models/User');
const { toPublicProfileDTO } = require('../utils/privacyDto');

/**
 * @route   GET /api/users/me
 * @desc    Get current user's full profile
 */
exports.getMyProfile = async (req, res) => {
  try {
    return res.status(200).json({
      success: true,
      user: req.user
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   PATCH /api/profiles/me
 * @desc    Update current user's profile details (skills, services, role, location, etc.)
 */
exports.updateMyProfile = async (req, res) => {
  try {
    const allowedFields = [
      'name',
      'role',
      'bio',
      'profession',
      'skills',
      'services',
      'interests',
      'experience',
      'availability',
      'locality_name',
      'location_visibility',
      'search_radius_km'
    ];

    const updates = {};
    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    }

    // Handle exact location coordinate updates
    if (req.body.coordinates && Array.isArray(req.body.coordinates) && req.body.coordinates.length === 2) {
      updates.location = {
        type: 'Point',
        coordinates: req.body.coordinates
      };
    }

    const updatedUser = await User.findByIdAndUpdate(
      req.user._id,
      { $set: updates },
      { new: true, runValidators: true }
    );

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      user: updatedUser
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/profiles/:id
 * @desc    Get privacy-safe public profile of a user by ID
 *          NEVER exposes exact home coordinates or unconsented phone number.
 */
exports.getPublicProfile = async (req, res) => {
  try {
    const targetUser = await User.findById(req.params.id);
    if (!targetUser) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }

    let requesterCoords = null;
    if (req.user && req.user.location && req.user.location.coordinates) {
      requesterCoords = req.user.location.coordinates;
    }

    // Convert to privacy-safe public profile DTO
    const publicProfile = toPublicProfileDTO(targetUser, {
      requesterCoords,
      isConnectedWithConsent: false // Gated consent
    });

    return res.status(200).json({
      success: true,
      profile: publicProfile
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
