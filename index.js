const express = require("express");
const mongoose = require("mongoose");

const app = express();
const PORT = process.env.PORT || 5000;

mongoose.connect("mongodb+srv://yjain_4:Yash@2017@cluster0.s5chr.gcp.mongodb.net/BlogApp?retryWrites=true&w=majority", {
    useNewUrlParser: true,
    useCreateIndex:true,
    useUnifiedTopology:true
});

const connection = mongoose.connection;
connection.once("open", ()=>{
    console.log("MongoDB Connected!");
});

app.use(express.json());

const userRoute = require("./routes/user");

app.use("/user",userRoute);

app.route("/").get((req,res)=> res.json("Hello World!"));

app.listen(PORT, ()=> console.log(`App is running on Port ${PORT}`));