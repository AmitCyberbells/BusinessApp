const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Create Express app
const app = express();

// Middleware
app.use(cors({
    origin: 'http://192.168.1.100:5001', // Replace with your Flutter app's origin
  }));
   // Enable CORS
app.use(express.json()); // Parse JSON bodies

// Routes
app.use('/api/business-types', require('./routes/businessTypeRoutes'));

// Export the app
module.exports = app;