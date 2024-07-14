<?php

namespace App\Http\Controllers;

use App\Models\Education;
use Exception;
use Illuminate\Http\Request;

class EducationController extends Controller
{
    public function insert(Request $request, $user_id)
    {
        $request->validate([
            'level' => 'nullable|string|max:255',
            'field' => 'nullable|string|max:255',
            'school_name' => 'nullable|string|max:255',
            'state' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:255',
            'locality' => 'nullable|string|max:255',
            'pincode' => 'nullable|string|max:6',
            'start_month' => 'nullable|string|max:255',
            'start_year' => 'nullable|integer|min:1900|max:9999',
            'finish_month' => 'nullable|string|max:255',
            'finish_year' => 'nullable|integer|min:1900|max:9999',
            'grade' => 'nullable|string|max:255',
            'skills' => 'nullable|string',
        ]);

        try {
            // Check if the user already has an education record
            $existingEducation = Education::where('user_id', $user_id)->first();

            if ($existingEducation) {
                return response()->json([
                    'message' => 'Education record already exists for this user',
                    'status' => 400,
                ], 400);
            }

            // Create new education record
            $education = new Education();
            $education->fill($request->all());
            $education->user_id = $user_id;
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
                'status' => 500,
            ], 500);
        }
    }
    public function update(Request $request, $user_id)
    {
        $request->validate([
            'level' => 'nullable|string|max:255',
            'field' => 'nullable|string|max:255',
            'school_name' => 'nullable|string|max:255',
            'state' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:255',
            'locality' => 'nullable|string|max:255',
            'pincode' => 'nullable|string|max:6',
            'start_month' => 'nullable|string|max:255',
            'start_year' => 'nullable|integer|min:1900|max:9999',
            'finish_month' => 'nullable|string|max:255',
            'finish_year' => 'nullable|integer|min:1900|max:9999',
            'grade' => 'nullable|string|max:255',
            'skills' => 'nullable|string',
        ]);

        try {
            $education = Education::where('user_id', $user_id)->first();

            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            $education->fill($request->all());
            $education->save();

            return response()->json([
                'data' => $education,
                'message' => 'Education record updated successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
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
            $education = Education::where('user_id', $user_id)->first();

            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            $education->delete();

            return response()->json([
                'message' => 'Education record deleted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
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
            $education = Education::where('user_id', $user_id)->first();

            if (!$education) {
                return response()->json([
                    'message' => 'Education record not found',
                    'status' => 404,
                ], 404);
            }

            return response()->json([
                'data' => $education,
                'message' => 'Education record retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve education record',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
}
