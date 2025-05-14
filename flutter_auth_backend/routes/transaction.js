const express = require("express");
const router = express.Router();
const User = require("../models/user");
const Transaction = require("../models/transaction");
const authMiddleware = require("../middleware/auth");
const mongoose = require("mongoose");
const Category = require("../models/category");

router.get("/me", authMiddleware, async (req, res) => {
  try {
    const userId = req.user.user._id;

    const user = await User.findById(userId).select("name");
    if (!user) {
      return res.status(404).json({ msg: "Utilisateur non trouvé" });
    }

    const transactions = await Transaction.find({ userId })
      .sort({ date: -1 })
      .populate({ path: "category" });

    res.json(transactions);
  } catch (err) {
    console.error("Erreur serveur:", err.message);
    res.status(500).send("Erreur serveur");
  }
});

router.put("/:transactionId/category", authMiddleware, async (req, res) => {
  try {
    const { transactionId } = req.params;
    const { categoryId } = req.body;
    const userId = req.user.user._id;

    // Validate inputs
    if (!mongoose.Types.ObjectId.isValid(transactionId)) {
      return res.status(400).json({ msg: "ID de transaction invalide" });
    }
    if (!mongoose.Types.ObjectId.isValid(categoryId)) {
      return res.status(400).json({ msg: "ID de catégorie invalide" });
    }

    // Verify category exists
    const categoryExists = await Category.exists({ _id: categoryId });
    if (!categoryExists) {
      return res.status(404).json({ msg: "Catégorie non trouvée" });
    }

    // Update transaction
    const updatedTransaction = await Transaction.findOneAndUpdate(
      {
        _id: transactionId,
        userId: userId,
      },
      { category: categoryId },
      { new: true }
    ).populate({
      path: "category",
      select: "title color icon",
    });

    if (!updatedTransaction) {
      return res.status(404).json({
        msg: "Transaction non trouvée ou accès non autorisé",
      });
    }

    res.json({
      success: true,
      transaction: updatedTransaction,
    });
  } catch (err) {
    console.error("Erreur serveur:", err.message);
    res.status(500).json({
      success: false,
      msg: "Erreur serveur",
      error: err.message,
    });
  }
});

router.get("/by-category", authMiddleware, async (req, res) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.user.user._id);

    const result = await Transaction.aggregate([
      // Match transactions for current user
      {
        $match: { userId: userId },
      },
      // Lookup category information
      {
        $lookup: {
          from: "categories",
          localField: "category",
          foreignField: "_id",
          as: "category",
        },
      },
      {
        $unwind: {
          path: "$category",
          preserveNullAndEmptyArrays: true,
        },
      },
      // Lookup user information (though we already have userId, this gets full user details)
      {
        $lookup: {
          from: "users",
          localField: "userId",
          foreignField: "_id",
          as: "user",
        },
      },
      {
        $unwind: {
          path: "$user",
          preserveNullAndEmptyArrays: true,
        },
      },
      // Group by category
      {
        $group: {
          _id: {
            categoryId: "$category._id",
            title: "$category.title",
            color: "$category.color",
            icon: "$category.icon",
          },
          totalAmount: { $sum: "$amount" },
          transactions: {
            $push: {
              _id: "$_id",
              amount: "$amount",
              date: "$date",
              beneficiaryAccount: "$beneficiaryAccount",
              description: "$description",
              category: {
                id: "$category._id",
                title: "$category.title",
                color: "$category.color",
                icon: "$category.icon",
              },
              user: {
                id: "$user._id",
                name: "$user.name",
                prenom: "$user.prenom",
              },
            },
          },
          count: { $sum: 1 },
        },
      },
      // Project final output
      {
        $project: {
          _id: 0,
          category: {
            id: "$_id.categoryId",
            title: "$_id.title",
            color: "$_id.color",
            icon: "$_id.icon",
          },
          totalAmount: 1,
          count: 1,
          transactions: 1,
        },
      },
      // Sort by total amount (descending)
      {
        $sort: { totalAmount: -1 },
      },
    ]);

    res.json(result);
  } catch (err) {
    console.error("Erreur serveur:", err.message);
    res.status(500).json({
      success: false,
      msg: "Erreur serveur",
      error: err.message,
    });
  }
});

router.get("/by-category-admin", authMiddleware, async (req, res) => {
  try {
    const result = await Transaction.aggregate([
      // Lookup category information
      {
        $lookup: {
          from: "categories",
          localField: "category",
          foreignField: "_id",
          as: "category",
        },
      },
      {
        $unwind: {
          path: "$category",
          preserveNullAndEmptyArrays: true,
        },
      },
      // Lookup user information
      {
        $lookup: {
          from: "users",
          localField: "userId",
          foreignField: "_id",
          as: "user",
        },
      },
      {
        $unwind: {
          path: "$user",
          preserveNullAndEmptyArrays: true,
        },
      },
      // Group by category
      {
        $group: {
          _id: {
            categoryId: "$category._id",
            title: "$category.title",
            color: "$category.color",
            icon: "$category.icon",
          },
          totalAmount: { $sum: "$amount" },
          transactions: {
            $push: {
              _id: "$_id",
              amount: "$amount",
              date: "$date",
              beneficiaryAccount: "$beneficiaryAccount",
              description: "$description",
              category: {
                id: "$category._id",
                title: "$category.title",
                color: "$category.color",
                icon: "$category.icon",
              },
              user: {
                id: "$user._id",
                name: "$user.name",
                prenom: "$user.prenom",
              },
            },
          },
          count: { $sum: 1 },
        },
      },
      // Project final output
      {
        $project: {
          _id: 0,
          category: {
            id: "$_id.categoryId",
            title: "$_id.title",
            color: "$_id.color",
            icon: "$_id.icon",
          },
          totalAmount: 1,
          count: 1,
          transactions: 1,
        },
      },
      // Sort by total amount (descending)
      {
        $sort: { totalAmount: -1 },
      },
    ]);

    res.json(result);
  } catch (err) {
    console.error("Erreur serveur:", err.message);
    res.status(500).json({
      success: false,
      msg: "Erreur serveur",
      error: err.message,
    });
  }
});

router.get("/monthly-summary", authMiddleware, async (req, res) => {
  try {
    const userId = req.user.user._id;
    const now = new Date();
    const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
    const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);

    const result = await Transaction.aggregate([
      {
        $match: {
          userId: new mongoose.Types.ObjectId(userId),
          date: {
            $gte: firstDay,
            $lte: lastDay,
          },
        },
      },
      {
        $group: {
          _id: null,
          count: { $sum: 1 },
          totalAmount: { $sum: "$amount" },
        },
      },
      {
        $project: {
          _id: 0,
          count: 1,
          totalAmount: 1,
        },
      },
    ]);

    const summary = result[0] || { count: 0, totalAmount: 0 };

    res.json({
      count: summary.count,
      totalAmount: summary.totalAmount,
    });
  } catch (err) {
    console.error("Monthly summary error:", err);
    res.status(500).json({
      success: false,
      message: "Failed to get monthly summary",
      error: err.message,
    });
  }
});

module.exports = router;
