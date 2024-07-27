const mongoose = require('mongoose')

const ratingScema = mongoose.Schema({
    userId: {
        type: String,
        required: true
    },
    rating: {
        type: Number,
        required: true
    }
})

//here we can't create model of this , we just create a structure 

module.exports = ratingScema