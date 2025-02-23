const express = require("express");
const auth = require("../middlewares/auth");
const {
  notifyMe,
  checkSubscription,
  addToCart,
  deleteFromCart,
  saveAddress,
  orderProduct,
  getAllOrders,
} = require("../controllers/userController");
const userRouter = express.Router();

userRouter.post("/api/notify-me", auth, notifyMe);
userRouter.get(
  "/api/notifications/check-subscription",
  auth,
  checkSubscription
);
userRouter.post("/api/add-to-cart", auth, addToCart);
userRouter.delete("/api/remove-from-cart/:id", auth, deleteFromCart);
userRouter.post("/api/save-user-address", auth, saveAddress);
userRouter.post("/api/order", auth, orderProduct);
userRouter.get("/api/orders/me", auth, getAllOrders);

module.exports = userRouter;
