const mongoose = require('mongoose')
const ratingScema = require('./rating')

const productScema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true
    },
    imageUrls: [
        {
            type: String,
            required: true
        }
    ],
    quantity: {
        type: Number,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true
    },
    //ratings
    ratings: [
        ratingScema
    ]
})

const Product = mongoose.model('Product', productScema)

module.exports = Product