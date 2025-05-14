const mongoose = require("mongoose");

// Définir le schéma de l'utilisateur avec les nouveaux champs
const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    prenom: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, trim: true },
    password: { type: String, required: true, minlength: 6 },
    phone: { type: String, required: true },
    civilite: { type: String, enum: ["Mme", "M."], required: true },
    gouvernorat: { type: String, required: true },
    dateNaissance: { type: Date, required: true },
    soldeBancaire: { type: Number, default: 0 },
    role: { type: String, enum: ["admin", "user"], default: "user" },
    image: {
      type: String,
      default: "uploads\\user.png",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
