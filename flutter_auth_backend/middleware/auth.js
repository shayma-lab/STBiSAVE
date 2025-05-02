// middleware/auth.js
const jwt = require('jsonwebtoken');
const JWT_SECRET = "STB123STB";//ue dans ton fichier auth.js

module.exports = function (req, res, next) {
  const token = req.header('Authorization');

  if (!token) {
    return res.status(401).json({ msg: 'Aucun token, accès refusé' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded; // contient { id, email }
    next();
  } catch (err) {
    console.error("Erreur de vérification du token:", err);
    res.status(401).json({ msg: 'Token invalide' });
  }
};