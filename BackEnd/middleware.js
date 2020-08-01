const JWT = require("jsonwebtoken");
const config = require("./config");

var checkToken = (req,res,next)=>{
    var token = req.headers["authorization"];
    token.slice(7,token.length);
    if(token)
    {
        JWT.verify(token,config.key,(err,decoded)=>{
            if(err)
            {
                return res.status(403).json({
                    status:false,
                    msg:"Invalid Token"
                })
            }
            else
            {
                req.decoded=decoded;
                next();
            }
        });
    }
    else
    {
        return res.status(403).json({
            status:false,
            msg:"Bearer Token is null. Please provide a valid token"
        })
    }
};

module.exports = {
    checkToken : checkToken
}