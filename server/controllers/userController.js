const asyncHandler = require("express-async-handler");
const User = require("../models/user");
const { Product } = require("../models/product");
const Order = require("../models/order");
const { sendEmailWithReceipt } = require("../utils/email");
const { generateReceiptPDF } = require("../utils/pdf");
const { redisClient } = require("../config/redis");

//@description     Notfy me when product is available
//@route           POST /api/notify-me
//@access          Protected
const notifyMe = asyncHandler(async (req, res) => {
  const { userId, productId, fcmToken } = req.body;

  if (!userId || !productId || !fcmToken) {
    return res.status(400).json({ error: "Missing required fields" });
  }
  try {
    await redisClient.sadd(
      `notifications:product:${productId}`,
      JSON.stringify({ userId, fcmToken, isBanned: false })
    );

    return res.json({ success: true, message: "Subscribed successfully!" });
  } catch (error) {
    return res.status(500).json({ error: "Failed to subscribe" });
  }
});

//@description     Check for user is already subscribed for notification or not
//@route           GET /api/notifications/check-subscription?userId=${userId}&productId=${productId}
//@access          Protected
const checkSubscription = asyncHandler(async (req, res) => {
  const { userId, productId } = req.query;

  if (!userId || !productId) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  try {
    const subscribers = await redisClient.smembers(
      `notifications:product:${productId}`
    );
    const isSubscribed = subscribers.some(
      (subscriber) => JSON.parse(subscriber).userId === userId
    );
    return res.json({ subscribed: isSubscribed });
  } catch (error) {
    return res
      .status(500)
      .json({ error: "Failed to check subscription status" });
  }
});

//@description     Adding product to cart
//@route           POST /api/add-to-cart
//@access          Protected
const addToCart = asyncHandler(async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);

    let user = await User.findById(req.userId);

    let isProductFound = false;
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        //actually _id property is given by mongoose which is not string
        isProductFound = true;
      }
    }
    if (isProductFound) {
      let cartObject = user.cart.find((cartObject) =>
        cartObject.product._id.equals(product._id)
      );
      cartObject.quantity += 1;
    } else {
      user.cart.push({ product, quantity: 1 });
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Deleting product to cart
//@route           DELETE /api/remove-from-cart/:id
//@access          Protected
const deleteFromCart = asyncHandler(async (req, res) => {
  try {
    const id = req.params.id;
    const product = await Product.findById(id);
    //console.log(product)
    let user = await User.findById(req.userId);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        //actually _id property is given by mongoose which is not string
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Save user address
//@route           POST /api/save-user-address
//@access          Protected
const saveAddress = asyncHandler(async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.userId);
    user.address = address;
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Order Product
//@route           POST /api/order
//@access          Protected
const orderProduct = asyncHandler(async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity < cart[i].quantity) {
        return res.status(400).json({ msg: `${product.name} is out of stock` });
      }
    }
    let products = [];
    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      product.soldCount += cart[i].quantity;
      product.quantity -= cart[i].quantity;
      products.push({ product, quantity: cart[i].quantity });
      await product.save();
    }

    let user = await User.findById(req.userId);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.userId,
      orderAt: new Date().getTime(),
    });

    order = await order.save();

    const pdfBuffer = await generateReceiptPDF(order, user);
    await sendEmailWithReceipt(user.email, pdfBuffer);

    res.json(order);
  } catch (e) {
    console.log(e.message);
    res.status(500).json({ err: e.message });
  }
});

//@description     Get all the orders
//@route           GET /api/orders/me
//@access          Protected
const getAllOrders = asyncHandler(async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.userId });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = {
  notifyMe,
  checkSubscription,
  addToCart,
  deleteFromCart,
  saveAddress,
  orderProduct,
  getAllOrders,
};
