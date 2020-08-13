
const {Strategy,ExtractJwt } = require("passport-jwt");
const User = require("../Core/User/User");

const opts = {
    jwtFromRequest: ExtractJwt.fromExtractors([ExtractJwt.fromAuthHeaderAsBearerToken(), ExtractJwt.fromUrlQueryParameter('token')]),
    secretOrKey: process.env.JWT_KEY
}
// console.log(opts);
exports.JWTStrategy = new Strategy(opts, (payload, done) => {
    User.findOne({_id: payload.user_id})
        .then(user => {
            if(user) return done(null, user)
            return done(null,false)
        })
        .catch(error => {
            console.log(error)
            done(error)
        })
})