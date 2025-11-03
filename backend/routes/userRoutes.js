const express = require('express');
const router = express.Router();
const { setupDriverProfile } = require('../controllers/userController');
const { protect } = require('../middleware/authMiddleware');

// Definimos la ruta y la protegemos con nuestro middleware de autenticación.
router.route('/driver-setup').put(protect, setupDriverProfile);

module.exports = router;
