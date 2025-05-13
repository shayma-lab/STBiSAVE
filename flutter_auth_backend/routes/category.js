const express = require("express");
const authMiddleware = require("../middleware/auth");
const Category = require("../models/category");
const User = require("../models/user");

const router = express.Router();

router.post("/create", authMiddleware, async (req, res) => {
  try {
    const { title,icon,color } = req.body;
    const userId = req.user.user._id;

    if (!title) {
      return res.status(400).json({ msg: "le titre est requis." });
    }
    const newCategory = new Category({
      title,
      userId,
      ...(icon && { icon }),
      ...(color && { color }),
    });

    await newCategory.save();
    res.status(201).json(newCategory);
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: err.message });
  }
});

router.get("/all/user", authMiddleware, async (req, res) => {
  try {
    console.log("User :", req.user.user.role);
    const { _id: userId, role } = req.user.user;

    let query = { $or: [{ userId }] };

    if (role === "user") {
      const adminUsers = await User.find({ role: "admin" }, "_id");
      const adminIds = adminUsers.map((u) => u._id);
      query.$or.push({ userId: { $in: adminIds } });
    }

    const categories = await Category.find(query);
    res.status(200).json(categories);
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

router.delete("/delete/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user._id;

    const category = await Category.deleteOne({ _id: id, userId });
    if (category.deletedCount === 0) {
      return res.status(404).json({ msg: "Category non trouvé." });
    }
    res.status(200).json({ message: "Category supprimé." });
  } catch (err) {
    console.error("Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur interne." });
  }
});

module.exports = router;
