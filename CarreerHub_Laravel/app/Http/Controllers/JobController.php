<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Job;
use Illuminate\Http\Request;

class JobController extends Controller
{
    public function insert(Request $request){
        try{
            $job=new Job();
            $job->user_id=$request->user_id;
            $job->title = $request->title;
            $job->company_name = $request->company_name;
            $job->salary = $request->salary;
            $job->location = $request->location;
            $job->job_type = $request->job_type;
            $job->description = $request->description;
            $job->save();
            return response()->json([
                "data"=>$job,
                "message"=>"Record insert successfully"
            ],201);
        }catch(Exception $e){
            return response()->json([
                "message"=> $e//"Record insertion failed"
            ],404);
        }
    }
    public function show($job_id){
        $job = Job::find($job_id);//select * from users where id
        if(!$job){//checking for user
            return response()->json([
                'status' => 404, 
                'Message' => 'Job does not exist'
            ], 404);
        }
        else{
            return response()->json([
                "data" => $job,//call UserResource
            ],200);
        }
    }
}