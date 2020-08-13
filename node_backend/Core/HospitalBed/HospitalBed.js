const {Schema, model, Types} = require("mongoose");

const HospitalBedSchema = new Schema({
    hospital_id:{type:Types.ObjectId, required:true, index:true},
    department: {type: String, required: true},
    total: {type:Number, required:true},
    occupied: {type:Number, required:true},
    available: {type:Number, required:true},
},
{
    timestamps: {
        createdAt : "created_at",
        updatedAt: "updated_at"
    }
});

HospitalBedSchema.index({hospital_id:1,department:1},{unique:true});

HospitalBedSchema.pre('validate', function (next) {
    if(this.isModified('total') || this.isModified('occupied')){
        if(this.get('total') < this.get('occupied')){
            throw new Error("Occupied can not be higher then total")
        }
        this.available = this.get('total') - this.get('occupied')
    }
    next();
});

module.exports = model('Hospital_Bed',HospitalBedSchema,'hospital_beds')