<?php

namespace App\Http\Controllers;

use App\Http\Requests\ExperienceRequest;
use App\Models\Experience;
use Exception;
use Illuminate\Http\Request;

class ExperienceController extends Controller
{
    public function insert(Request $request,$user_id){
        try{
            $experience=new Experience();
            $experience->user_id = $user_id;
            $experience->title = $request->title;
            $experience->company = $request->company;
            $experience->state = $request->state;
            $experience->city = $request->city;
            $experience->start_month = $request->start_month;
            $experience->start_year = $request->start_year;
            $experience->finish_month = $request->finish_month;
            $experience->finish_year = $request->finish_year;
            $experience->description = $request->description;
            $experience->save();
            return response()->json([
                'data'=>$experience,
                'message'=>'Experience inserted successfully',
                'status'=>200,
            ],200);
        }catch(Exception $e){
            return response()->json([
                "message"=> $e,//"Record insertion failed"
                'status'=>404,
            ],404);
        }
    }
    public function update(ExperienceRequest $request, $id)
    {
        try {
            $experience = Experience::find($id);
            if (!$experience) {
                return response()->json([
                    'message' => 'Experience not found',
                    'status' => 404,
                ], 404);
            }

            // Update the experience attributes from the request
            $experience->user_id = $request->user_id; 
            $experience->title = $request->title;
            $experience->company = $request->company;
            $experience->state = $request->state;
            $experience->city = $request->city;
            $experience->start_month = $request->start_month;
            $experience->start_year = $request->start_year;
            $experience->finish_month = $request->finish_month;
            $experience->finish_year = $request->finish_year;
            $experience->description = $request->description;
            $experience->save();

            return response()->json([
                'data' => $experience,
                'message' => 'Experience updated successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "message" => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
    public function show($id)
    {
        try {
            // Find the experience record by its ID
            $experience = Experience::findOrFail($id);

            return response()->json([
                'data' => $experience,
                'message' => 'Experience retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Experience not found',
                'status' => 404,
            ], 404);
        }
    }
}
