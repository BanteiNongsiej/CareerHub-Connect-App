<?php

namespace App\Http\Controllers;

use App\Models\Certification;
use Exception;
use Illuminate\Http\Request;

class CertificationController extends Controller
{
    public function insert(Request $request, $user_id)
    {
        try {
            $certification = new Certification();
            $certification->user_id = $user_id;
            $certification->certification_name = $request->certification_name;
            $certification->save();

            return response()->json([
                'data' => $certification,
                'message' => 'Certification added successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 404,
            ], 404);
        }
    }

    public function update(Request $request, $user_id)
    {
        try {
            // Find the certification record by user_id
            $certification = Certification::where('user_id', $user_id)->first();

            // If certification record not found, return error response
            if (!$certification) {
                return response()->json([
                    'message' => 'Certification not found',
                    'status' => 404,
                ], 404);
            }

            // Update certification record attributes with data from request
            $certification->certification_name = $request->certification_name;
            $certification->save();

            return response()->json([
                'data' => $certification,
                'message' => 'Certification updated successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if update fails
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function delete($user_id)
    {
        try {
            // Find the certification record by user_id
            $certification = Certification::where('user_id', $user_id)->first();

            // If certification record not found, return error response
            if (!$certification) {
                return response()->json([
                    'message' => 'Certification not found',
                    'status' => 404,
                ], 404);
            }

            // Delete the certification record
            $certification->delete();

            return response()->json([
                'message' => 'Certification deleted successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if delete fails
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }

    public function show($user_id)
    {
        try {
            // Find the certification record by user_id
            $certification = Certification::where('user_id', $user_id)->first();

            // If certification record not found, return error response
            if (!$certification) {
                return response()->json([
                    'message' => 'Certification not found',
                    'status' => 404,
                ], 404);
            }

            // Return the certification record details as JSON
            return response()->json([
                'data' => $certification,
                'message' => 'Certification retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            // Return error response if retrieval fails
            return response()->json([
                'message' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
}
