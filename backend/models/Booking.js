const mongoose = require('mongoose');


const bookingSchema = new mongoose.Schema({
  
  passenger: {
    type: mongoose.Schema.Types.ObjectId, 
    required: true,
    ref: 'User', 
  },
  
  ride: {
    type: mongoose.Schema.Types.ObjectId, 
    required: true,
    ref: 'Ride', 
  },
  
  seatsBooked: {
    type: Number,
    required: true,
    default: 1, 
  },
  
  status: {
    type: String,
    enum: ['confirmado', 'cancelado_pasajero', 'cancelado_conductor', 'completado'],
    default: 'confirmado', 
  }
}, {
  timestamps: true
});

const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking;

