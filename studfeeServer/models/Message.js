const mongoose = require('mongoose')

const messageSchema = new mongoose.Schema({
    sender: {
        type: String, 
        required: true
    }, 
    receiver: {
        type: String, 
        required: true
    }, 
    message: {
        type: String, 
        required: true
    }, 
    media: {
        type: String, 
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

module.exports = mongoose.model('Message', messageSchema );