<?php

namespace App\Http\Controllers;

use App\Models\Job;
use App\Models\save_job;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;

class SaveJobController extends Controller
{
    public function save($user_id,$job_id){
        try{
            if(!User::find($user_id) || !Job::find($job_id)){
                return response()->json([
                    'message' => 'Invalid user_id or job_id',
                ], 400);
            }
            $existingSave = save_job::where('user_id', $user_id)->where('job_id', $job_id)->first();
                if ($existingSave) {
                    return response()->json([
                        'message' => 'You have already saved this job.',
                    ], 400);
                }
            $savejob=save_job::create([
                'user_id' => $user_id,
                'job_id' => $job_id,
            ]);
            $jobDetails = Job::find($job_id);
            return response()->json([
                'message' => 'Job saved successfully!',
                'data' => $savejob,
                'job_details'=>$jobDetails
            ], 201);
        }catch(Exception $e){
            return response()->json([
                'message' => 'An error occurred: ' . $e->getMessage(),
            ], 500);
        }
    }
    public function unsave($user_id,$job_id){
        if(!User::find($user_id) || !Job::find($job_id)){
            return response()->json([
                'message' => 'Invalid user_id or job_id',
            ], 400);
        }
        $saveJob = save_job::where('user_id', $user_id)
                          ->where('job_id', $job_id)
                          ->first();
        if ($saveJob) {
            $saveJob->delete();
            $jobDetails = Job::find($job_id);
                return response()->json([
                    'message' => 'Job unsaved successfully!',
                    'data' => $jobDetails,
                    ], 200);
                }
                return response()->json([
                    'message' => 'Job not found!',
                    ], 404);
    }
    public function isJobSaved($user_id, $job_id) {
        if (!User::find($user_id) || !Job::find($job_id)) {
            return response()->json([
                'message' => 'Invalid user_id or job_id',
            ], 400);
        }
    
        $saveJob = save_job::where('user_id', $user_id)
                           ->where('job_id', $job_id)
                           ->first();
    
        return response()->json([
            'isSaved' => $saveJob ? true : false,
        ], 200);
    }
    
    public function viewSavedJobDetails($user_id, $job_id)
    {
        $saveJob = save_job::where('user_id', $user_id)
                          ->where('job_id', $job_id)
                          ->first();

        if (!$saveJob) {
            return response()->json([
                'message' => 'No saved job found for this user and job ID!',
            ], 404);
        }

        $job = Job::find($job_id);

        if (!$job) {
            return response()->json([
                'message' => 'Job not found!',
            ], 404);
        }

        return response()->json([
            'data' => $job,
        ], 200);
    }
    public function viewAllSavedJobs($user_id)
{
    $user = User::find($user_id);

    if (!$user) {
        return response()->json([
            'message' => 'User not found!',
        ], 404);
    }

    $savedJobs = save_job::where('user_id', $user_id)->get();

    $jobDetails = $savedJobs->map(function ($savedJob) {
        $job = Job::find($savedJob->job_id);
        $fullAddress=$this->getAddress($job);
        if ($job) {
            return [
                'id' => $job->id,
                'user_id' => $savedJob->user_id,
                'title' => $job->title,
                'name' => $job->name,
                'address' => $fullAddress, // Assuming 'address' is a direct property of Job model
                'min_salary' => $job->min_salary,
                'max_salary' => $job->max_salary,
                'salary_period' => $job->salary_period,
                'job_type' => $job->job_type,
                'shift_type' => $job->shift_type,
                'no_people' => $job->no_people,
                'experience_req' => $job->experience_req,
                'qualification_req' => $job->qualification_req,
                'skills' => $job->skills,
                'description' => $job->description,
            ];
        }
    });//->filter(); // Filter out null values if any

    return response()->json([
        'data' => $jobDetails,
    ], 200);
}
public function getAddress($job) {
    $addressParts = [$job->street,$job->pincode, $job->city,$job->city,$job->state, $job->country ];
    return implode(', ', array_filter($addressParts));
}

}
