const express = require("express");
const admin = require("../middlewares/admin");
const {
  addProduct,
  fetchProducts,
  deleteProduct,
  fetchOrders,
  changeOrderStatus,
  getAnalytics,
} = require("../controllers/adminController");

const adminRouter = express.Router();

adminRouter.post("/admin/add-product", admin, addProduct);
adminRouter.get("/admin/get-products", admin, fetchProducts);
adminRouter.post("/admin/delete-product", admin, deleteProduct);
adminRouter.get("/admin/get-orders", admin, fetchOrders);
adminRouter.post("/admin/change-order-status", admin, changeOrderStatus);
adminRouter.get("/admin/analytics", admin, getAnalytics);

module.exports = adminRouter;
