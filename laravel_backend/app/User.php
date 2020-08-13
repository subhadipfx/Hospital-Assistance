<?php

namespace App;

use Illuminate\Auth\Authenticatable;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;
use Jenssegers\Mongodb\Eloquent\Model;
use Illuminate\Foundation\Auth\Access\Authorizable;
use Tymon\JWTAuth\Contracts\JWTSubject;
class User extends Model implements JWTSubject,AuthenticatableContract,
    AuthorizableContract,
    CanResetPasswordContract
{
    use Authenticatable, Authorizable, CanResetPassword;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = ['name', 'email', 'password','role','created_by'];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * @inheritDoc
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * @inheritDoc
     */
    public function getJWTCustomClaims()
    {
        return [];
    }

    public function isSuperAdmin()
    {
        return $this->role == 'super_admin';
    }

    public function isAdmin(){
        return $this->role == 'admin';
    }

    public function isManagement(){
        return $this->role == 'management';
    }

    public function isEndUser(){
        return $this->role == "end_user";
    }

    public function details(){
        return $this->hasOne(Hospital::class,'email','email')->first();
    }
}
