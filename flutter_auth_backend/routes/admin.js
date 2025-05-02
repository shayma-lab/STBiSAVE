const express = require("express");
const router = express.Router();
const User = require("../models/User");
const Card = require("../models/card");
const Transaction = require("../models/transaction");

// ✅ GET tous les utilisateurs avec solde
router.get("/users", async (req, res) => {
  try {
    const users = await User.find().select("-password");
    const cards = await Card.find();

    const usersWithSolde = users.map(user => {
      const userCard = cards.find(card => card.userId.toString() === user._id.toString());
      return {
        ...user._doc,
        soldeBancaire: userCard ? userCard.soldeBancaire : 0
      };
    });

    res.status(200).json(usersWithSolde);
  } catch (err) {
    console.error("Erreur lors de la récupération des utilisateurs :", err);
    res.status(500).json({ error: "Erreur serveur lors de la récupération des utilisateurs." });
  }
});

// ✅ GET carte par userId
router.get("/card/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const card = await Card.findOne({ userId });

    if (!card) {
      return res.status(404).json({ message: "Aucune carte trouvée pour cet utilisateur." });
    }

    res.status(200).json(card);
  } catch (err) {
    console.error("Erreur lors de la récupération de la carte :", err);
    res.status(500).json({ error: "Erreur serveur lors de la récupération de la carte." });
  }
});

// ✅ POST ajouter ou mettre à jour une carte
router.post("/add-card", async (req, res) => {
  try {
    const { userId, soldeBancaire, numeroCarte, typeCarte, dateExpiration } = req.body;

    if (!userId || !soldeBancaire || !numeroCarte || !typeCarte || !dateExpiration) {
      return res.status(400).json({ error: "Tous les champs sont obligatoires." });
    }

    let card = await Card.findOne({ userId });

    if (card) {
      card.soldeBancaire = soldeBancaire;
      card.numeroCarte = numeroCarte;
      card.typeCarte = typeCarte;
      card.dateExpiration = dateExpiration;
      await card.save();
      return res.status(200).json({ message: "Carte mise à jour avec succès.", card });
    }

    card = new Card({ userId, soldeBancaire, numeroCarte, typeCarte, dateExpiration });
    await card.save();
    res.status(201).json({ message: "Carte ajoutée avec succès.", card });
  } catch (err) {
    console.error("Erreur lors de l'ajout ou de la mise à jour de la carte :", err);
    res.status(500).json({ error: "Erreur serveur lors de l'ajout ou de la mise à jour de la carte." });
  }
});

// ✅ UPDATE une carte par ID
router.put("/update-card/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { soldeBancaire, numeroCarte, typeCarte, dateExpiration } = req.body;

    const card = await Card.findById(id);

    if (!card) {
      return res.status(404).json({ message: "Carte non trouvée." });
    }

    card.soldeBancaire = soldeBancaire;
    card.numeroCarte = numeroCarte;
    card.typeCarte = typeCarte;
    card.dateExpiration = dateExpiration;

    await card.save();

    res.status(200).json({ message: "Carte mise à jour avec succès.", card });
  } catch (err) {
    console.error("Erreur lors de la mise à jour de la carte :", err);
    res.status(500).json({ error: "Erreur serveur lors de la mise à jour de la carte." });
  }
});

// ✅ POST ajouter une transaction
router.post("/add-transaction", async (req, res) => {
  try {
    const { userId, cardId, transactionNumber, amount, beneficiaryAccount, date } = req.body;

    if (!userId || !cardId || !transactionNumber || !amount || !beneficiaryAccount) {
      return res.status(400).json({ error: "Tous les champs sont obligatoires." });
    }

    const transaction = new Transaction({
      userId,
      cardId,
      transactionNumber,
      amount,
      beneficiaryAccount,
      date: date || new Date()
    });

    await transaction.save();
    res.status(201).json({ message: "Transaction ajoutée avec succès.", transaction });
  } catch (err) {
    console.error("Erreur lors de l'ajout de la transaction :", err);
    res.status(500).json({ error: "Erreur serveur lors de l'ajout de la transaction." });
  }
});

// ✅ GET transactions d'une carte (via _id)
router.get("/transactions/:cardId", async (req, res) => {
  try {
    const { cardId } = req.params;

    const transactions = await Transaction.find({ cardId }).sort({ date: -1 });

    res.status(200).json(transactions);
  } catch (err) {
    console.error("Erreur lors de la récupération des transactions :", err);
    res.status(500).json({ error: "Erreur serveur lors de la récupération des transactions." });
  }
});

// ✅ DELETE - Supprimer une transaction par ID
router.delete("/delete-transaction/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const transaction = await Transaction.findByIdAndDelete(id);

    if (!transaction) {
      return res.status(404).json({ error: "Transaction non trouvée." });
    }

    res.status(200).json({ message: "Transaction supprimée avec succès." });
  } catch (err) {
    console.error("Erreur lors de la suppression de la transaction :", err);
    res.status(500).json({ error: "Erreur serveur lors de la suppression de la transaction." });
  }
});

module.exports = router;
