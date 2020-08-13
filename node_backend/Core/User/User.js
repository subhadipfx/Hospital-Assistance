const {Schema, model,Types} = require("mongoose")
const {hashSync,compareSync} = require("bcrypt")
const Q = require("q");
const jwt = require("jsonwebtoken");
const expiresIn = '1d';

const UserSchema = new Schema({
    name: {type:String, required:[true, "A valid Name is Required"]},
    email: {type: String, required: [true, "A valid Email is Required"], unique:true, lowercase:true, index:true},
    phone: String,
    password: {type: String, required:[true, "A valid Password is Required"]},
    role: {type: String, required:[true, "A valid Role is required"]},
    createdBy: {type:Types.ObjectId, index: true},
    last_login:Date
},{
    timestamps: {
        createdAt : "created_at",
        updatedAt: "updated_at"
    }
});

UserSchema.set('toJSON', {
    transform: function (doc, ret, options) {
        delete ret.password;
        return ret;
    }
})

UserSchema.methods.authenticate = function (password){
    let defer= Q.defer();
    const user = this;
    const hashed_password = user.password;
    if (!compareSync(password, hashed_password)) {
        const options = { expiresIn: expiresIn };
        const token = jwt.sign({ user_id: user.id }, process.env.JWT_KEY, options);
        user.last_login = new Date();
        user.save()
            .then(user => defer.resolve({user: user,access_token:token}))
            .catch(error => {
                console.log(error)
                defer.reject()
            });
    } else {
        defer.reject();
    }
    return defer.promise;
};

UserSchema.methods.getToken = function () {
    const options = { expiresIn: expiresIn };
    return  jwt.sign({ user_id: this.id }, process.env.JWT_KEY, options);
};



UserSchema.pre('save',function (next) {
    if(this.isModified('password')){
        this.password = hashSync(this.get('password'),10);
    }
    next();
})

UserSchema.post('save', function(error, doc, next) {
    if (error.name === 'MongoError' && error.code === 11000) {
        next(new Error('This Email is Already Registered'));
    } else {
        next(error);
    }
})


module.exports = model('User',UserSchema,'users');