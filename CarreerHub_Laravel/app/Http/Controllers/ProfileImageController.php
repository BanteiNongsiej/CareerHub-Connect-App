<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class ProfileImageController extends Controller
{
    public function store(Request $request, $user_id)
    {
        try {
            Log::info('Store profile image request received for user ID: ' . $user_id);

            $request->validate([
                'profile_image' => 'required|mimes:jpg,png,jpeg|max:5242880',
            ]);

            $user = User::find($user_id);
            if (!$user) {
                Log::warning('User not found for ID: ' . $user_id);
                return response()->json(['message' => 'User not found'], 404);
            }

            if ($user->profile_image) {
                Log::info('Profile image already exists for user ID: ' . $user_id);
                return response()->json(['message' => 'Profile image already exists'], 400);
            }

            if ($request->hasFile('profile_image')) {
                $originalFilename = $request->file('profile_image')->getClientOriginalName();
                $fileName = time() . '_' . $originalFilename;
                $filepath = $request->file('profile_image')->storeAs('public/profiles', $fileName);
                $user->profile_image = str_replace('public/', '', $filepath);
            } else {
                Log::warning('No file uploaded in request for user ID: ' . $user_id);
                return response()->json(['message' => 'No file uploaded'], 400);
            }

            $user->save();

            Log::info('Profile image uploaded successfully for user ID: ' . $user_id);
            return response()->json([
                'message' => 'Profile image uploaded successfully',
                'profile_image' => $user->profile_image,
            ], 200);
        } catch (Exception $e) {
            Log::error('Failed to upload profile image for user ID: ' . $user_id, ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Failed to upload profile image',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function update(Request $request, $user_id)
    {
        try {
            Log::info('Update profile image request received for user ID: ' . $user_id);

            $request->validate([
                'profile_image' => 'required|mimes:jpg,png,jpeg|max:5242880',
            ]);

            $user = User::find($user_id);
            if (!$user) {
                Log::warning('User not found for ID: ' . $user_id);
                return response()->json(['message' => 'User not found'], 404);
            }

            if ($user->profile_image && Storage::exists('public/' . $user->profile_image)) {
                Storage::delete('public/' . $user->profile_image);
            }

            if ($request->hasFile('profile_image')) {
                $originalFilename = $request->file('profile_image')->getClientOriginalName();
                $fileName = time() . '_' . $originalFilename;
                $filePath = $request->file('profile_image')->storeAs('public/profiles', $fileName);
                $user->profile_image = str_replace('public/', '', $filePath);
            } else {
                Log::warning('No file uploaded in request for user ID: ' . $user_id);
                return response()->json(['message' => 'No file uploaded'], 400);
            }

            $user->save();

            Log::info('Profile image updated successfully for user ID: ' . $user_id);
            return response()->json([
                'message' => 'Profile image updated successfully',
                'profile_image' => $user->profile_image,
            ], 200);
        } catch (Exception $e) {
            Log::error('Failed to update profile image for user ID: ' . $user_id, ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Failed to update profile image',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function delete($user_id)
    {
        try {
            Log::info('Delete profile image request received for user ID: ' . $user_id);

            $user = User::find($user_id);
            if (!$user) {
                Log::warning('User not found for ID: ' . $user_id);
                return response()->json(['message' => 'User not found'], 404);
            }

            if ($user->profile_image) {
                $profilePath = 'public/' . $user->profile_image;

                if (Storage::exists($profilePath)) {
                    Storage::delete($profilePath);
                    $user->profile_image = null;
                    $user->save();

                    Log::info('Profile image deleted successfully for user ID: ' . $user_id);
                    return response()->json([
                        'message' => 'Profile image deleted successfully',
                    ], 200);
                } else {
                    $user->profile_image = null;
                    $user->save();

                    Log::warning('Profile image file not found, but database path cleared for user ID: ' . $user_id);
                    return response()->json([
                        'message' => 'Profile image file not found, but database path cleared',
                    ], 200);
                }
            } else {
                Log::warning('No profile image to delete for user ID: ' . $user_id);
                return response()->json(['message' => 'No profile image to delete'], 404);
            }
        } catch (Exception $e) {
            Log::error('Failed to delete profile image for user ID: ' . $user_id, ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Failed to delete profile image',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function view($user_id)
    {
        try {
            Log::info('View profile image request received for user ID: ' . $user_id);

            $user = User::find($user_id);
            if (!$user) {
                Log::warning('User not found for ID: ' . $user_id);
                return response()->json(['message' => 'User not found'], 404);
            }

            if (!$user->profile_image || !Storage::exists('public/profiles/' . $user->profile_image)) {
                Log::warning('Profile image not found for user ID: ' . $user_id);
                return response()->json(['message' => 'Profile image not found'], 404);
            }

            $path = storage_path('app/public/' . $user->profile_image);
            if (file_exists($path)) {
                Log::info('Profile image retrieved successfully for user ID: ' . $user_id);
                return response()->file($path);
            } else {
                Log::warning('Profile image file does not exist for user ID: ' . $user_id);
                return response()->json(['message' => 'Profile image file does not exist'], 404);
            }
        } catch (Exception $e) {
            Log::error('Failed to retrieve profile image for user ID: ' . $user_id, ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Failed to retrieve profile image',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
