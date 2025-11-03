const express = require('express');
const router = express.Router();

// Importamos las funciones lógicas del controlador de viajes.
const {
  createRide,
  getAvailableRides,
  bookSeat,
  getMyOfferedRides, // Importamos la nueva función para los viajes del conductor.
} = require('../controllers/rideController');

// Importamos el middleware de protección para asegurar que solo usuarios logueados puedan acceder.
const { protect } = require('../middleware/authMiddleware');

// --- Aplicación de Middleware ---
// Usamos `router.use(protect)` para aplicar el middleware 'protect' a TODAS las rutas
// definidas en este archivo. Esto significa que ninguna de estas acciones se puede
// realizar sin un token de autenticación válido.
router.use(protect);

// --- Definición de las Rutas de Viajes ---

// Agrupa las rutas que apuntan a la raíz '/api/rides'
router.route('/')
  // Cuando se hace una petición GET a '/api/rides', se ejecuta la función getAvailableRides.
  .get(getAvailableRides)
  // Cuando se hace una petición POST a '/api/rides', se ejecuta la función createRide.
  .post(createRide);

// Define la ruta para que un conductor obtenga la lista de sus propios viajes ofrecidos.
router.route('/my-rides')
  // Cuando se hace una petición GET a '/api/rides/my-rides', se ejecuta getMyOfferedRides.
  .get(getMyOfferedRides);

// Define la ruta para que un pasajero reserve un cupo en un viaje específico.
// ':id' es un parámetro dinámico que contendrá el ID del viaje.
router.route('/:id/book')
  // Cuando se hace una petición POST a '/api/rides/un-id-de-viaje/book', se ejecuta bookSeat.
  .post(bookSeat);


// router.route('/:id/cancel').post(cancelBooking); // Para cancelar una reserva.

module.exports = router;

