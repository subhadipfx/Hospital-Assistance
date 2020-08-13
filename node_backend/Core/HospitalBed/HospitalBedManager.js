const Q = require("q");
const HospitalBed = require("./HospitalBed");
const HospitalManager = require("../Hospital/HospitalManager").plugin();
exports.plugin = () => {
    return {
        create : (hospital_id,department,total,occupied) => {
            const defer = Q.defer();
            HospitalManager.findByID(hospital_id)
                .then(hospital => {
                    if(!hospital) throw new Error("Invalid Hospital ID");
                    let hospitalBed = new HospitalBed();
                    hospitalBed.hospital_id = hospital;
                    hospitalBed.department= department;
                    hospitalBed.total = total;
                    hospitalBed.occupied = occupied;
                    return [hospital,hospitalBed.save()]
                })
                .spread((hospital,hospitalBed) => {
                    hospital.lastUpdatedAt = new Date();
                    return [hospital.save(),hospitalBed];
                })
                .spread((hospital,hospitalBed) => {
                    return hospitalBed;
                })
                .then(hospitalBed => defer.resolve(hospitalBed))
                .catch(error => defer.reject(error.stack))
                .done();
            return defer.promise;
        },
        update : (id,department,total,occupied) => {
            console.log(id)
            const defer = Q.defer();
            HospitalBed.findOne({_id:id})
                .then(hospitalBed => {
                    if(!hospitalBed) throw new Error("Invalid HospitalBed Type")
                    hospitalBed.department = department;
                    hospitalBed.total = total;
                    hospitalBed.occupied = occupied;
                    return hospitalBed.save();
                })
                .then(hospitalBed => defer.resolve(hospitalBed))
                .catch(error => defer.reject(error.stack));
            return defer.promise;
        },
        delete: (id) => {
            const defer = Q.defer();
            HospitalBed.deleteOne({_id:id})
                .then( _ => defer.resolve())
                .catch(error => defer.reject(error.stack));
            return defer.promise;
        }
    }
}