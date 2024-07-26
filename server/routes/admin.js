const express = require('express');
const admin = require('../middlewares/admin');
const Product = require('../models/product');

const adminRoute = express.Router()

//Add Product
adminRoute.post('/admin/add-product',admin,async (req,res) => {
    try{
        const {name, description, imageUrls, quantity, price, category} = req.body
        let product = new Product({
            name,
            description,
            imageUrls,
            quantity,
            price,
            category,
        })
        product = await product.save();
        res.json(product);
    }catch(e){
        res.status(500).json({err : e.message})
    }
})


//get all the products
adminRoute.get('/admin/get-products',admin,async (req,res)=>{
    try{
        const products = await Product.find({})
        res.json(products)
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

//delete product
adminRoute.post('/admin/delete-product',admin,async (req,res) =>{
    try{
        const {id} = req.body

        let product = await Product.findByIdAndDelete(id);

        res.json(product)
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

module.exports = adminRoute
