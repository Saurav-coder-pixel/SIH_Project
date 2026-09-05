const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth.routes');
const profileRoutes = require('./routes/profile.routes');
const locationRoutes = require('./routes/location.routes');
const needRoutes = require('./routes/need.routes');
const connectionRoutes = require('./routes/connection.routes');
const messageRoutes = require('./routes/message.routes');
const adminRoutes = require('./routes/admin.routes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health Check
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', app: 'Nook Hyperlocal API', timestamp: new Date() });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api', profileRoutes);
app.use('/api/location', locationRoutes);
app.use('/api', needRoutes);
app.use('/api', connectionRoutes);
app.use('/api', messageRoutes);
app.use('/api', adminRoutes);

// Global 404 Handler
app.use((req, res) => {
  res.status(404).json({ success: false, error: 'Endpoint not found' });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('[Unhandled Error]', err);
  res.status(500).json({ success: false, error: err.message || 'Internal Server Error' });
});

module.exports = app;
