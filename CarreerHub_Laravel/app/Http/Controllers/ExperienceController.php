<?php

namespace App\Http\Controllers;

use App\Http\Requests\ExperienceRequest;
use App\Models\Experience;
use Exception;
use Illuminate\Http\Request;

class ExperienceController extends Controller
{
    public function insert(Request $request, $user_id)
    {
        try {
            $experience = new Experience();
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
                'data' => $experience,
                'message' => 'Experience inserted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 404,
            ], 404);
        }
    }

    public function update(ExperienceRequest $request, $user_id)
    {
        try {
            $experience = Experience::where('user_id', $user_id)->first();
            if (!$experience) {
                return response()->json([
                    'message' => 'Experience not found',
                    'status' => 404,
                ], 404);
            }

            // Update the experience attributes from the request
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
                'message' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function show($user_id)
    {
        try {
            $experience = Experience::where('user_id', $user_id)->first();
            if (!$experience) {
                return response()->json([
                    'message' => 'Experience not found',
                    'status' => 404,
                ], 404);
            }

            return response()->json([
                'data' => $experience,
                'message' => 'Experience retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function delete($user_id)
    {
        try {
            $experience = Experience::where('user_id', $user_id)->first();
            if (!$experience) {
                return response()->json([
                    'message' => 'Experience not found',
                    'status' => 404,
                ], 404);
            }
            
            $experience->delete();

            return response()->json([
                'message' => 'Experience record deleted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Failed to delete experience record',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
}
