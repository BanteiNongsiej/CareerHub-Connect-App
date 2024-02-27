<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\UserInfoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::controller(AuthController::class)->group(function(){
    Route::post('/register', 'Register');
    Route::post('/login', 'Login');
});
Route::controller(UserInfoController::class)->group(function(){
    Route::get('/dashboard/{id}','UserDetails');
});
Route::controller(JobController::class)->group(function(){
    Route::post('/dashboard/job/insert','insert');
    Route::get('/dashboard/job/show/{job_id}','show');
});