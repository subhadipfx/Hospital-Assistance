require("dotenv").config();
const morgan = require("morgan");
const express = require("express");
const passport = require("passport");
const Router = require("./Routers");
const PassportStrategy = require("./Middlewares/PassportStrategy");
const HospitalBed = require("./Core/HospitalBed/HospitalBed");
const Hospital = require("./Core/Hospital/Hospital");
require("./Utils/FireBaseConnection");

const app = express()

//middleWares
//dev
app.use(morgan('dev'))


const upperBound = '1gb';
app.use(express.urlencoded({ extended: false , limit: upperBound}));
app.use(express.json({limit: upperBound}));
app.use(passport.initialize())
passport.use(PassportStrategy.JWTStrategy);
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods","*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, APP-SESSION-ID, APP-VERSION");
    next();
});

require("./Utils/MongooConnection").init();

// app.all("/",async (req,res) => {
//     console.log("here")
//     let hospitalBeds = await HospitalBed.find();
//     for (const hospitalBed of hospitalBeds) {
//         // console.log(hospitalBed.hospital_id);
//         if(hospitalBed.hospital_id){
//             let hospital = await Hospital.findOne({_id:hospitalBed.hospital_id});
//             if(hospital) {
//                 hospitalBed.hospital_id = hospital;
//                 await hospitalBed.save();
//             }
//         }
//     }
//     res.json(hospitalBeds);
// })

app.use(Router.OPEN)
app.use(Router.PROTECTED)

app.listen(process.env.PORT || 3100, () => {
    console.log("Server is Running on PORT=", process.env.PORT)
})




