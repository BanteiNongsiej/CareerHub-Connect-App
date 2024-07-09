<?php

namespace App\Http\Controllers;

use App\Models\Education;
use Exception;
use Illuminate\Http\Request;

class EducationController extends Controller
{
    public function insert(Request $request, $user_id)
    {
        try {
            $education = new Education();
            $education->user_id = $user_id;
            $education->level = $request->level;
            $education->field = $request->field;
            $education->school_name = $request->school_name;
            $education->state = $request->state;
            $education->city = $request->city;
            $education->locality = $request->locality;
            $education->pincode = $request->pincode;
            $education->start_month = $request->start_month;
            $education->start_year = $request->start_year;
            $education->finish_month = $request->finish_month;
            $education->finish_year = $request->finish_year;
            $education->grade = $request->grade;
            $education->skills = $request->skills;
            $education->save();

            return response()->json([
                'data' => $education,
                'message' => 'Education record inserted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Failed to insert education record',
                'error' => $e->getMessage(),
                'status' => 404,
            ], 404);
        }
    }

    public function update(Request $request, $user_id)
    {
        try {
            // Find the education record by user_id
            $education = Education::where('user_id', $user_id)->first();

            // If education record not found, return error response
            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            // Update education record attributes with data from request
            $education->level = $request->level;
            $education->field = $request->field;
            $education->school_name = $request->school_name;
            $education->state = $request->state;
            $education->city = $request->city;
            $education->locality = $request->locality;
            $education->pincode = $request->pincode;
            $education->start_month = $request->start_month;
            $education->start_year = $request->start_year;
            $education->finish_month = $request->finish_month;
            $education->finish_year = $request->finish_year;
            $education->grade = $request->grade;
            $education->skills = $request->skills;
            // Save the updated education record
            $education->save();

            return response()->json([
                'data' => $education,
                'message' => 'Education record updated successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if update fails
            return response()->json([
                'message' => 'Failed to update education record',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function delete($user_id)
    {
        try {
            // Find the education record by user_id
            $education = Education::where('user_id', $user_id)->first();

            // If education record not found, return error response
            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            // Delete the education record
            $education->delete();

            return response()->json([
                'message' => 'Education record deleted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if delete fails
            return response()->json([
                'message' => 'Failed to delete education record',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function show($user_id)
    {
        try {
            // Find the education record by user_id
            $education = Education::where('user_id', $user_id)->first();

            // If education record not found, return error response
            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            // Return the education record details as JSON
            return response()->json([
                'data' => $education,
                'message' => 'Education record retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if retrieval fails
            return response()->json([
                'message' => 'Failed to retrieve education record',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
}
