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

//create a post request route to rate the product
productRouter.post('/api/rate-product',auth,async(req,res)=>{
    try{
        const { id , rating } = req.body
        let product = await Product.findById(id)

        //checking for matching userid in ratings and delete this
        for(let j=0;j<product.ratings.length;j++){ //here product.ratings is an array
            if(product.ratings[j].userId==req.userId){ //here userId of client is given in auth middleware
                product.ratings.splice(j,1) //here splice is just delete the rating given by client previously
                break
            }
        }

        const ratingScema = {
            userId : req.userId,
            rating
        }
        product.ratings.push(ratingScema)
        product = await product.save()

        res.json(product)
    }catch(e){
        res.status(500).json({err : e.message})
    }
})


module.exports = productRouter