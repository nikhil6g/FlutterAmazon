const express = require("express");
const auth = require("../middlewares/auth");
const {
  addToCart,
  deleteFromCart,
  saveAddress,
  orderProduct,
  getAllOrders,
} = require("../controllers/userController");
const userRouter = express.Router();

userRouter.post("/api/add-to-cart", auth, addToCart);
userRouter.delete("/api/remove-from-cart/:id", auth, deleteFromCart);
userRouter.post("/api/save-user-address", auth, saveAddress);
userRouter.post("/api/order", auth, orderProduct);
userRouter.get("/api/orders/me", auth, getAllOrders);

module.exports = userRouter;
