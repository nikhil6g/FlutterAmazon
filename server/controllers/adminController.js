const asyncHandler = require("express-async-handler");
const { Product } = require("../models/product");

//@description     Add Product
//@route           POST /admin/add-product
//@access          Protected
const addProduct = asyncHandler(async (req, res) => {
  try {
    const { name, description, imageUrls, quantity, price, category } =
      req.body;
    let product = new Product({
      name,
      description,
      imageUrls,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Get all the products
//@route           GET /admin/get-products
//@access          Protected
const fetchProducts = asyncHandler(async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Delete product
//@route           POST /admin/delete-product
//@access          Protected
const deleteProduct = asyncHandler(async (req, res) => {
  try {
    const { id } = req.body;

    let product = await Product.findByIdAndDelete(id);

    res.json(product);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

module.exports = { addProduct, fetchProducts, deleteProduct };
