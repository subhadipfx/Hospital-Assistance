
const {set, connect } = require("mongoose");
require('dotenv').config();
set('debug', true)
module.exports.init = () => {
    connect(process.env.MONGO_URI,{ useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex:true }, () => {
        console.log("connected DB");
    })
}