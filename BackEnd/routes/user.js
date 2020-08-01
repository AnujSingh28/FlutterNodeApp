const express = require("express");
const app = express();
const User = require("../models/users.model");
const UserData = require("../models/userdata.model");
//const config = require("../config");
//const JWT = require("jsonwebtoken");
//const middleware = require("../middleware");
const router = express.Router();

router.route("/register").post((req,res)=>{
    const user = new User({
        username : req.body.username,
        password : req.body.password,
        email : req.body.email
    });
    user
    .save()
    .then(()=>{
        res.status(200).json("User Registered");
    })
    .catch((err)=>{
        res.status(403).json({msg : err});
    });
});

router.route("/checkusername/:username").get((req, res) => {
    User.findOne({ username: req.params.username }, (err, result) => {
      if (err) return res.status(500).json({ msg: err });
      if (result !== null) {
        return res.json({
          Status: true,
        });
      } else
        return res.json({
          Status: false,
        });
    });
  });

router.route("/login").post((req,res)=>{
    User.findOne(
        {username: req.body.username},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            if(result==null)
            return res.status(403).json("Incorrect Username");
            if(result.password == req.body.password)
            {
                //var token = JWT.sign({username:req.body.username},config.key,{
                    //expiresIn: "24h"
                //});
                res.status(200).json({
                    //token: token,
                    msg:"Successfully Logged In"
                })
            }
            else
            {
                res.status(403).json("Incorrect Password");
            }
        });
});

router.route("/data/:username").get((req,res)=>{
    UserData.findOne(
        {username: req.params.username},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                vehicles : result,
                username : req.params.username
            }
            return res.json(msg);
        });
});

router.route("/data/:username").patch((req,res)=>{
    UserData.findOneAndUpdate(
        {
            username: req.params.username,
        },
        {$push : {vehicles : [{
            vehicleName : req.body.vehicleName,
            mileage : req.body.mileage,
            tankCapacity : req.body.tankCapacity,
            fuelType : req.body.fuelType
        }]}},{new : true, upsert: true},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                msg : "Vehicle Added Successfully",
                username : req.params.username
            }
            return res.json(msg);
        });
});

router.route("/data/:username/:id").delete((req,res)=>{
    UserData.findOneAndUpdate(
        {
            username: req.params.username,
        },
        {$pull : {vehicles:{_id :req.params.id}}},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                msg : "Vehicle Deleted Successfully",
                username : req.params.username
            }
            return res.json(msg);
        });
});

router.route("/get/:username").get((req,res)=>{
    User.findOne(
        {username: req.params.username},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                UserData : result,
                username : req.params.username
            }
            return res.json(msg);
        });
});

router.route("/update/:username").patch((req,res)=>{
    User.findOneAndUpdate(
        {username: req.params.username},
        {$set : {password : req.body.password}},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                msg : "Password Successfully Updated",
                username : req.params.username
            }
            return res.json(msg);
        });
});

router.route("/delete/:username").delete((req,res)=>{
    User.findOneAndDelete(
        {username: req.params.username},
        (err,result) =>{
            if(err)
            return res.status(500).json({msg: err});
            const msg = {
                msg : "User Deleted",
                username : req.params.username
            }
            return res.json(msg);
        });
});



module.exports = router;