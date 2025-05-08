const mongoose = require("mongoose");

const objectifSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    amount: { type: Number, required: true, default: 0 }, // Total goal
    progression: { type: Number, required: true, default: 0 }, // Current saved
    date: { type: Date, required: true }, // End date
    createdAt: { type: Date },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Objectif", objectifSchema);
