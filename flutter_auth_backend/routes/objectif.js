const express = require("express");
const authMiddleware = require("../middleware/auth");
const Objectif = require("../models/objectif");

const router = express.Router();

router.post("/create", authMiddleware, async (req, res) => {
  try {
    const { name, amount, date } = req.body;
    const userId = req.user.user._id;

    if (!name || !amount == null || !date) {
      return res.status(400).json({ msg: "Tous les champs sont requis." });
    }
    const parsedDate = new Date(date);
    const newObjectif = new Objectif({
      name,
      amount: Number(amount),
      date: parsedDate,
      userId,
      createdAt: new Date(),
    });

    await newObjectif.save();
    res.status(201).json(newObjectif);
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: err.message }); // Return actual error
  }
});

// Get all objectifs by user
router.get("/all/user", authMiddleware, async (req, res) => {
  try {
    const userId = req.user.user._id;
    const objectifs = await Objectif.find({ userId });
    res.status(200).json(objectifs);
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

// Update objectif
router.put("/update/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user._id;
    const { name, amount, date } = req.body;

    const objectif = await Objectif.findOne({ _id: id, userId });

    if (!objectif) {
      return res.status(404).json({ msg: "Objectif non trouvé." });
    }

    if (name) objectif.name = name;
    if (amount) objectif.amount = amount;
    if (date) objectif.date = date;

    await objectif.save();
    res.status(200).json(objectif);
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

router.put("/progress/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user._id;
    const { amount } = req.body;

    if (!amount || isNaN(amount) || amount <= 0) {
      return res.status(400).json({ msg: "Montant invalide." });
    }

    const objectif = await Objectif.findOne({ _id: id, userId });
    if (!objectif) {
      return res.status(404).json({ msg: "Objectif non trouvé." });
    }

    const remainingAmount = objectif.amount - objectif.progression;
    if (amount > remainingAmount) {
      return res
        .status(400)
        .json({ msg: "Montant dépasse le montant restant." });
    }

    objectif.progression += amount;
    await objectif.save();

    res.status(200).json({
      msg: `${amount} DT ajoutés avec succès.`,
      progression: objectif.progression,
      remaining: objectif.amount - objectif.progression,
    });
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

router.delete("/delete/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user._id;

    const objectif = await Objectif.deleteOne({ _id: id, userId });
    if (objectif.deletedCount === 0) {
      return res.status(404).json({ msg: "Objectif non trouvé." });
    }
    res.status(200).json({ message: "Objectif supprimé." });
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

router.get("/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user._id;

    const objectif = await Objectif.findOne({ _id: id, userId });

    if (!objectif) {
      return res.status(404).json({ msg: "Objectif non trouvé." });
    }

    const today = new Date();
    const endDate = new Date(objectif.date);

    const remainingAmount = objectif.amount - objectif.progression;

    const remainingDays = Math.max(
      1,
      Math.ceil((endDate - today) / (1000 * 60 * 60 * 24))
    );

    const dailyAmount = Math.ceil(remainingAmount / remainingDays);

    res.status(200).json({
      objectif,
      remainingAmount,
      dailyAmount,
      remainingDays,
    });
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});


module.exports = router;
