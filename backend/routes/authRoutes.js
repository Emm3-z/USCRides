const express = require('express');
const router = express.Router();

// Importamos las funciones necesarias del controlador, incluyendo la nueva 'verifyUser'
const {
  registerUser,
  verifyUser,
  loginUser,
  getUserProfile,
} = require('../controllers/authController');

// Importamos el middleware para proteger rutas
const { protect } = require('../middleware/authMiddleware');

// --- Definición de las Rutas de Autenticación ---

// Ruta para registrar un nuevo usuario
router.post('/register', registerUser);

// NUEVA RUTA para verificar la cuenta con el código
router.post('/verify', verifyUser);

// Ruta para iniciar sesión
router.post('/login', loginUser);

// Ruta protegida para obtener el perfil del usuario.
// El middleware 'protect' se ejecuta primero para asegurar que el usuario esté logueado.
router.get('/profile', protect, getUserProfile);

module.exports = router;

