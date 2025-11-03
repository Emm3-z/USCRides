const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  userType: {
    type: String,
    enum: ['pasajero', 'conductor'],
    required: true,
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  verificationCode: {
    type: String,
  },
  verificationCodeExpires: {
    type: Date,
  },
  
  driverSetupComplete: {
    type: Boolean,
    default: false,
  },
  vehicle: {
    type: {
      type: String,
      enum: ['auto', 'motocicleta'],
    },
    
  },
  documents: {
    licenseUrl: String,
    universityIdUrl: String,
    soatUrl: String,
    technomechanicsUrl: String,
  },

  profilePictureUrl: {
    type: String,
    default: '',
  },
  rating: {
    type: Number,
    default: 5.0,
  }
}, {
  timestamps: true
});

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

const User = mongoose.model('User', userSchema);
module.exports = User;

