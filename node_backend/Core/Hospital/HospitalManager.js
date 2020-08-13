const Q = require("q");
const { GetLatLngByAddress } = require('@geocoder-free/google');
const geoLib = require("geolib");
const Hospital = require("./Hospital");
const HospitalBed = require("../HospitalBed/HospitalBed");
const User = require("../User/User");
const UserRole = require("../../Utils/UserRole");

exports.plugin = () => {
    return {
        create : async (name, email, password, address, pinCode, phone, coOrdinates, website, createdBy) => {
            const defer = Q.defer();
            let opts = null;
            let hospital = null;
            User.startSession()
                .then( session => {
                    opts = { session };
                    session.startTransaction();
                    return User.create([{name:name, email:email, password:password,role: UserRole.MANAGEMENT, createdBy:createdBy}],opts)
                })
                .then(user => {
                    return Hospital.create([{
                        name:name, user_id:user[0], address:address, area_pin_code:pinCode, phone:phone, website:website,
                        location:{
                            type: "Point",
                            coordinates: coOrdinates
                        }
                    }],opts);
                })
                .then(_hospital => {
                    console.log(_hospital)
                    hospital = _hospital;
                    return opts.session.commitTransaction();
                })
                .then(() => {
                    opts.session.endSession();
                    defer.resolve(hospital);
                })
                .catch(async error => {
                    console.log(error);
                    await opts.session.abortTransaction();
                    opts.session.endSession();
                })
            return defer.promise;
        },

        update: (id,name, address, pinCode, phone, coOrdinates, website) => {
            const defer = Q.defer();
            let opts = null;
            let hospital = null;
            Hospital.startSession()
                .then( session => {
                    opts = { session };
                    session.startTransaction();
                    return Hospital.findOne({_id:id}).session(session);
                })
                .then(_hospital => {
                    _hospital.name = name;
                    _hospital.address = address;
                    _hospital.pinCode = pinCode;
                    _hospital.phone = phone;
                    _hospital.website = website;
                    _hospital.location = {type: "Point", coordinates: coOrdinates};
                    return _hospital.save();
                })
                .then(_hospital => {
                    console.log(_hospital)
                    hospital = _hospital;
                    console.log(hospital.user_id)
                    return User.findOne({_id:hospital.user_id}).session(opts.session);
                })
                .then(user => {
                    user.name = name;
                    return user.save();
                })
                .then(_ => opts.session.commitTransaction())
                .then(() => {
                    opts.session.endSession();
                    defer.resolve(hospital);
                })
                .catch(async error => {
                    console.log(error);
                    await opts.session.abortTransaction();
                    opts.session.endSession();
                })
            return defer.promise;
        },

        list: (location = null) => {
            const defer = Q.defer();
            // console.log(location)
            if(location){
                // Q.all([GetLatLngByAddress('735, sahid hemanta kumar basu sarani'),GetLatLngByAddress('Nagerbazar Flyover, Dum Dum, Kolkata, West Bengal 700080')])
                // Hospital
                //     .find({
                //         location: {
                //             $geoWithin: {
                //                 $centerSphere:[location.coOrdinates, 100/3963.2]
                //             }
                //         }
                //     })
                    // .aggregate().project({_id:0,location:"$location.coordinates"})
                    // .where('location')
                    // .near({ center: location.coOrdinates, spherical: true })
                //     .then( list => {
                //         defer.resolve({docs:list, count:list.length})
                //     })
                //     .catch(error => {
                //         console.log(error);
                //     })
                Hospital.aggregate([
                    {
                        $geoNear: {
                            near : { type: "Point", coordinates: location.coOrdinates},
                            distanceField: "dist.calculated",
                            maxDistance: location.max,
                            spherical: true
                        }
                    },
                    {
                        $project : {name:1,email:1,address:1,phone:1,dist_calculated:"$dist.calculated",
                            location:{ latitude: { $arrayElemAt: ["$location.coordinates",0]}, longitude: { $arrayElemAt: ["$location.coordinates",1]}}, lastUpdatedAt:1, website:1}
                    },
                    {
                        $lookup : {
                            from: 'hospital_beds',
                            localField: '_id',
                            foreignField: 'hospital_id',
                            as: "beds"
                        }
                    },
                    {
                        $match : { beds: {$ne : []}}
                    }
                ])
                .then( list => {
                    list.sort((a,b) => {
                        // console.log(a.name,geoLib.getPreciseDistance(location.coOrdinates, a.location,0.01))
                        // console.log(b.name,geoLib.getPreciseDistance(location.coOrdinates, b.location))
                        if(geoLib.getPreciseDistance(location.coOrdinates, a.location) < geoLib.getPreciseDistance(location.coOrdinates, b.location)){
                            return -1;
                        }
                        if(geoLib.getPreciseDistance(location.coOrdinates, a.location) > geoLib.getPreciseDistance(location.coOrdinates, b.location)){
                            return 1;
                        }
                        return 0;
                        // console.log(a.location)
                    })
                    console.log()
                    console.log("-------------------------------------")
                    list = list.map(item => {
                        item.dist_calculated = geoLib.getPreciseDistance(location.coOrdinates, item.location, 0.01)
                        console.log(item.name,"=",item.dist_calculated)
                        return item;
                    })
                    console.log("----------------------------------------")
                    console.log()
                    // console.log(location.coOrdinates)
                    // console.log(list)
                    // let l1 = list[0];
                    // let l2 = list[1];
                    // let data = geoLib.getDistance(
                    //     { latitude: l1[0], longitude: l1[1] },
                    //     { latitude: l2[0], longitude: l2[1] }
                    // )
                    // console.log(l1,l2)
                    // console.log(data)
                    // list = list.map(item => {
                    //     return {latitude: item.location[0],longitude:item.location[1]}
                    // })
                    // console.log(list)
                    // list = sortByDistance(location.coOrdinates,list,{
                    //     xName: 'latitude',
                    //     yName: 'longitude'
                    // })
                    // console.log(list)
                    defer.resolve({docs:list, count:list.length})
                })
                .catch(error => {
                    console.log(error);
                    defer.reject(error.stack);
                })
            }else{
                Hospital.aggregate([
                    {
                        $project : {name:1,email:1,address:1,phone:1, location:1, lastUpdatedAt:1, website:1}
                    },
                    {
                        $lookup : {
                            from: 'hospital_beds',
                            localField: '_id',
                            foreignField: 'hospital_id',
                            as: "beds"
                        }
                    }
                ])
                    .then( list => {
                        defer.resolve({docs:list, count:list.length})
                    })
                    .catch(error => {
                        console.log(error);
                    })
            }
            return defer.promise;
        },
        delete: (id) => {
            const defer = Q.defer();
            let session = null;
            Hospital.startSession()
                .then(_session => {
                    session = _session;
                    return Hospital.findOne({_id:id});
                })
                .then(hospital => {
                    session.startTransaction();
                    return Q.all([
                        HospitalBed.deleteMany({hospital_id:hospital._id}).session(session),
                        User.deleteOne({_id:hospital.user_id}).session(session),
                        Hospital.deleteOne({_id:id}).session(session)
                    ])
                })
                .then( _ => session.commitTransaction())
                .then( _ => {
                    session.endSession()
                    defer.resolve()
                })
                .catch(async error => {
                    console.log(error);
                    await session.abortTransaction();
                    session.endSession();
                });
            return defer.promise;
        },

        findByID: (id) => {
            const defer = Q.defer();
            Hospital.findOne({_id:id})
                .exec()
                .then((hospital) => defer.resolve(hospital))
                .catch(error => defer.reject(error.stack));
            return defer.promise;
        }
    }
}