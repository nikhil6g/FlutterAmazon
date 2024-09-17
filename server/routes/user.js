const express = require('express')
const auth = require('../middlewares/auth')
const User = require('../models/user')
const { Product } = require('../models/product')
const Order = require('../models/order')

const userRouter = express.Router()

//for adding product to cart
userRouter.post('/api/add-to-cart',auth,async (req,res) => {
    try{
        const {id} = req.body
        const product = await Product.findById(id)

        let user = await User.findById(req.userId)

        let isProductFound = false;
        for(let i=0;i<user.cart.length;i++){
            if(user.cart[i].product._id.equals(product._id)){ //actually _id property is given by mongoose which is not string
                isProductFound = true
            }
        }
        if(isProductFound){
            let cartObject = user.cart.find((cartObject) => 
                cartObject.product._id.equals(product._id)
            )
            cartObject.quantity+=1;
        }else{
            user.cart.push({product, quantity: 1})
        }
        
        user = await user.save()
        res.json(user);
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

//for deleting product to cart
userRouter.delete('/api/remove-from-cart/:id',auth,async (req,res) => {
    try{
        const id = req.params.id
        const product = await Product.findById(id)
        //console.log(product)
        let user = await User.findById(req.userId)

        for(let i=0;i<user.cart.length;i++){
            if(user.cart[i].product._id.equals(product._id)){ //actually _id property is given by mongoose which is not string
                if(user.cart[i].quantity == 1){
                    user.cart.splice(i,1)
                }else{
                    user.cart[i].quantity -= 1
                }
            }
        }
        user = await user.save()
        res.json(user);
    }catch(e){
        res.status(500).json({err : e.message})
    }

})


//save user address
userRouter.post('/api/save-user-address',auth,async (req,res) => {
    try{
        const {address} = req.body
        let user =await User.findById(req.userId)
        user.address=address
        user = await user.save()
        res.json(user);
    }catch(e){
        res.status(500).json({err : e.message})
    }
})

//order product
userRouter.post('/api/order',auth,async(req,res)=>{
    try{
        const {cart,totalPrice,address} = req.body

        for(let i=0;i<cart.length;i++){
            let product = await Product.findById(cart[i].product.id);
            if(product.quantity<cart[i].quantity){
                return res.status(400).json({msg: `${product.name} is out of stock`})
            }
        }

        let products = [];
        for(let i=0;i<cart.length;i++){
            let product = await Product.findById(cart[i].product.id);
            product.quantity-=cart[i].quantity;
            products.push({product,quantity: cart[i].quantity})
            await product.save();
        }

        let user = await User.findById(req.userId)
        user.cart = []
        user = await user.save();

        let order = new Order({
            products,
            totalPrice,
            address,
            userId: req.userId,
            orderAt: new Date().getMilliseconds(),
        })

        order = await order.save()
        res.json(order)

    }catch(e){
        res.status(500).json({err : e.message})
    }
})

module.exports = userRouter