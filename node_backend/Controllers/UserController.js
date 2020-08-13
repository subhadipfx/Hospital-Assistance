const UserManager = require("../Core/User/UserManager")
const UserRole = require("../Utils/UserRole");
const STATUS = require("../Utils/HTTPStatus").STATUS;
const Response = require("../Utils/Response");


exports.createSuperAdmin = (request,response) => {
    if(!Validator.REGISTRATION(request,response)){
        return;
    }
    UserManager.create({
        name: request.body.name, email: request.body.email,
        password: request.body.password, role: UserRole.SUPER_ADMIN
    })
        .then(result => Response.SUCCESS(response,"User Created Successfully",STATUS.CREATED,result))
        .catch(error => Response.ERROR(response,"Error in Creating User",STATUS.INTERNAL_ERROR,error));
}

exports.createAdmin = (request,response) => {
    if(!Validator.REGISTRATION(request,response)){
        return;
    }
    UserManager.create({
        name: request.body.name, email: request.body.email,
        password: request.body.password, role: UserRole.SUPER_ADMIN,
        createdBy: request.user
    })
        .then(result => Response.SUCCESS(response,"User Created Successfully",STATUS.CREATED,result))
        .catch(error => Response.ERROR(response,"Error in Creating User",STATUS.INTERNAL_ERROR,error));
}

exports.createEndUser = (request,response) => {
    if(!Validator.REGISTRATION(request,response)){
        return;
    }
    if(request.body.phone == null) {
        return Response.ERROR(response,"Phone no is Invalid",STATUS.INVALID_PARAM);
    }
    UserManager.create({
        name: request.body.name, email: request.body.email,
        password: request.body.password, role: UserRole.END_USER,
        phone: request.body.phone
    })
        .then(result => Response.SUCCESS(response,"User Created Successfully",STATUS.CREATED,result))
        .catch(error => Response.ERROR(response,"Error in Creating User",STATUS.INTERNAL_ERROR,error));
}

exports.authenticate = (request,response) => {
    if(!Validator.LOGIN(request,response)){
        return;
    }
    UserManager.authenticate(request.body.email,request.body.password)
        .then(result => Response.SUCCESS(response,"User Verified Successfully",STATUS.SUCCESS,result))
        .catch(error => Response.ERROR(response,"Error in Verifying User",STATUS.INTERNAL_ERROR,error));
}
exports.getAuthenticatedUser = (request, response) => {
    if(request.user){
        return Response.SUCCESS(response,"User Fetched Successfully",STATUS.SUCCESS,request.user)
    }else{
        return Response.ERROR(response,"Error in Fetching User",STATUS.INTERNAL_ERROR)
    }
}

exports.getSuperAdmins = (request,response) => {
    UserManager.getSuperAdmins()
        .then(result => Response.SUCCESS(response,"User Fetched Successfully",STATUS.SUCCESS,result))
        .catch(error => Response.ERROR(response,"Error in Fetching User",STATUS.INTERNAL_ERROR,error));
}

exports.getAdmins = (request,response) => {
    UserManager.getAdmins()
        .then(result => Response.SUCCESS(response,"User Fetched Successfully",STATUS.SUCCESS,result))
        .catch(error => Response.ERROR(response,"Error in Fetching User",STATUS.INTERNAL_ERROR,error));
}

exports.getHospitals = (request, response) => {
    UserManager.getHospitals(request.user)
        .then(result => Response.SUCCESS(response,"Hospitals Fetched Successfully",STATUS.SUCCESS,result))
        .catch(error => Response.ERROR(response,"Error in Fetching User",STATUS.INTERNAL_ERROR,error));
}

const Validator = {
    REGISTRATION: (request,response) => {
        if(request.body.name == null){
            Response.ERROR(response,"Name is Invalid",STATUS.INVALID_PARAM);
            return false;
        }
        if(request.body.email == null){
            Response.ERROR(response,"Email is Invalid",STATUS.INVALID_PARAM);
            return false;
        }
        if(request.body.password == null){
            Response.ERROR(response,"Password is Invalid",STATUS.INVALID_PARAM);
            return false;
        }
        return true;
    },
    LOGIN: (request,response) => {
        if(request.body.email == null){
            Response.ERROR(response,"Email is Invalid",STATUS.INVALID_PARAM);
            return false;
        }
        if(request.body.password == null){
            Response.ERROR(response,"Password is Invalid",STATUS.INVALID_PARAM);
            return false;
        }
        return true;
    }
}