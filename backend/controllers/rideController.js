const Ride = require('../models/Ride');
const Booking = require('../models/Booking');
const mongoose = require('mongoose');

/**
 * @desc    Crear un nuevo viaje (el conductor ofrece una ruta)
 * @route   POST /api/rides
 * @access  Private (requiere token)
 */
const createRide = async (req, res) => {
  
  const { origin, destination, departureTime, totalSeats, costPerSeat } = req.body;

  
  if (!origin || !destination || !departureTime || !totalSeats || !costPerSeat) {
    return res.status(400).json({ message: 'Por favor, complete todos los campos' });
  }

  try {
    
    const ride = new Ride({
      driver: req.user._id, 
      origin,
      destination,
      departureTime,
      totalSeats,
      availableSeats: totalSeats, 
      costPerSeat,
    });

    const createdRide = await ride.save();
    console.log('✅ Viaje creado con éxito en la BD:', createdRide._id);
    res.status(201).json(createdRide);
  } catch (error) {
    console.error('Error creating ride:', error);
    res.status(500).json({ message: 'Error al crear el viaje' });
  }
};

const getAvailableRides = async (req, res) => {
  try {
    const rides = await Ride.find({ 
      status: 'disponible', 
      departureTime: { $gt: new Date() } 
    }).populate('driver', 'name rating carDetails'); 
    
    console.log(`✅ Buscando viajes disponibles para pasajeros. Encontrados: ${rides.length}`);
    res.json(rides);
  } catch (error) {
    console.error('Error fetching available rides:', error);
    res.status(500).json({ message: 'Error al obtener los viajes' });
  }
};

const bookSeat = async (req, res) => {
  
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const ride = await Ride.findById(req.params.id).session(session);

    if (!ride) {
      await session.abortTransaction();
      return res.status(404).json({ message: 'Viaje no encontrado' });
    }
    
    
    if (ride.driver.equals(req.user._id)) {
      await session.abortTransaction();
      return res.status(400).json({ message: 'No puedes reservar en tu propio viaje' });
    }
    if (ride.passengers.includes(req.user._id)) {
      await session.abortTransaction();
      return res.status(400).json({ message: 'Ya tienes una reserva en este viaje' });
    }
    if (ride.availableSeats < 1) {
      await session.abortTransaction();
      return res.status(400).json({ message: 'No hay cupos disponibles' });
    }

   
    ride.availableSeats -= 1;
    ride.passengers.push(req.user._id);
    if (ride.availableSeats === 0) {
      ride.status = 'lleno';
    }
    await ride.save({ session });

    const booking = new Booking({
      passenger: req.user._id,
      ride: ride._id,
      seatsBooked: 1, 
    });
    await booking.save({ session });
    
    
    console.log(`📢 NOTIFICACIÓN: El usuario ${req.user.name} ha reservado en el viaje a ${ride.destination.name}`);

   
    await session.commitTransaction();
    res.status(200).json({ message: 'Reserva realizada con éxito' });

  } catch (error) {
    
    await session.abortTransaction();
    console.error('Error booking seat:', error);
    res.status(500).json({ message: 'Error al procesar la reserva' });
  } finally {
    
    session.endSession();
  }
};

const getMyOfferedRides = async (req, res) => {
  try {
    const rides = await Ride.find({ driver: req.user._id })
      .populate('driver', 'name') 
      .populate('passengers', 'name') 
      .sort({ departureTime: 1 }); 

    console.log(`✅ Buscando viajes para el conductor ${req.user.name}. Encontrados: ${rides.length}`);
    res.json(rides);
  } catch (error) {
    console.error('Error fetching my offered rides:', error);
    res.status(500).json({ message: 'Error al obtener tus viajes' });
  }
};

module.exports = { 
  createRide, 
  getAvailableRides, 
  bookSeat,
  getMyOfferedRides,
};

