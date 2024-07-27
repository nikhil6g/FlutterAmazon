const express = require('express')
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const Product = require('../models/product');

//get all the products with particular category
productRouter.get('/api/products',auth,async (req,res)=>{
    try{
        const requireCategory = req.query.category; //url query- actually in url some data is sent and this is category
        const products = await Product.find({category : requireCategory })
        res.json(products)
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

//get all the searched products
productRouter.get('/api/products/search/:name',auth,async (req,res)=>{
    try{
        const searchQuery = req.params.name; //url query- actually in url some data is sent and this is category
        const products = await Product.find({
            name : {$regex : searchQuery} ,
        })
        res.json(products)
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

module.exports = productRouter