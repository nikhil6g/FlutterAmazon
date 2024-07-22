//Import from another packages
const express = require('express'); //similar to dart package import
const mongoose = require('mongoose')
//Import from another files
const authRouter= require('./routes/auth')

//INIT
const PORT = 3000;
const app = express();
const DB="mongodb+srv://nikhil6g:Nikhilra12nu()@cluster0.fofahkz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"


//middleware
app.use(express.json())
app.use(authRouter);

//Creating ans api
// GET, PUT, POST, DELETE, UPDATE -> CRUD


// http://<your ip address>/hello-world   Ex:- <your ip address> => 0.0.0.0:3000
//GET
/*app.get('/hello-world', (req,res)=>{
    res.json({
        'name':'kunika',
        'beautiness':'5-star'
    })
})*/

//connections
mongoose.connect(DB).then(()=>{
    console.log('connection successful');
}).catch((e) =>{
    console.log(e)
})

app.listen(PORT,'0.0.0.0',()=>{
    console.log(`connected at port ${PORT} hello!! node`)
})