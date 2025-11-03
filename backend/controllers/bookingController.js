const Booking = require('../models/Booking');

/**
 * @desc    Obtener todas las reservas hechas por el pasajero logueado
 * @route   GET /api/bookings/my-bookings
 * @access  Private
 */
const getMyBookings = async (req, res) => {
  try {
    const bookings = await Booking.find({ passenger: req.user._id })
      .populate({
        path: 'ride',
        populate: {
          path: 'driver',
          select: 'name', 
        }
      })
      .sort({ createdAt: -1 }); 

    res.json(bookings);
  } catch (error) {
    console.error('Error fetching my bookings:', error);
    res.status(500).json({ message: 'Error al obtener tus reservas' });
  }
};


module.exports = {
  getMyBookings,
};

