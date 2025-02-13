const express = require("express");
const admin = require("../middlewares/admin");
const {
  addProduct,
  fetchProducts,
  deleteProduct,
} = require("../controllers/adminController");

const adminRouter = express.Router();

adminRouter.post("/admin/add-product", admin, addProduct);
adminRouter.get("/admin/get-products", admin, fetchProducts);
adminRouter.post("/admin/delete-product", admin, deleteProduct);

module.exports = adminRouter;
