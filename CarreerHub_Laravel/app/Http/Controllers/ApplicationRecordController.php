<?php

namespace App\Http\Controllers;

use App\Models\Application_Record;
use App\Models\Job;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;

class ApplicationRecordController extends Controller
{
    public function store(Request $request,$candidate_id,$job_id){
        try{
            $request->validate([
                'resume' => 'required|mimes:pdf,doc,docx|max:5242880',
                'candidate_email'=>'required|String',
            ]);
            
            if(!User::find($candidate_id)|| !Job::find($job_id)){
                return response()->json([
                    'error'=>'Invalid candidate or job ID'
                ],404);
            }
            $existingApplication=Application_Record::where ('candidate_id',$candidate_id)->where('job_id',$job_id)->first();
            if($existingApplication){
                return response()->json([
                    'message' => 'User has already applied for this job'
                ],409);
            }
            $application_record=new Application_Record();
            $application_record->candidate_id=$candidate_id;
            $application_record->job_id=$job_id;
            $application_record->candidate_email=$request->candidate_email;
            if ($request->hasFile('resume')) {
                $originalFilename = $request->resume->getClientOriginalName();
                //$fileName = time() . '_' . $originalFilename;
                $request->file('resume')->storeAs('public/resumes', $originalFilename);
                $application_record->resume = $originalFilename;
            }
            $application_record->application_date=Carbon::now();
            $application_record->save();
            return response()->json([
                'message' => 'Application record created successfully',
                'data' => $application_record,
            ], 201);
        }catch(Exception $e){
            return response()->json([
                'error'=>'An error occurred while creating the application record',
                'details'=>$e->getMessage(),
            ],500);
        }
    }
    public function checkApplication($candidate_id, $job_id)
    {
        $existingApplication = Application_Record::where('candidate_id', $candidate_id)
                                                 ->where('job_id', $job_id)
                                                 ->first();
        if ($existingApplication) {
            return response()->json(['hasApplied'=>true], 200);
        } else {
            return response()->json(['hasApplied'=>false], 200);
        }
    }
    public function viewApplication(Request $request, $candidate_id, $job_id)
    {
        try {
            // Fetch the application record
            $application_record = Application_Record::where('candidate_id', $candidate_id)
                                                    ->where('job_id', $job_id)
                                                    ->first();

            if (!$application_record) {
                return response()->json([
                    'error' => 'Application record not found for this user and job',
                ], 404);
            }

            // Assuming you want to return the application record data
            return response()->json([
                'message' => 'Application record retrieved successfully',
                'data' => $application_record,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred while fetching the application record',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
}
