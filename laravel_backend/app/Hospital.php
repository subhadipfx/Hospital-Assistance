<?php

namespace App;

use Jenssegers\Mongodb\Eloquent\Model;

class Hospital extends Model
{
    protected $table = 'hospitals';
    protected $guarded = [];

    public function beds_all(){
        return $this->hasMany(HospitalBed::class,'hospital_id','_id');
    }
    public function beds_department($dept){
        return $this->hasOne(HospitalBed::class,'hospital_id','_id')->where('department',$dept)->first();
    }
}
