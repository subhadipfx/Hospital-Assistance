const express = require("express");
const AuthorizationCheck = require("../Middlewares/AuthorizationCheck")
const UserController = require("../Controllers/UserController");
const authenticatedRouter = express.Router();
const openRouter = express.Router();

authenticatedRouter.route("/super-admin")
    .get(AuthorizationCheck.isSUPER_ADMIN,UserController.getSuperAdmins)
    .post(AuthorizationCheck.isSUPER_ADMIN,UserController.createSuperAdmin);

authenticatedRouter.route("/admin")
    .get(AuthorizationCheck.isSUPER_ADMIN,UserController.getAdmins)
    .post(AuthorizationCheck.isSUPER_ADMIN,UserController.createAdmin);

authenticatedRouter.route("/hospital")
    .get(AuthorizationCheck.isADMIN,UserController.getHospitals);

authenticatedRouter.route('/')
    .get(UserController.getAuthenticatedUser);


openRouter.route('/')
    .post(UserController.createEndUser);

openRouter.route('/authenticate')
    .post(UserController.authenticate);

exports.authenticated = authenticatedRouter;
exports.open = openRouter;
// exports = {
//     authenticated : openRouter,
//     open : openRouter,
// }