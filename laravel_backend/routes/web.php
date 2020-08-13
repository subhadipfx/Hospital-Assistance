<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Auth::routes(['register' => false]);
Route::get('/home', 'HomeController@index')->name('home');

//Hospital Routes
Route::prefix('hospital')->group(function (){
    Route::get('/list','HospitalController@index')->name('hospitals');
    Route::get('/','HospitalController@create')->name('register.hospital');
    Route::post('/','HospitalController@store');
    Route::prefix('bed')->group(function (){
        Route::get('dashboard/{id}/{dept?}','HospitalController@bedDashboard')->name('hospital.bed');
        Route::post('dashboard/{id}/{dept}','HospitalController@storeBedUpdate');
    });
});

Route::prefix('/admin')->group(function (){
    Route::get('/list','AdminController@index')->name('admins');
    Route::post('/','AdminController@store')->name('admin.add');
});

Route::fallback(function (){
    return response(['message' => 'error']);
});
