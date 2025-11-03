const express = require('express');
const router = express.Router();

// 1. Importamos la ÚNICA función que necesitamos desde el controlador de reservas.
const { getMyBookings } = require('../controllers/bookingController');

// 2. Importamos el middleware de protección para asegurar que el usuario esté logueado.
const { protect } = require('../middleware/authMiddleware');

// --- Aplicación de Middleware ---
// Aplicamos el middleware 'protect' a TODAS las rutas de este archivo.
// Nadie puede acceder a las rutas de reserva sin un token válido.
router.use(protect);

// --- Definición de la Ruta de Reservas ---

// Define la ruta para que un pasajero obtenga la lista de sus propias reservas.
router.route('/my-bookings')
  // Cuando se hace una petición GET a '/api/bookings/my-bookings', se ejecuta la función getMyBookings.
  .get(getMyBookings);

// NOTA: No hay rutas POST en este archivo. La lógica para CREAR una reserva
// está en 'rideRoutes.js' porque es una acción que se realiza SOBRE un viaje.

module.exports = router;

