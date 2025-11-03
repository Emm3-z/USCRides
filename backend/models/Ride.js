const mongoose = require('mongoose');

const pointSchema = new mongoose.Schema({
  name: { type: String, required: true },
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
});

const rideSchema = new mongoose.Schema({
  driver: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: 'User', 
  },
  origin: {
    type: pointSchema,
    required: true,
  },
  destination: {
    type: pointSchema,
    required: true,
  },
  departureTime: {
    type: Date,
    required: true,
  },
  availableSeats: {
    type: Number,
    required: true,
    min: 0,
  },
  totalSeats: {
    type: Number,
    required: true,
  },
  costPerSeat: {
    type: Number,
    required: true,
  },
  passengers: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  }],
  status: {
    type: String,
    enum: ['disponible', 'lleno', 'en_curso', 'completado', 'cancelado'],
    default: 'disponible',
  }
}, {
  timestamps: true
});

const Ride = mongoose.model('Ride', rideSchema);
module.exports = Ride;

