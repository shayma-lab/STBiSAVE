const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
dotenv.config();
const app = express();
const authRoutes = require("./routes/auth");
const adminRoutes = require("./routes/admin");
const acceuilRoutes = require("./routes/acceuil");
const objectifRoutes = require("./routes/objectif");

// Middleware
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json());

// Connexion MongoDB
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB connecté !");
  } catch (err) {
    console.error("❌ Erreur de connexion à MongoDB :", err.message);
    process.exit(1);
  }
};
connectDB();

// Models (🆕 pour s'assurer que Card est chargé avant usage)
require("./models/card"); // <-- AJOUT IMPORTANT 🆕

app.use("/api/auth", authRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/accueil", acceuilRoutes);
app.use("/api/objectif", objectifRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, "0.0.0.0", () =>
  console.log(`🚀 Serveur lancé sur le port ${PORT}`)
);
