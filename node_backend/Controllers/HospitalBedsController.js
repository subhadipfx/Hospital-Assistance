const STATUS = require("../Utils/HTTPStatus").STATUS;
const Response = require("../Utils/Response");
const HospitalBedManager = require("../Core/HospitalBed/HospitalBedManager").plugin();

exports.plugin = () => {
    return {
        create : (request, response) => {
            if(!validator(request, response)){
                return;
            }
            if(request.body.hospital_id == null){
                Response.ERROR(response,"Hospital is Invalid",STATUS.INVALID_PARAM);
                return false;
            }
            HospitalBedManager.create(request.body.hospital_id,request.body.department,request.body.total,request.body.occupied)
                .then(result => Response.SUCCESS(response,"Hospital Bed Added Successfully",STATUS.CREATED,result))
                .catch(error => Response.ERROR(response,"Error in Adding Hospital Bed",STATUS.INTERNAL_ERROR,error));
        },

        update : (request, response) => {
            if(!validator(request, response)){
                return;
            }
            if(request.body.dept_id == null){
                Response.ERROR(response,"Hospital Bed ID is Invalid",STATUS.INVALID_PARAM);
                return false;
            }
            HospitalBedManager.update(request.body.dept_id,request.body.department,request.body.total,request.body.occupied)
                .then(result => Response.SUCCESS(response,"Hospital Bed Updated Successfully",STATUS.SUCCESS,result))
                .catch(error => Response.ERROR(response,"Error in Updating Hospital Bed",STATUS.INTERNAL_ERROR,error));
        },

        delete : (request, response) => {
            if(request.query.dept_id == null){
                Response.ERROR(response,"Hospital Bed ID is Invalid",STATUS.INVALID_PARAM);
                return false;
            }
            HospitalBedManager.delete(String(request.body.dept_id))
                .then(result => Response.SUCCESS(response,"Hospital Bed Removed Successfully",STATUS.SUCCESS,result))
                .catch(error => Response.ERROR(response,"Error in Removing Hospital Bed",STATUS.INTERNAL_ERROR,error));
        }
    }
}


const validator = (request, response) => {
    if(request.body.department == null){
        Response.ERROR(response,"Department is Invalid",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.total == null){
        Response.ERROR(response,"Total no of Beds is needed",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.occupied == null){
        Response.ERROR(response,"How many beds are occupied currently",STATUS.INVALID_PARAM);
        return false;
    }
    if(request.body.total < request.body.occupied){
        Response.ERROR(response,"Total No of beds cannot be higher then Occupied",STATUS.INVALID_PARAM);
        return false;
    }
    return true;
}