const mongoose = require('mongoose');
const { productScema } = require('./product');

const orderSchema = mongoose.Schema({
    products: [
        {
            product : productScema,
            quantity: {
                type: Number,
                required: true
            }
        }
    ],
    totalPrice: {
        type: Number,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    userId: {
        type: String,
        required: true
    },
    orderAt: {
        type: Number,
        required: true,
    },
    status: {
        type: Number,
        default: 0
    }
});

const Order = mongoose.model('order', orderSchema);
module.exports = Order