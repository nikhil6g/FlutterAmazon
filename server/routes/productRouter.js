const express = require("express");
const auth = require("../middlewares/auth");
const {
  fetchCategoryWiseProduct,
  searchProduct,
  rateProduct,
  findDealOfDay,
} = require("../controllers/productController");

const productRouter = express.Router();

productRouter.get("/api/products", auth, fetchCategoryWiseProduct);
productRouter.get("/api/products/search/:name", auth, searchProduct);
productRouter.post("/api/rate-product", auth, rateProduct);
productRouter.get("/api/deal-of-day", auth, findDealOfDay);

module.exports = productRouter;
