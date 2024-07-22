const express = require('express');
const User= require('../models/user')
const mongoose=require('mongoose')
const bcryptjs = require('bcryptjs')


const authRouter = express.Router();

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

module.exports=authRouter;