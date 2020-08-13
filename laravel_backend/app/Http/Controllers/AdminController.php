<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
        $this->middleware('super-admin')->only('store','index');
        auth()->shouldUse('web');
    }

    private function validator($data)
    {
        return Validator::make($data,[
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8'],
        ]);
    }

    public function index()
    {
        $users = User::query()->where('role','admin')->get();
        return view('users.index',compact('users'));
    }

    public function store()
    {
        $data = \request()->all();
        $validator = $this->validator($data);
        if($validator->fails()){
            return back()
                ->withErrors($validator)
                ->withInput();
        }

        try{
                User::query()->create([
                'name' => $data['name'],
                'email' => $data['email'],
                'password' =>  Hash::make($data['password']),
                'created_by' => auth()->user()->name,
                'role' => 'admin'
            ]);
            session(['msg' => 'User Created Successfully','type' => 'alert-success']);
        }catch (\Exception $exception){
            session(['msg' => $exception->getMessage(),'type' => 'alert-danger']);
        }
        return back();
    }
}
