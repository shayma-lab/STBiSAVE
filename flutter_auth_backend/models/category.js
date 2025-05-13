const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  title: { type: String, required: true },
  color: { type: String, default: "Colors.teal" },
  icon: { type: String, default: "Icons.category" },
});

module.exports = mongoose.model("Category", categorySchema);

