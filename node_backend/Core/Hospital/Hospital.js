const {Schema, model, Types} = require("mongoose")


const GeoSchema = new Schema({
    type: {
        type: String,
        enum: ['Point'],
        required: true
    },
    coordinates: {
        type: [Number],
        required: true
    }
})

const HospitalSchema = new Schema({
    name: {type:String, required:[true, "A valid name is required"]},
    user_id: {type:Types.ObjectId,required:[true,"A valid User ID is required"], index:true},
    address: {type: String, required:[true, "A valid Address is required"]},
    area_pin_code: {type:String, required:true},
    phone:{type:String, required:[true, "Please add a valid Phone Number"]},
    website:String,
    location: { type:GeoSchema, required:true, index: '2dsphere'},
    lastUpdatedAt:{type:Date} //when beds are last updated
},
    {
    timestamps: {
        createdAt : "created_at",
        updatedAt: "updated_at"
    }
});

module.exports = model('Hospital',HospitalSchema,'hospitals')