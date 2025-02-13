const asyncHandler = require("express-async-handler");
const User = require("../models/user");
const { Product } = require("../models/product");
const Order = require("../models/order");

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
      let product = await Product.findById(cart[i].product.id);
      if (product.quantity < cart[i].quantity) {
        return res.status(400).json({ msg: `${product.name} is out of stock` });
      }
    }

    let products = [];
    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product.id);
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
      orderAt: new Date().getMilliseconds(),
    });

    order = await order.save();
    res.json(order);
  } catch (e) {
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
  addToCart,
  deleteFromCart,
  saveAddress,
  orderProduct,
  getAllOrders,
};
