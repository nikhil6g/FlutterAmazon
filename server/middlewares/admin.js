const jwt = require('jsonwebtoken')
const User = require('../models/user');

const admin = async (req,res,next) => {
    try{
        const token = req.header('x-auth-token');
        if(!token) return res.status(401).json({msg: 'No token, acess denied'})

        const isVerified=jwt.verify(token, 'passwordKey');

        if(!isVerified){
            return res.status(401).json({msg: 'token verification failed, authorization denied'})
        }
        
        const user = await User.findById(isVerified.id)

        //checking user is admin or not
        if(user.type == 'user'|| user.type == 'seller'){
            return res.status(401).json({msg : 'You are not a admin'});
        }

        req.userId = isVerified.id;
        req.token = token;
        next()
    }catch(e){
        res.status(400).json({error: e.message})
    }
}

module.exports = admin