const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const Vehicle = new Schema({
    vehicleName:{
        type:String,
        required : true,
        unique: true
    },
    mileage:{
        type: Number,
        required : true
    },
    tankCapacity:{
        type: Number,
        required : true
    },
    fuelType:{
        type: String,
        enum : ['Petrol','Diesel','CNG'],
        default: 'Petrol'
    }
});

const UserData = new Schema({
    username:{
        type:String,
        required : true,
        unique: true
    },
    vehicles:[Vehicle]
});

module.exports = mongoose.model("UserData",UserData);