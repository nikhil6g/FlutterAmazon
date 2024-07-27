const express = require('express')
const auth = require('../middlewares/auth');
const {Product} = require('../models/product');


const productRouter = express.Router();

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

//get deal of the products
productRouter.get('/api/deal-of-day',auth,async (req,res)=>{
    try{
        let products = await Product.find({})

        //sort products based on total ratings in descending order
        products.sort((pdt1,pdt2)=>{
            let pdt1Sum=0,pdt2Sum=0;

            //calculate total rating of product1 
            for(let j=0;j<pdt1.ratings.length;j++){
                pdt1Sum+=pdt1.ratings[j].rating
            }

            //calculate total rating of product2
            for(let j=0;j<pdt2.ratings.length;j++){
                pdt2Sum+=pdt2.ratings[j].rating
            }
            return pdt1Sum<pdt2Sum ? 1 : -1
        })

        res.json(products[0])
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

module.exports = productRouter