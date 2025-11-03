const express = require('express');
const router = express.Router();
const { getOptimizedRoute } = require('../controllers/mapController');
const { protect } = require('../middleware/authMiddleware');

router.post('/optimize-route', protect, getOptimizedRoute);

module.exports = router;
