const User = require('../models/User');

/**
 * @desc    Actualizar el perfil de configuración del conductor
 * @route   PUT /api/users/driver-setup
 * @access  Private (requiere token de conductor)
 */
const setupDriverProfile = async (req, res) => {

  const user = await User.findById(req.user.id);

  if (user && user.userType === 'conductor') {
    const { vehicleType, documents } = req.body;

    
    user.vehicle.type = vehicleType || user.vehicle.type;

    user.documents = documents || user.documents;
    

    user.driverSetupComplete = true;

    const updatedUser = await user.save();

    res.json({
      message: 'Perfil de conductor actualizado con éxito.',
      user: {
        _id: updatedUser._id,
        name: updatedUser.name,
        email: updatedUser.email,
        userType: updatedUser.userType,
        driverSetupComplete: updatedUser.driverSetupComplete,
      }
    });

  } else {
    res.status(404).json({ message: 'Usuario no encontrado o no es un conductor' });
  }
};

module.exports = {
  setupDriverProfile,
};
