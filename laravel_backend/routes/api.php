<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//All routes are come with "api" prefix by default
Route::prefix('admin')->group(function (){
    Route::post('/create','SuperAdminController@store');
});

Route::group(['prefix' => 'auth'], function () {
    Route::get('unAuthorized', 'Auth\ApiAuthController@unAuthorized')->name('auth.Unauthorized');
    Route::post('register', 'Auth\ApiAuthController@register');
    Route::get('/', 'Auth\ApiAuthController@me');
    Route::post('/', 'Auth\ApiAuthController@authenticate');
    Route::put('/', 'Auth\ApiAuthController@logout');
});
Route::prefix('hospital')->group(function (){
    Route::get('/','HospitalController@list');
    Route::get('/{id}','HospitalController@show');
});
