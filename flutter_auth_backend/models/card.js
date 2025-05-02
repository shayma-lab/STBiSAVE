const mongoose = require('mongoose');

const cardSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  soldeBancaire: {
    type: Number,
    default: 0,
    required: true
  },
  numeroCarte: {
    type: String,
    required: true,
    unique: true
  },
  typeCarte: {
    type: String,
    enum: ['Visa', 'MasterCard', 'Autre'],
    required: true
  },
  dateExpiration: {
    type: String,
    required: true
  },
  dateAjout: {
    type: Date,
    default: Date.now
  }
});

const Card = mongoose.model('Card', cardSchema);
module.exports = Card;
