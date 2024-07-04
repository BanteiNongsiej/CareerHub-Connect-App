<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Job;
use Illuminate\Http\Request;
use App\Http\Requests\JobRequest;
use Illuminate\Routing\Controller;

class JobController extends Controller
{
    public function insert(Request $request,$user_id){
        try{
            $job=new Job();
            $job->user_id=$user_id;
            $job->title = $request->title;
            $job->name = $request->name;
            $job->street = $request->street;
            $job->city = $request->city;
            $job->pincode=$request->pincode;
            $job->state = $request->state;
            $job->country= $request->country;
            $job->min_salary= $request->min_salary;
            $job->max_salary= $request->max_salary;
            $job->salary_period=$request->salary_period;
            $job->job_type= $request->job_type;
            $job->shift_type= $request->shift_type;
            $job->no_people= $request->no_people;
            $job->experience_req= $request->experience_req;
            $job->qualification_req= $request->qualification_req;
            $job->skills= $request->skills;
            $job->description= $request->description;
            $job->save();
            return response()->json([
                'data'=>$job,
                'message'=>'Job posted successfully',
                'status'=>200,
            ],200);
        }catch(Exception $e){
            return response()->json([
                "message"=> $e,//"Record insertion failed"
                'status'=>404,
            ],404);
        }
    }
    public function show($job_id){
        $job = Job::find($job_id);//select * from users where id
        $fullAddress = $this->getAddress($job);
        if(!$job){//checking for user
            return response()->json([
                'status' => 404, 
                'Message' => 'Job does not exist'
            ], 404);
        }
        else{
            return response()->json([
                "data" => [
                    'id' => $job->id,
                    'user_id' => $job->user_id,
                    'title' => $job->title,
                    'name' => $job->name,
                    'address' => $fullAddress,
                    'min_salary' => $job->min_salary,
                    'max_salary' => $job->max_salary,
                    'salary_period'=>$job->salary_period,
                    'job_type' => $job->job_type,
                    'shift_type' => $job->shift_type,
                    'no_people' => $job->no_people,
                    'experience_req' => $job->experience_req,
                    'qualification_req' => $job->qualification_req,
                    'skills' => $job->skills,
                    'description' => $job->description
                ],//call UserResource
            ],200);
        }
    }
    public function getAddress($job) {
        $addressParts = [$job->street,$job->pincode, $job->city,$job->city,$job->state, $job->country ];
        return implode(', ', array_filter($addressParts));
    }
    
    public function findjob($user_id){
        $job = Job::where('user_id',$user_id)->get();
        // $fullAddress = $this->getAddress($job);
        if(!$job){//checking for user
            return response()->json([
                'status' => 404, 
                'Message' => 'Job does not exist'
            ], 404);
        }
        else{
            $jobsData = $job->map(function ($job) {
                return [
                    'id' => $job->id,
                    'user_id' => $job->user_id,
                    'title' => $job->title,
                    'name' => $job->name,
                    'address' => $this->getAddress($job),
                    'min_salary' => $job->min_salary,
                    'max_salary' => $job->max_salary,
                    'salary_period'=>$job->salary_period,
                    'job_type' => $job->job_type,
                    'shift_type' => $job->shift_type,
                    'no_people' => $job->no_people,
                    'experience_req' => $job->experience_req,
                    'qualification_req' => $job->qualification_req,
                    'skills' => $job->skills,
                    'description' => $job->description
                ];
            });
            return response()->json([
                'data' => $jobsData
            ], 200);
        }
    }
    public function showalljob() {
        $jobs = Job::all();
    
        if ($jobs->isEmpty()) {
            return response()->json([
                'message' => 'No Jobs found'
            ], 404);
        } else {
            $jobsData = $jobs->map(function ($job) {
                return [
                    'id' => $job->id,
                    'user_id' => $job->user_id,
                    'title' => $job->title,
                    'name' => $job->name,
                    'address' => $this->getAddress($job),
                    'min_salary' => $job->min_salary,
                    'max_salary' => $job->max_salary,
                    'salary_period'=>$job->salary_period,
                    'job_type' => $job->job_type,
                    'shift_type' => $job->shift_type,
                    'no_people' => $job->no_people,
                    'experience_req' => $job->experience_req,
                    'qualification_req' => $job->qualification_req,
                    'skills' => $job->skills,
                    'description' => $job->description,
                    'bookmark' =>$job->bookmark
                ];
            });
            return response()->json([
                'data' => $jobsData
            ], 200);
        }
    }
    public function delete($job_id){
        try{
            $job=Job::find($job_id);
            $job->delete();
            return response()->json([
                "data"=>$job,
                "message"=>"Job deleted successfully",
                "statuscode"
            ],200);
        }catch(Exception $e){
            return response()->json([
                "message"=>"Job deleted successfully"
            ]);
        }
    }
    public function update(JobRequest $request,Job $job){
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
                "message"=>"Job update successfully"
            ],201);
        }catch(Exception $e){
            return response()->json([
                "message"=>"Job is not update"
            ],404);
        }
    }

    public function updateBookmark(Job $job,$status){
        if($status=='Y')
            $job->bookmark = true;
        else
            $job->bookmark = false;
        $job->save();
        return response()->json([
            'data'=>'ok'
        ]);
    }
}
