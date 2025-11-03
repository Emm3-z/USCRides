const User = require('../models/User');
const jwt = require('jsonwebtoken');

/**
 * Genera un JSON Web Token (JWT) para un ID de usuario dado.
 * @param {string} id - El ID del usuario.
 * @returns {string} El token JWT generado.
 */
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
};

/**
 * @desc    Registrar un nuevo usuario, generar y "enviar" un código de verificación.
 * @route   POST /api/auth/register
 * @access  Public
 */
const registerUser = async (req, res) => {
  const { name, email, password, userType } = req.body;

  try {
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'El usuario ya existe' });
    }

    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const verificationCodeExpires = new Date(Date.now() + 15 * 60 * 1000); // 15 minutos de expiración

    const user = await User.create({
      name,
      email,
      password,
      userType,
      verificationCode,
      verificationCodeExpires,
    });

    if (user) {
      // Simulación de Envío de Correo: El código se muestra en la consola del backend.
      console.log('------------------------------------');
      console.log(`📧 CÓDIGO DE VERIFICACIÓN PARA ${email}: ${verificationCode}`);
      console.log('------------------------------------');

      res.status(201).json({
        message: 'Usuario registrado. Por favor, revisa tu correo para el código de verificación.',
        email: user.email,
      });
    } else {
      res.status(400).json({ message: 'Datos de usuario inválidos' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

/**
 * @desc    Verificar un usuario con el código de 6 dígitos.
 * @route   POST /api/auth/verify
 * @access  Public
 */
const verifyUser = async (req, res) => {
  const { email, verificationCode } = req.body;
  try {
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });
    if (user.isVerified) return res.status(400).json({ message: 'El usuario ya está verificado' });
    if (user.verificationCode !== verificationCode) return res.status(400).json({ message: 'Código de verificación inválido' });
    if (user.verificationCodeExpires < new Date()) return res.status(400).json({ message: 'El código de verificación ha expirado' });

    user.isVerified = true;
    user.verificationCode = undefined;
    user.verificationCodeExpires = undefined;
    await user.save();

    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      userType: user.userType, // Devuelve el rol del usuario
      token: generateToken(user._id),
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

/**
 * @desc    Autenticar (iniciar sesión) un usuario existente.
 * @route   POST /api/auth/login
 * @access  Public
 */
const loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });

    if (user && !user.isVerified) {
      return res.status(401).json({ message: 'Tu cuenta no ha sido verificada.' });
    }

    if (user && (await user.matchPassword(password))) {
      res.json({
        _id: user._id,
        name: user.name,
        email: user.email,
        userType: user.userType, // Devuelve el rol del usuario
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Email o contraseña inválidos' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

/**
 * @desc    Obtener el perfil del usuario que está logueado.
 * @route   GET /api/auth/profile
 * @access  Private (requiere token)
 */
const getUserProfile = async (req, res) => {
  // El middleware 'protect' ya ha adjuntado el usuario al objeto 'req'
  if (req.user) {
    res.json({
      _id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      userType: req.user.userType,
    });
  } else {
    res.status(404).json({ message: 'Usuario no encontrado' });
  }
};

module.exports = { registerUser, verifyUser, loginUser, getUserProfile };

