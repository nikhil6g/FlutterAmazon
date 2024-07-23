const express = require('express');
const User= require('../models/user')
const mongoose=require('mongoose')
const bcryptjs = require('bcryptjs')
const jwt = require('jsonwebtoken')
const auth = require('../middlewares/auth')
const authRouter = express.Router();

//for sign up
authRouter.post('/api/signup',async(req,res)=>{
    try{
        //get the data from client
        const {name, email, password} = req.body

        //Check atleast one data in database is same with it or not
        const existingUser =await User.findOne({email}); // it is short hand syntax of 'email' : email
        if(existingUser){ //existingUser is null or not
            return res.status(400).json({msg:'User with same email already exists'})
        }

        //encrypting password
        const hashedPassword = await bcryptjs.hash(password,8);

        //post that data in database
        let user = new User({
            email,
            password: hashedPassword,  //order does not matter
            name,    
        })
        user =await user.save();
        
        //return data to the client
        res.json(user);
    }catch(e){
        res.status(500).json({
            error: e.message,
        })
    }
})

//for sign in
authRouter.post('/api/signin',async(req,res)=>{
    try{
        //get the data from client
        const {email, password} = req.body

        //Check a data in database present or not
        const user =await User.findOne({email}); // it is short hand syntax of 'email' : email
        if(!user){ //existingUser is null or not
            return res.status(400).json({msg:'User with this email does not exists!'})
        }
        
        //Check if password is matching or not
        const isMatch = await bcryptjs.compare(password,user.password)
        if(!isMatch){
            return res.status(400).json({msg:'Incorrect password!!'})
        }

        const token = jwt.sign({id: user._id},"passwordKey");
        res.json({token,...user._doc}) //... for object destructuring
    }catch(e){
        res.status(500).json({
            error: e.message,
        })
    }
})

authRouter.post("/tokenIsValid",async(req,res)=>{
    try{
        const token = req.header('x-auth-token');

        if(!token) return res.json(false)
        
        const isVerified=jwt.verify(token, 'passwordKey');

        if(!isVerified){
            return res.json(false)
        }

        const user = await User.findById(isVerified.id)

        if(!user){
            return res.json(false)
        }
        res.json(true)
    }catch(e){
        res.status(500).json({
            error: e.message
        })
    }
})

//get user data
authRouter.get('/',auth,async (req,res)=>{
    const user = await User.findById(req.userId)
    res.json({...user._doc, token: req.token})
})
module.exports=authRouter;