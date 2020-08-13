const Q = require("q");

const User = require("./User");
const UserRole = require("../../Utils/UserRole");

exports.create = (userData) => {
    const {name,email,password,role, phone,createdBy} = userData;
    const defer = Q.defer();
    let user = new User();
    user.name = name;
    user.email = email;
    user.password = password;
    user.role = role;
    if(phone){
        user.phone = phone;
    }
    if(createdBy){
        user.createdBy = createdBy;
    }
    user.save()
        .then(user => defer.resolve({user:user, access_toke:user.getToken()}))
        .catch(error => defer.reject(error.message))
    return defer.promise;
}

exports.authenticate = (email, password) => {
    const defer = Q.defer();
    this.findByEmail(email)
        .then(user => {
            if(!user) throw new Error("User Not Found")
            return user.authenticate(password)
        })
        .then(result => defer.resolve(result))
        .catch(error => defer.reject(error.message))
    return defer.promise;
}

exports.getSuperAdmins = () => {
    const defer = Q.defer();
    User.find({role: UserRole.SUPER_ADMIN})
        .then(users => defer.resolve(users))
        .catch(error => defer.reject(error))
    return defer.promise;
}

exports.getAdmins = () => {
    const defer = Q.defer();
    User.find({role: UserRole.ADMIN}).populate('createdBy','name')
        .then(users => defer.resolve(users))
        .catch(error => defer.reject(error))
    return defer.promise;
}

exports.getHospitals = (user) => {
    const defer = Q.defer();
    let query;
    if(user.role === UserRole.SUPER_ADMIN){
        query = {role: UserRole.MANAGEMENT}
    }else{
        query = {role: UserRole.MANAGEMENT, created_by: {$in:[user._id,user.name]}}
    }
    User.find(query).populate('createdBy','name')
        .then(users => defer.resolve(users))
        .catch(error => defer.reject(error))
    return defer.promise;
}

exports.findByEmail = (email) => {
    const defer = Q.defer();
    User.findOne({email})
        .then(users => defer.resolve(users))
        .catch(error => defer.reject(error.stack))
    return defer.promise;
}
