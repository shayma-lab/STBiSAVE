const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const router = express.Router();
const JWT_SECRET = "STB123STB";

// ✅ Route d'inscription avec champs supplémentaires
router.post("/signup", async (req, res) => {
    try {
        const { name, prenom, email, password, soldeBancaire, phone, civilite, gouvernorat, dateNaissance } = req.body;

        if (!name || !prenom || !email || !password || !phone || !civilite || !gouvernorat || !dateNaissance) {
            return res.status(400).json({ msg: "Tous les champs sont requis." });
        }

        // Vérifier si l'utilisateur existe déjà
        let user = await User.findOne({ email });
        if (user) return res.status(400).json({ msg: "L'utilisateur existe déjà." });

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
            return res.status(400).json({ error: "Email et mot de passe sont requis." });
        }

        const user = await User.findOne({ email });
        if (!user) return res.status(404).json({ error: "Utilisateur non trouvé." });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(401).json({ error: "Mot de passe incorrect." });

        const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: "1h" });

        res.status(200).json({ message: "Connexion réussie", token, user });
    } catch (error) {
        console.error("Erreur serveur : ", error);
        res.status(500).json({ error: "Erreur serveur interne." });
    }
});

module.exports = router;

