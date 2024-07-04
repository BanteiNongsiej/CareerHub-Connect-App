<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Exception;
use Illuminate\Support\Facades\Storage;

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

            // Handle the resume file upload
            if ($request->hasFile('resume')) {
                $originalFilename = $request->file('resume')->getClientOriginalName();
                $fileName = $originalFilename;
                $filePath = $request->file('resume')->storeAs('public/resumes', $fileName);

                // Store the file path in the database
                $user->resume = 'storage/' . substr($filePath, 7); // Adjust for Laravel's storage path
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
            if ($user->resume && Storage::exists('public/resumes/' . $user->resume)) {
                Storage::delete('public/resumes/' . $user->resume);
            }

            // Handle the new resume file upload
            if ($request->hasFile('resume')) {
                $originalFilename = $request->file('resume')->getClientOriginalName();
                $fileName = $originalFilename;
                $filePath = $request->file('resume')->storeAs('public/resumes', $fileName);

                // Store the file path in the database
                $user->resume = 'storage/' . substr($filePath, 7); // Adjust for Laravel's storage path
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

            // Delete the resume file if it exists
            if ($user->resume && Storage::exists('public/resumes/' . $user->resume)) {
                Storage::delete('public/resumes/' . $user->resume);
                $user->resume = null;
                $user->save();
            }

            // Return a success response
            return response()->json([
                'message' => 'Resume deleted successfully',
            ], 200);
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
            $path = storage_path('app/public/resumes/' . $user->resume);
            return response()->file($path);
        } catch (Exception $e) {
            // If an exception occurs, return an error response
            return response()->json([
                'message' => 'Failed to retrieve resume',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}