const express = require('express');
const router = express.Router();
const { getBusinessTypes } = require('../controllers/businessTypeController');

// GET /api/business-types
router.get('/', getBusinessTypes);

module.exports = router;