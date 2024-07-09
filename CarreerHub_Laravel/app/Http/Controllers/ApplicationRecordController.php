<?php

namespace App\Http\Controllers;

use App\Models\Application_Record;
use App\Models\Job;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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
                $originalFilename = $request->file('resume')->getClientOriginalName();
                $fileName = time().'_'.$originalFilename;
                $filePath = $request->file('resume')->storeAs('public/CandidateResume', $fileName);

                // Store the file path in the database
                $application_record->resume = str_replace('public/','',$filePath);
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
    public function viewApplication($job_id)
    {
        try {
            // Fetch the application record
            $application_records = Application_Record::where('job_id', $job_id)->get();

            if ($application_records->isEmpty()) {
                return response()->json([
                    'error' => 'Application record not found for this job',
                ], 404);
            }
            $records_with_original_filenames = $application_records->map(function ($record) {
                $storedPath = $record->resume;
                $filenameWithTimestamp = basename($storedPath);
                $originalFilename = substr($filenameWithTimestamp, strpos($filenameWithTimestamp, '_') + 1);
                $record->originalFilename = $originalFilename;
                return $record;
            });
            // Assuming you want to return the application record data
            return response()->json([
                'message' => 'Application record retrieved successfully',
                'data' => $records_with_original_filenames,
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'error' => 'An error occurred while fetching the application record',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
    public function viewCandidateResume($candidate_id)
    {
        try {
            //$application_record = Application_Record::find($candidate_id);
            $application_record = Application_Record::where('candidate_id', $candidate_id)->first();
            if (!$application_record || !$application_record->resume) {
                return response()->json([
                    'error' => 'Resume not found for this application',
                ], 404);
            }

            $resumePath = storage_path('app/public/'.$application_record->resume);

            if (file_exists($resumePath)) {
                return response()->file($resumePath);
            } else {
                return response()->json([
                    'error' => 'Resume file does not exist',
                ], 404);
            }

        } catch (Exception $e) {
            return response()->json([
                'error' => 'An error occurred while fetching the resume file',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
    public function updatestatus($candidate_id, $status)
{
    try {
        // Find the application record based on ca$candidate_id
        $application_record = Application_Record::where('candidate_id', $candidate_id)->first();

        if (!$application_record) {
            return response()->json([
                'error' => 'Application record not found',
            ], 404);
        }

        if($status=='Y'){
            $application_record->status=true;
        }else{
            $application_record->status=false;
        }

        // Save the updated status
        $application_record->save();

        return response()->json([
            'message' => 'Application status updated successfully',
            'data' => $application_record,
        ], 200);

    } catch (Exception $e) {
        return response()->json([
            'error' => 'An error occurred while updating application status',
            'details' => $e->getMessage(),
        ], 500);
    }
}


}
