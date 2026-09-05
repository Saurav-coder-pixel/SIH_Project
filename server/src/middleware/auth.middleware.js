const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, env.JWT_SECRET);
      
      const user = await User.findById(decoded.id).select('-__v');
      if (!user) {
        return res.status(401).json({ success: false, error: 'User no longer exists' });
      }
      if (user.status === 'suspended') {
        return res.status(403).json({ success: false, error: 'User account is suspended' });
      }

      req.user = user;
      return next();
    } catch (error) {
      return res.status(401).json({ success: false, error: 'Not authorized, invalid token' });
    }
  }

  if (!token) {
    return res.status(401).json({ success: false, error: 'Not authorized, no token provided' });
  }
};

module.exports = { protect };
