require('dotenv').config()
const mongoose = require('mongoose')

const connUri = process.env.MONGODB_URI


const connectDB = async() => {
    mongoose.Promise = global.Promise
    mongoose.set('strictQuery', false)
    mongoose.connect(connUri, {useNewUrlParser: true, useUnifiedTopology: true })

    const connection = mongoose.connection
    connection.once('open', ()=> console.log('MongoDB -- Dabase Connection Established Successfully!') )

    connection.on('error', (err) => {
        console.log('MongoDB -- Connection error. please try again' + err)
        process.exit();
    })

}

module.exports = connectDB;