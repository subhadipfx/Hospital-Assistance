const STATUS = require("../Utils/HTTPStatus").STATUS;
const Response = require("../Utils/Response");
const HospitalManager = require("../Core/Hospital/HospitalManager").plugin();

exports.plugin = () => {
    return {
        create: (request, response) => {
            if(!validator(request,response)){
                return;
            }
            if(request.body.email == null){
                Response.ERROR(response,"Email is Invalid",STATUS.INVALID_PARAM);
                return;
            }
            if(request.body.password == null){
                Response.ERROR(response,"Password is Invalid",STATUS.INVALID_PARAM);
                return false;
            }
            HospitalManager.create(request.body.name,request.body.email,request.body.password,request.body.address,request.body.pin_code,request.body.phone,request.body.location,request.body.website,request.user)
                .then(result => Response.SUCCESS(response,"Hospital Created Successfully",STATUS.CREATED,result))
                .catch(error => Response.ERROR(response,"Error in Creating Hospital",STATUS.INTERNAL_ERROR,error));
        },
        update: (request, response) => {
            if(!validator(request,response)){
                return;
            }
            if(request.body.hospital_id == null){
                Response.ERROR(response,"Hospital ID is Invalid",STATUS.INVALID_PARAM);
                return;
            }
            HospitalManager.update(request.body.hospital_id,request.body.name,request.body.address,request.body.pin_code,request.body.phone,request.body.location,request.body.website)
                .then(result => Response.SUCCESS(response,"Hospital Updated Successfully",STATUS.SUCCESS,result))
                .catch(error => Response.ERROR(response,"Error in Updating Hospital",STATUS.INTERNAL_ERROR,error));
        },
        list : (request, response) => {
            let location = null;
            if(request.query.longitude && request.query.latitude){
                let longitude = parseFloat(String(request.query.longitude));
                let latitude = parseFloat(String(request.query.latitude));
                location = {coOrdinates:{latitude, longitude}, max:15000}
            }
            if(location && request.query.max){
                location.max = parseFloat(String(request.query.max))
            }
            HospitalManager.list(location)
                .then(result => Response.SUCCESS(response,"Hospital List Fetched Successfully",STATUS.SUCCESS,result))
                .catch(error => Response.ERROR(response,"Error in Fetching Hospital",STATUS.INTERNAL_ERROR,error));
        },
        delete : (request, response) => {
            if(request.query.hospital_id == null){
                Response.ERROR(response,"Hospital ID is Invalid",STATUS.INVALID_PARAM);
                return;
            }
            HospitalManager.delete(String(request.body.hospital_id))
                .then(result => Response.SUCCESS(response,"Hospital Deleted Successfully",STATUS.SUCCESS,result))
                .catch(error => Response.ERROR(response,"Error in Deleting Hospital",STATUS.INTERNAL_ERROR,error));
        }
    }
}




const validator = (request, response) => {
    if(request.body.name == null){
        Response.ERROR(response,"Name is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.address == null){
        Response.ERROR(response,"Address is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.pin_code == null){
        Response.ERROR(response,"PinCode is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.phone == null){
        Response.ERROR(response,"Phone is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.location == null){
        Response.ERROR(response,"Location is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    return true;
}