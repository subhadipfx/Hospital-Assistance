const express = require("express");
const passport = require("passport");

const authenticatedRouter = express.Router();
authenticatedRouter.use(passport.authenticate("jwt",{session : false}));
authenticatedRouter.use('/user',require("./UserRouter").authenticated);
authenticatedRouter.use('/hospital',require('./HospitalRouter').authenticated);




const openRouter = express.Router();
openRouter.use('/user',require("./UserRouter").open);
openRouter.use('/hospital',require("./HospitalRouter").open);


exports.PROTECTED = authenticatedRouter;
exports.OPEN = openRouter;