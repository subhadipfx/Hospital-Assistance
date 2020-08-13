<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class SuperAdminController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth','super-admin'])->except('store');
        auth()->shouldUse('web');
    }

    public function store()
    {
        $data = \request()->all();
        $validator = Validator::make($data,[
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8'],
        ]);
        if($validator->fails()){
            return response(['error' => $validator->errors()],400);
        }

        try{
            User::query()->create([
                'name' => $data['name'],
                'email' => $data['email'],
                'password' =>  Hash::make($data['password']),
                'role' => 'super_admin'
            ]);
        }catch (\Exception $exception){
            return response(['error' => $exception->getMessage()]);
        }
        return response(['message' => 'User Created Successfully'],201);
    }
}
