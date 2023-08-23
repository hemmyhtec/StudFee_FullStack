require('dotenv').config

const mongoose = require('mongoose')
const Schema = mongoose.Schema
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const crypto = require('crypto')
const Token = require('../models/Token')


const secretCode = process.env.SECRET_CODE


const adminScheme = new Schema({
    fullname: {
        type: String,
    },
    profileImage: {
        type: String,
        required: false
    },
    password: {
        type: String,
        require: true,
        validate: {
            validator: (value) => {
                return value.length > 8;
            },
            message: 'Your password is less than 8 characters'
        }
    },
    isVerified: {
        type: Boolean,
        default: false
    },
    email: {
        type: String,
        unique: true,
        required: true,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: 'Please enter a valid email'
        }
    },
    type: {
        type: String,
        default: 'Admin'
    },
    resetPasswordToken: {
        type: String,
        required: false
    },

    resetPasswordExpires: {
        type: Date,
        required: false
    }
}, { timestamps: true })


//Hashing Users Password
adminScheme.pre('save', function(next) {
    var user = this;
    if(this.isModified('password') || this.isNew ) {
        bcrypt.genSalt(10, function(err, salt) {
            if(err) return next(err);
            bcrypt.hash(user.password, salt, function(err, hash) {
                if(err) return next(err);
                user.password = hash;
                next()
            })
        })
    } else {
        return  next();
    }
})


//Comparing Password
adminScheme.methods.comparePassword = function(passw, cb){
    bcrypt.compare(passw, this.password, function(err, isMatch){
        if(err) return cb(err)
        cb(null, isMatch)
    })
}

//Set Session
adminScheme.methods.generateJWT = function(){
    const today = new Date()
    const expireDate = new Date(today)

    expireDate.setDate(today.getDate() + 5)

    let payload = {
        id: this._id,
        email: this.email,
        fullname: this.fullname,
    }

    return jwt.sign(payload, secretCode, {
        expiresIn: parseInt(expireDate.getTime() / 1000, 10)
    })
}

//Reset Password token for user
adminScheme.methods.generatePasswordReset = function(){
    this.resetPasswordToken = crypto.randomBytes(20).toString('hex')
    this.resetPasswordExpires = Date.now() + 3600000; //expires in an hour
}


//Regenerate verification token for user
adminScheme.methods.generateVerificationToken = function(){
    let payload = {
        adminId: this._id,
        token: crypto.randomBytes(20).toString('hex')
    }

    return new Token(payload)
}

const Admin = mongoose.model('Admin', adminScheme)
module.exports = Admin