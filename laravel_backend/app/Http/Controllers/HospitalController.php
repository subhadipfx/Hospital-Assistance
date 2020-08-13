<?php

namespace App\Http\Controllers;

use App\Hospital;
use App\HospitalBed;
use App\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class HospitalController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth')->except('list','show');
        auth()->shouldUse('web');
    }

    private function validator($data)
    {
        return Validator::make($data, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8'],
            'address' => ['required','string'],
            'longitude' => ['required','string'],
            'latitude' => ['required','string'],
            'pincode' => ['required','numeric'],
            'phone' => ['required','numeric']
        ]);
    }

    public function index()
    {
        $users = User::query()->where('role','management');
        if(auth()->user()->isAdmin()){
            $users = $users->where('created_by',auth()->user()->name);
        }
        $users = $users->get();
        return view('hospital.index',compact('users'));
    }

    public function create()
    {
        return view('auth.register_hospital');
    }

    public function store()
    {
        $data = \request()->all();
        $validator = $this->validator($data);
        if($validator->fails()) {
            return back()
                ->withErrors($validator)
                ->withInput();
        }
        $user = null;
        $hospital = null;
        $error = false;
        try{
           $user = User::query()->create([
                'name' => $data['name'],
                'email' => $data['email'],
                'created_by' => \auth()->user()->name,
                'role' => 'management',
                'password' => Hash::make($data['password']),
            ]);
            $hospital = Hospital::query()->create([
                'name' => $data['name'],
                'email' => $data['email'],
                'address' => $data['address'],
                'location' => ['type' => 'Point', 'coordinates' => [ (double)$data['longitude'], (double)$data['latitude']]],
                'area_pin_code' => $data['pincode'],
                'phone' => $data['phone'],
            ]);
        }catch (\Exception $exception){
//            dd($exception);
            $error = true;
            session(['error' => $exception->getMessage()]);
        }
        if($error){
            try {
                isset($user) ? $user->delete() : null;
                isset($hospital) ?  $hospital->delete() : null;
            } catch (\Exception $e) {
            }
            return back()->withInput();
        }
        return  redirect()->route('hospitals');
    }

    public function bedDashboard($id,$dept = null)
    {
        if(!isset($dept)){
            return redirect("/hospital/bed/dashboard/$id/icu");
        }
        $hospital = Hospital::query()->where('_id',$id)->first();
        if(!isset($hospital)){
            session(['error' => 'No Hospital Found with this id']);
            return  back();
        }
        $data = $hospital->beds_department($dept);
        return view('hospital.bed_dashboard',compact('data','dept','id'));
    }

    public function storeBedUpdate($id,$dept){
        if(!is_numeric(\request()->newValue) || (int) \request()->newValue < 0){
            session(['error' => 'Count of bed must be a valid positive number']);
            return response(['error' => 'Count of bed must be a valid positive number'],400);
        }
        $type = \request()->type;
        $newValue = (int) \request()->newValue;
        $hospital = Hospital::query()->where('_id',$id)->first();
        $data = $hospital->beds_department($dept);
         if($type == 'total'){
            $total = $newValue;
            $occupied = isset($data->occupied) ?  $data->occupied : 0;
            $available = $total - $occupied;
         }else if($type == 'occupied'){
            if(isset($data->total) && $data->total > 0){
                $total = $data->total;
                $available = $total - $newValue;
            }else{
                $available = 0;
                $total = $newValue;
            }
            if($newValue > $total){
                session(['error' => 'Occupied count can not be higher then total no of beds']);
                return response(['error' => 'Occupied count can not be higher then total no of beds'],400);
            }
            $occupied = $newValue;
        }else{
             session(['error' => 'Invalid Input']);
            return response(['error' => 'Invalid Input'],400);
        }
        $status = HospitalBed::query()->updateOrCreate(['hospital_id' => $hospital->id,'department' => $dept],
            ['total' => $total, 'available' => $available, 'occupied' => $occupied]);
        if($status){
            session(['success' => 'Updated Successfully']);
            return response(['success' => 'Updated Successfully'],200);
        }
        session(['error' => 'Data Updated Failed']);
        return response(['error' => 'Data Updated Failed'],500);
    }

    public function list()
    {
        $hospital_list = Hospital::with('beds_all');
        if(request()->has('longitude') && request()->has('latitude')){
            $hospital_list = $hospital_list->where('location','near',[
                '$geometry' => [
                    'type' => 'Point',
                    'coordinates' => [
                        (int) request()->longitude,
                        (int) request()->latitude
                    ]
                ],
                '$maxDistance' => 15000
            ]);
        }
        $hospital_list = $hospital_list->get();
        $hospital_list = $hospital_list->filter(function ($hospital){
           return count($hospital->beds_all) > 0;
        })->values();
        return response(['docs' => $hospital_list,'count' => $hospital_list->count()],200);
    }

    public function show($id)
    {
        $hospital = Hospital::with('beds_all')->find($id);
        if($hospital){
            return response(['data' => $hospital],200);
        }else{
            return response(['error' => 'No Hospital Found with this id'],404);
        }
    }
}
