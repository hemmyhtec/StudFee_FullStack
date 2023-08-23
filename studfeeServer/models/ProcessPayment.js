const mongoose = require('mongoose');

const processPaymentSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    userName: {
        type: String,
        required: true
    },
    userEmail: {
        type: String,
        required: true
    },
    departmentName: {
        type: String,
    },

    levyName: {
        type: String,
        required: true
    },
    feeAmount: {
        type: Number,
        required: true
    },
    paymentStatus: {
        type: String,
        required: true
    },
    referenceId: {
        type: String,
        required: true
    },

}, { timestamps: true });

module.exports = mongoose.model('ProcessPayments', processPaymentSchema);