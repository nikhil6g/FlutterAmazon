const asyncHandler = require("express-async-handler");
const { Product } = require("../models/product");
const Order = require("../models/order");
const admin = require("../config/firebaseAdmin");
const { redisClient } = require("../config/redis");

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

//@description     Update product details
//@route           POST /admin/update-product-details
//@access          Protected
const updateProductDetails = asyncHandler(async (req, res) => {
  try {
    const { name, description, imageUrls, quantity, price, category, id } =
      req.body;
    let oldProductDetails = await Product.findById(id);
    if (!oldProductDetails) {
      return res.status(404).json({ err: "Product not found" });
    }

    const wasOutOfStock = oldProductDetails.quantity === 0;

    oldProductDetails.name = name;
    oldProductDetails.description = description;
    oldProductDetails.imageUrls = imageUrls;
    oldProductDetails.quantity = quantity;
    oldProductDetails.price = price;
    oldProductDetails.category = category;

    await oldProductDetails.save();

    res.status(200).json(oldProductDetails);

    if (wasOutOfStock && quantity > 0) {
      redisClient
        .publish(
          "product_notifications",
          JSON.stringify({ productId: id, productName: name })
        )
        .catch((error) =>
          console.error("Error publishing notification:", error)
        ); //here I do not use await because of any error in this function should not affect the response.
    }
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ err: e.message });
  }
});

//@description     Get all the orders
//@route           Get /admin/get-orders
//@access          Protected
const fetchOrders = asyncHandler(async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     update the order status
//@route           POST /admin/change-order-status
//@access          Protected
const changeOrderStatus = asyncHandler(async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//@description     get the total earnings and category wise earning
//@route           GET /admin/analytics
//@access          Protected
const getAnalytics = asyncHandler(async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;
    let totalSellingCount = 0;
    for (let order of orders) {
      for (let product of order.products) {
        totalEarnings += product.quantity * product.product.price;
        totalSellingCount += product.quantity;
      }
    }

    //Category wise order fetching
    let categories = [
      "Mobiles",
      "Essentials",
      "Appliances",
      "Books",
      "Fashion",
    ];
    let categoryData = {};

    for (let category of categories) {
      categoryData[category] = await fetchCategoryWiseProducts(category);
    }

    let earnings = {
      totalEarnings,
      totalSellingCount,
      categoryData,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProducts(category) {
  let earnings = 0;
  let sellingCount = 0;

  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let order of categoryOrders) {
    for (let product of order.products) {
      if (product.product.category === category) {
        earnings += product.quantity * product.product.price;
        sellingCount += product.quantity;
      }
    }
  }

  return { earnings, sellingCount };
}

module.exports = {
  addProduct,
  fetchProducts,
  deleteProduct,
  updateProductDetails,
  fetchOrders,
  changeOrderStatus,
  getAnalytics,
};
