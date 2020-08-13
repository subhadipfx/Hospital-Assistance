const express = require("express");
const AuthorizationCheck = require("../Middlewares/AuthorizationCheck");
const authenticatedRouter = express.Router();
const HospitalBedController = require("../Controllers/HospitalBedsController").plugin();

authenticatedRouter.use(AuthorizationCheck.isMANAGEMENT)
authenticatedRouter.route('/')
    .post(HospitalBedController.create)
    .put(HospitalBedController.update)
    .delete(HospitalBedController.delete);


exports.authenticated = authenticatedRouter;