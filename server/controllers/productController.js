const asyncHandler = require("express-async-handler");
const { Product } = require("../models/product");

//@description     Get all the products with particular category
//@route           GET /api/products
//@access          Protected
const fetchCategoryWiseProduct = asyncHandler(async (req, res) => {
  try {
    const requireCategory = req.query.category; //url query- actually in url some data is sent and this is category
    const products = await Product.find({ category: requireCategory });
    res.json(products);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Search products by query or get product by ID
//@route           GET /api/products/search
//@access          Protected
const searchProduct = asyncHandler(async (req, res) => {
  try {
    const { searchQuery, productId } = req.query;

    let products;

    if (productId) {
      products = await Product.findById(productId);
    } else if (searchQuery) {
      products = await Product.find({
        name: { $regex: searchQuery },
      });
    } else {
      return res.status(400).json({ message: "Provide a query or productId" });
    }

    if (!products) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json(products);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Rate the product
//@route           POST /api/rate-product
//@access          Protected
const rateProduct = asyncHandler(async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    let oldRating = null;

    //checking for matching userid in ratings and delete this
    for (let j = 0; j < product.ratings.length; j++) {
      //here product.ratings is an array
      if (product.ratings[j].userId == req.userId) {
        oldRating = product.ratings[j].rating;
        //here userId of client is given in auth middleware
        product.ratings.splice(j, 1); //here splice is just delete the rating given by client previously
        break;
      }
    }

    const ratingScema = {
      userId: req.userId,
      rating,
    };
    product.ratings.push(ratingScema);

    if (!oldRating) {
      //when user already update the product
      product.avgRating =
        (product.avgRating * product.ratings.length - oldRating + rating) /
        product.ratings.length;
    } else {
      //first time user rated the product
      product.avgRating =
        (product.avgRating * (product.ratings.length - 1) + rating) /
        product.ratings.length;
    }
    product = await product.save();

    res.json(product);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

//@description     Get deal of the day product
//@route           GET /api/deal-of-day
//@access          Protected
const findDealOfDay = asyncHandler(async (req, res) => {
  try {
    let products = await Product.find({});

    //sort products based on total ratings in descending order
    products.sort((pdt1, pdt2) => {
      let pdt1Sum = 0,
        pdt2Sum = 0;

      //calculate total rating of product1
      for (let j = 0; j < pdt1.ratings.length; j++) {
        pdt1Sum += pdt1.ratings[j].rating;
      }

      //calculate total rating of product2
      for (let j = 0; j < pdt2.ratings.length; j++) {
        pdt2Sum += pdt2.ratings[j].rating;
      }
      return pdt1Sum < pdt2Sum ? 1 : -1;
    });

    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ err: e.message });
  }
});

module.exports = {
  fetchCategoryWiseProduct,
  searchProduct,
  rateProduct,
  findDealOfDay,
};
