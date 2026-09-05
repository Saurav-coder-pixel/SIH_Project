const mongoose = require('mongoose');
const env = require('./env');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(env.MONGODB_URI);
    console.log(`[DB] MongoDB Connected: ${conn.connection.host}`);
    return conn;
  } catch (error) {
    console.warn(`[DB] MongoDB connection failed (${error.message}). Running in mock/standalone mode if applicable.`);
  }
};

module.exports = connectDB;
