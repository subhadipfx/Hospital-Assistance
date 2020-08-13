const UserRole = require("../Utils/UserRole");
const Response = require("../Utils/Response");
const STATUS = require("../Utils/HTTPStatus").STATUS;

exports.isSUPER_ADMIN = (request, response, next)  => {
    if(request.user.role === UserRole.SUPER_ADMIN){
        next()
    }else{
        return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
    }
}

exports.isADMIN = (request, response, next)  => {
    if(request.user.role === UserRole.SUPER_ADMIN || request.user.role === UserRole.ADMIN){
        next()
    }else{
        return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
    }
}

exports.isMANAGEMENT = (request, response, next)  => {
    if(request.user.role !== UserRole.END_USER){
        next()
    }else{
        return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
    }
}

exports.isEND_USER = (request, response, next)  => {
    if(request.user.role !== UserRole.MANAGEMENT){
        next()
    }else{
        return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
    }
}



// exports = {
//     isSUPER_ADMIN : (request, response, next)  => {
//         if(request.user.role === UserRole.SUPER_ADMIN){
//             next()
//         }else{
//            return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
//         }
//     },
//     isADMIN : (request, response, next)  => {
//         if(request.user.role === UserRole.SUPER_ADMIN || request.user.role === UserRole.ADMIN){
//             next()
//         }else{
//             return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
//         }
//     },
//     isMANAGEMENT: (request, response, next)  => {
//         if(request.user.role !== UserRole.END_USER){
//             next()
//         }else{
//             return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
//         }
//     },
//     isEND_USER: (request, response, next)  => {
//         if(request.user.role !== UserRole.MANAGEMENT){
//             next()
//         }else{
//             return Response.ERROR(response,"You Are Not Authorized",STATUS.UNAUTHORIZED);
//         }
//     }
// }