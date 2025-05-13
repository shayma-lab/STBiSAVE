const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Card = require("../models/card");
const User = require("../models/user");

const authMiddleware = require("../middleware/auth");

const router = express.Router();
const JWT_SECRET = "STB123STB";

// ✅ Route d'inscription avec champs supplémentaires
router.post("/signup", async (req, res) => {
  try {
    const {
      name,
      prenom,
      email,
      password,
      soldeBancaire,
      phone,
      civilite,
      gouvernorat,
      dateNaissance,
    } = req.body;

    if (
      !name ||
      !prenom ||
      !email ||
      !password ||
      !phone ||
      !civilite ||
      !gouvernorat ||
      !dateNaissance
    ) {
      return res.status(400).json({ msg: "Tous les champs sont requis." });
    }

    // Vérifier si l'utilisateur existe déjà
    let user = await User.findOne({ email });
    if (user)
      return res.status(400).json({ msg: "L'utilisateur existe déjà." });

    // Hacher le mot de passe
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Créer un nouvel utilisateur avec tous les champs
    user = new User({
      name,
      prenom,
      email,
      password: hashedPassword,
      soldeBancaire,
      phone,
      civilite,
      gouvernorat,
      dateNaissance,
    });

    await user.save();
    res.status(201).json({ msg: "Utilisateur créé avec succès." });
  } catch (err) {
    console.error("Erreur serveur : ", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

// ✅ Route de connexion reste inchangée
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res
        .status(400)
        .json({ error: "Email et mot de passe sont requis." });
    }

    const user = await User.findOne({ email });
    if (!user)
      return res.status(404).json({ error: "Utilisateur non trouvé." });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(401).json({ error: "Mot de passe incorrect." });

    const { password: _pwd, ...userData } = user.toObject();
    const card = await Card.findOne({ userId: user._id });
    if (card) {
      userData.soldeBancaire = card.soldeBancaire;
    }
    const token = jwt.sign({ user: userData }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(200).json({ token });
  } catch (error) {
    console.error("Erreur serveur : ", error);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

router.put("/update", authMiddleware, async (req, res) => {
  try {
    const userId = req.user.user._id;

    const { name, prenom, phone, civilite, gouvernorat, dateNaissance } =
      req.body;

    if (
      !userId ||
      !name ||
      !prenom ||
      !phone ||
      !civilite ||
      !gouvernorat ||
      !dateNaissance
    ) {
      return res.status(400).json({ msg: "Tous les champs sont requis." });
    }

    let user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: "Utilisateur non trouvé." });
    }

    user.name = name;
    user.prenom = prenom;
    user.phone = phone;
    user.civilite = civilite;
    user.gouvernorat = gouvernorat;
    user.dateNaissance = dateNaissance;
    await user.save();
    res.status(200).json(user);
  } catch (err) {
    console.error("Erreur serveur : ", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

module.exports = router;
