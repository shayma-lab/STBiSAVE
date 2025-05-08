const express = require("express");
const authMiddleware = require("../middleware/auth");
const Objectif = require("../models/objectif");

const router = express.Router();

// Create Objectif
router.post("/create", authMiddleware, async (req, res) => {
  try {
    const { name, amount, date } = req.body;
    const userId = req.user.user._id;

    if (!name || !amount == null || !date) {
      // Handle `amount=0`
      return res.status(400).json({ msg: "Tous les champs sont requis." });
    }

    // Explicitly create a Date object
    const parsedDate = new Date(date);

    const newObjectif = new Objectif({
      // ← Capitalized model name
      name,
      amount: Number(amount),
      date: parsedDate,
      userId,
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

router.post("/progress/:id", authMiddleware, async (req, res) => {
  try {
    const objectifId = req.params.id;
    const userId = req.user.user._id;

    const objectif = await Objectif.findOne({ _id: objectifId, userId });
    if (!objectif) {
      return res.status(404).json({ msg: "Objectif non trouvé." });
    }

    const today = new Date();
    const totalDays = Math.ceil(
      (new Date(objectif.date) - new Date(objectif.startDate)) /
        (1000 * 60 * 60 * 24)
    );
    const daysPassed = Math.ceil(
      (today - new Date(objectif.startDate)) / (1000 * 60 * 60 * 24)
    );
    const remaining = objectif.amount - objectif.progression;

    const expectedProgression = (objectif.amount / totalDays) * daysPassed;
    const recommendedAmount = Math.ceil(
      expectedProgression - objectif.progression
    );

    if (recommendedAmount <= 0) {
      return res
        .status(200)
        .json({ msg: "Aucune progression nécessaire aujourd'hui." });
    }

    objectif.progression += recommendedAmount;
    await objectif.save();

    res.status(200).json({
      progression: objectif.progression,
      recommendedAmount,
      remaining: objectif.amount - objectif.progression,
    });
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

module.exports = router;
