const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Transaction = require('../models/transaction');
const Card = require('../models/card');
const authMiddleware = require('../middleware/auth');//n middleware JWT

// @route    GET /me
// @desc     Get current user data (name, solde from card, transactions)
// @access   Private
router.get('/me', authMiddleware, async (req, res) => {
  try {
    const userId = req.user.id;

    // Récupérer l'utilisateur (juste son nom)
    const user = await User.findById(userId).select('name');
    if (!user) {
      return res.status(404).json({ msg: 'Utilisateur non trouvé' });
    }

    // Récupérer la carte bancaire associée à l'utilisateur
    const card = await Card.findOne({ userId });
    if (!card) {
      return res.status(404).json({ msg: 'Carte non trouvée' });
    }

    // Récupérer les transactions associées à l'utilisateur
    const transactions = await Transaction.find({ userId }).sort({ date: -1 });

    // Réponse complète
    res.json({
      name: user.name,
      solde: card.soldeBancaire,
      transactions: transactions
    });
  } catch (err) {
    console.error('Erreur serveur:', err.message);
    res.status(500).send('Erreur serveur');
  }
});

module.exports = router;

