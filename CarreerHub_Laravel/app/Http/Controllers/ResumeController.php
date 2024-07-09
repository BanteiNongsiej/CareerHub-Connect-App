<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Exception;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class ResumeController extends Controller
{
    public function store(Request $request, $user_id)
    {
        try {
            // Validate the request
            $request->validate([
                'resume' => 'required|mimes:pdf,doc,docx|max:5242880',
            ]);

            // Find the user
            $user = User::find($user_id);
            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
            }
            if ($user->resume) {
                return response()->json(['message' => 'Resume already exists'], 400);
            }

            // Handle the resume file upload
            if ($request->hasFile('resume')) {
                $originalFilename = $request->file('resume')->getClientOriginalName();
                $fileName = time() . '_' . $originalFilename;
                $filePath = $request->file('resume')->storeAs('public/resumes', $fileName);

                // Store the file path in the database
                $user->resume = str_replace('public/', '', $filePath); // Store the path without 'public/'
            } else {
                return response()->json(['message' => 'No file uploaded'], 400);
            }

            // Save the user's resume information
            $user->save();

            // Return a success response
            return response()->json([
                'message' => 'Resume uploaded successfully',
                'resume' => $user->resume,
            ], 200);
        } catch (Exception $e) {
            // If an exception occurs, return an error response
            return response()->json([
                'message' => 'Failed to upload resume',
                'error' => $e->getMessage(),
            ], 500);
        }
    }


public function update(Request $request, $user_id)
{
    try {
        // Validate the request
        $request->validate([
            'resume' => 'required|mimes:pdf,doc,docx|max:5242880',
        ]);

        // Find the user
        $user = User::find($user_id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Delete the old resume file if it exists
        if ($user->resume && Storage::exists('public/' . $user->resume)) {
            Storage::delete('public/' . $user->resume);
        }

        // Handle the new resume file upload
        if ($request->hasFile('resume')) {
            $originalFilename = $request->file('resume')->getClientOriginalName();
            $fileName = time() . '_' . $originalFilename;
            $filePath = $request->file('resume')->storeAs('public/resumes', $fileName);

            // Store the file path in the database
            $user->resume = str_replace('public/', '', $filePath); // Store the path without 'public/'
        } else {
            return response()->json(['message' => 'No file uploaded'], 400);
        }

        // Save the user's resume information
        $user->save();

        // Return a success response
        return response()->json([
            'message' => 'Resume updated successfully',
            'resume' => $user->resume,
        ], 200);
    } catch (Exception $e) {
        // If an exception occurs, return an error response
        return response()->json([
            'message' => 'Failed to update resume',
            'error' => $e->getMessage(),
        ], 500);
    }
}




public function delete($user_id)
{
    try {
        // Find the user
        $user = User::find($user_id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Check if the user has a resume
        if ($user->resume) {
            $resumePath = 'public/' . $user->resume;
            Log::info("Attempting to delete resume at path: " . $resumePath);

            // Delete the resume file if it exists
            if (Storage::exists($resumePath)) {
                Storage::delete($resumePath);
                $user->resume = null;
                $user->save();

                // Return a success response
                return response()->json([
                    'message' => 'Resume deleted successfully',
                ], 200);
            } else {
                // If the file doesn't exist, still clear the resume path in the database
                Log::warning("Resume file not found at path: " . $resumePath);
                $user->resume = null;
                $user->save();

                return response()->json([
                    'message' => 'Resume file not found, but database path cleared',
                ], 200);
            }
        } else {
            return response()->json(['message' => 'No resume to delete'], 404);
        }
    } catch (Exception $e) {
        // If an exception occurs, return an error response
        return response()->json([
            'message' => 'Failed to delete resume',
            'error' => $e->getMessage(),
        ], 500);
    }
}



    public function view($user_id)
    {
        try {
            // Find the user
            $user = User::find($user_id);
            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
            }

            // Check if the user has a resume
            if (!$user->resume || !Storage::exists('public/resumes/' . $user->resume)) {
                return response()->json(['message' => 'Resume not found'], 404);
            }

            // Return the resume file as a response
            $path = storage_path('app/public/' . $user->resume);
            if(file_exists($path)){
                return response()->file($path);
            }else{
                return response()->json([
                    'error'=>'resume file does not exist',
                ],404);
            }
        } catch (Exception $e) {
            // If an exception occurs, return an error response
            return response()->json([
                'message' => 'Failed to retrieve resume',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
