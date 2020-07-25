const express = require("express");
const config = require("../config");
const JWT = require("jsonwebtoken");
const middleware = require("../middleware");
const app = express();
const User = require("../models/users.model");

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
                var token = JWT.sign({username:req.body.username},config.key,{
                    expiresIn: "24h"
                });
                res.status(200).json({
                    token: token,
                    msg:"Successfully Logged In"
                })
            }
            else
            {
                res.status(403).json("Incorrect Password");
            }
        });
});

router.route("/get/:username").get(middleware.checkToken,(req,res)=>{
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

router.route("/update/:username").patch(middleware.checkToken,(req,res)=>{
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

router.route("/delete/:username").delete(middleware.checkToken,(req,res)=>{
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