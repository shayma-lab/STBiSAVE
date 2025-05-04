const jwt = require('jsonwebtoken');
const JWT_SECRET = "STB123STB";//ue dans ton fichier auth.js

module.exports = function (req, res, next) {
  const authHeader = req.header('Authorization');

  if (!authHeader) {
    return res.status(401).json({ msg: 'Aucun token, accès refusé' });
  }
  const token = authHeader.split(' ')[1];
  if (!token) {
    return res.status(401).json({ msg: 'Token manquant ou mal formaté' });
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