const express = require("express");
const AuthorizationCheck = require("../Middlewares/AuthorizationCheck");
const authenticatedRouter = express.Router();
const openRouter = express.Router();
const HospitalController = require("../Controllers/HospitalController").plugin();
const HospitalBedRouter = require("./HospitalBedRouter");

authenticatedRouter.route('/')
    .post(AuthorizationCheck.isADMIN,HospitalController.create)
    .put(AuthorizationCheck.isMANAGEMENT,HospitalController.update)
    .delete(AuthorizationCheck.isADMIN,HospitalController.delete);

authenticatedRouter.use('/bed',HospitalBedRouter.authenticated)

openRouter.route('/').get(HospitalController.list)

exports.authenticated = authenticatedRouter;
exports.open = openRouter;
