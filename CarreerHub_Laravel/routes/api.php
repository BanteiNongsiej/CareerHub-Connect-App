<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\ApplicationRecordController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CertificationController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\ExperienceController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\ProfileImageController;
use App\Http\Controllers\ResumeController;
use App\Http\Controllers\SaveJobController;
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
    Route::get('/dashboard/user/{id}', 'UserDetails');
    Route::put('/dashboard/user/updateUserDetails/{id}', 'updateUserDetails');
    Route::delete('/dashboard/user/deleteUser/{id}', 'deleteUser');
    Route::get('/dashboard/ViewAllUsers', 'getUsers');
});

Route::controller(ResumeController::class)->group(function(){
    Route::post('/dashboard/storeResumeFile/{user_id}','store');
    Route::put('/dashboard/updateResumeFile/{user_id}','update');
    Route::delete('/dashboard/deleteResumeFile/{user_id}','delete');
    Route::get('/dashboard/ViewResume/{user_id}','view');
});

Route::controller(JobController::class)->group(function(){
    Route::post('/dashboard/job/insert/{user_id}','insert');
    Route::get('/dashboard/job/show/{job_id}','show');
    Route::get('/dashboard/job/findjob/{user_id}','findjob');
    Route::get('/dashboard/job/showalljob','showalljob');
    Route::put('dashboard/job/update/job','update');
    Route::delete('dashboard/job/delete/{job_id}','delete');
});

Route::controller(ExperienceController::class)->group(function(){
    Route::post('/dashboard/resume/InsertExperience/{user_id}','insert');
    Route::post('/dashboard/resume/UpdateExperience/{user_id}','update');
    Route::delete('/dashboard/resume/DeleteExperience/{user_id}','delete');
    Route::get('/dashboard/resume/getExperience/{user_id}','show');
});

Route::controller(EducationController::class)->group(function(){
    Route::post('/dashboard/resume/InsertEducation/{user_id}','insert');
    Route::post('/dashboard/resume/UpdateEducation/{user_id}','update');
    Route::delete('/dashboard/resume/DeleteEducation/{user_id}','delete');
    Route::get('/dashboard/resume/showEducation/{user_id}','show');
});

Route::controller(CertificationController::class)->group(function(){
    Route::post('/dashboard/resume/InsertCertification/{user_id}','insert');
    Route::get('/dashboard/resume/ShowCertification/{user_id}','show');
    Route::post('/dashboard/resume/UpdateCertification/{user_id}','update');
    Route::delete('/dashboard/resume/DeleteCertification/{user_id}','delete');
});

Route::controller(ApplicationRecordController::class)->group(function(){
    Route::post('/dashboard/job/applyjob/{candidate_id}/{job_id}','store');
    Route::get('/dashboard/job/check-application/{candidate_id}/{job_id}','checkApplication');
    Route::get('/dashboard/job/view-application/{job_id}','viewApplication');
    Route::get('/dashboard/job/viewResume/{candidate_id}','viewCandidateResume');
    Route::post('/dashboard/job/UpdateStatus/{user_id}/{status}','updatestatus');
    Route::delete('/dashboard/job/deleteApplication/{job_id}','deleteApplication');
});

Route::controller(SaveJobController::class)->group(function(){
    Route::post('/dashboard/job/save/{user_id}/{job_id}','save');
    Route::get('/dashboard/job/isSaved/{user_id}/{job_id}','isJobSaved');
    Route::delete('/dashboard/job/unsave/{user_id}/{job_id}','unsave');
    Route::get('/dashboard/job/viewSaveJob/{user_id}/{job_id}','viewSavedJobDetails');
    Route::get('/dashboard/job/viewAllSaveJob/{user_id}','viewAllSavedJobs');
});

Route::controller(ProfileImageController::class)->group(function(){
    Route::post('/dashboard/user/storeProfile/{id}','store');
    Route::put('/dashboard/user/updateProfile/{id}','update');
    Route::delete('/dashboard/user/deleteProfile/{id}','delete');
    Route::get('/dashboard/user/viewProfile/{id}','view');
});