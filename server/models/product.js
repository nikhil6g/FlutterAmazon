const mongoose = require("mongoose");
const ratingScema = require("./rating");

const productScema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  brand: {
    type: String,
    required: true,
  },
  imageUrls: [
    {
      type: String,
      required: true,
    },
  ],
  quantity: {
    type: Number,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  tags: {
    type: String,
  },
  soldCount: {
    type: Number,
    default: 0,
  },
  //ratings
  avgRating: {
    type: Number,
    default: 0,
  },
  ratings: [ratingScema],
});

const Product = mongoose.model("Product", productScema);

module.exports = { Product, productScema };
