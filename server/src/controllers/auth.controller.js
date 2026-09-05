const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User');

const generateToken = (id) => {
  return jwt.sign({ id }, env.JWT_SECRET, {
    expiresIn: env.JWT_EXPIRES_IN
  });
};

// In-memory OTP storage for mock/demo purposes
const otpStore = new Map();

/**
 * @route   POST /api/auth/send-otp
 * @desc    Send OTP to phone number
 */
exports.sendOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) {
      return res.status(400).json({ success: false, error: 'Phone number is required' });
    }

    const cleanPhone = phone.trim();
    // Default demo OTP is 123456
    const otp = '123456';
    otpStore.set(cleanPhone, { otp, expiresAt: Date.now() + 5 * 60 * 1000 });

    return res.status(200).json({
      success: true,
      message: `OTP sent successfully to ${cleanPhone}`,
      demo_otp: otp
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   POST /api/auth/verify-otp
 * @desc    Verify OTP and authenticate user
 */
exports.verifyOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;
    if (!phone || !otp) {
      return res.status(400).json({ success: false, error: 'Phone and OTP are required' });
    }

    const cleanPhone = phone.trim();
    const stored = otpStore.get(cleanPhone);

    // Accept demo OTP '123456' or stored OTP
    if (otp !== '123456' && (!stored || stored.otp !== otp || stored.expiresAt < Date.now())) {
      return res.status(400).json({ success: false, error: 'Invalid or expired OTP' });
    }

    let user = await User.findOne({ phone: cleanPhone });
    let isNewUser = false;

    if (!user) {
      isNewUser = true;
    }

    if (user) {
      const token = generateToken(user._id);
      return res.status(200).json({
        success: true,
        token,
        is_new_user: false,
        user: {
          _id: user._id,
          phone: user.phone,
          name: user.name,
          role: user.role,
          verification: user.verification
        }
      });
    }

    return res.status(200).json({
      success: true,
      is_new_user: true,
      message: 'OTP verified. Please complete registration with name and role.'
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user with role, name, profession, and location
 */
exports.register = async (req, res) => {
  try {
    const {
      phone,
      name,
      role,
      profession,
      skills,
      services,
      locality_name,
      coordinates
    } = req.body;

    if (!phone || !name) {
      return res.status(400).json({ success: false, error: 'Phone and name are required' });
    }

    const cleanPhone = phone.trim();
    let existingUser = await User.findOne({ phone: cleanPhone });
    if (existingUser) {
      return res.status(400).json({ success: false, error: 'User already exists with this phone number' });
    }

    // Role validation: "seeker" | "provider" | "both"
    const validRoles = ['seeker', 'provider', 'both'];
    const userRole = validRoles.includes(role) ? role : 'both';

    const userLocation = {
      type: 'Point',
      coordinates: Array.isArray(coordinates) && coordinates.length === 2 ? coordinates : [77.5946, 12.9716]
    };

    const newUser = await User.create({
      phone: cleanPhone,
      name: name.trim(),
      role: userRole,
      profession: profession || '',
      skills: Array.isArray(skills) ? skills : [],
      services: Array.isArray(services) ? services : [],
      location: userLocation,
      locality_name: locality_name || 'Central Bengaluru',
      verification: {
        tier: 1, // Phone verified -> Tier 1 Basic
        status: 'verified',
        verified_at: new Date()
      }
    });

    const token = generateToken(newUser._id);

    return res.status(201).json({
      success: true,
      token,
      user: {
        _id: newUser._id,
        phone: newUser.phone,
        name: newUser.name,
        role: newUser.role,
        profession: newUser.profession,
        locality_name: newUser.locality_name,
        verification: newUser.verification
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/auth/me
 * @desc    Get authenticated user info
 */
exports.getMe = async (req, res) => {
  try {
    return res.status(200).json({
      success: true,
      user: req.user
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
