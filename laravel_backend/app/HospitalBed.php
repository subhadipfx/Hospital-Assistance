<?php

namespace App;

use Jenssegers\Mongodb\Eloquent\Model;

class HospitalBed extends Model
{
    protected $table = 'hospital_beds';
    protected $fillable = ['hospital_id','department','total','occupied','available'];
}
