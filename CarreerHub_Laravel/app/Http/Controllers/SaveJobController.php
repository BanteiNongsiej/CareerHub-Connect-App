<?php

namespace App\Http\Controllers;

use App\Models\Job;
use App\Models\save_job;
use App\Models\User;
use Illuminate\Http\Request;

class SaveJobController extends Controller
{
    public function save($user_id,$job_id){
        if(!User::find($user_id) || !Job::find($job_id)){
            return response()->json([
                'message' => 'Invalid user_id or job_id',
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

        $jobDetails = [];

        foreach ($savedJobs as $savedJob) {
            $job = Job::find($savedJob->job_id);
            if ($job) {
                $jobDetails[] = $job;
            }
        }

        return response()->json([
            'data' => $jobDetails,
        ], 200);
    }
}
