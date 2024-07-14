<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserInfoRequest;
use App\Http\Resources\UserInfoResource;
use App\Models\User;
use App\Models\UserInfo;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class UserInfoController extends Controller
{
    public function getUsers()
    {
        try {
            $users = User::where('id','!=',5)->get();

            if ($users->isEmpty()) {
                return response()->json(['message' => 'No users found'], 404);
            } else {
                $usersData = $users->map(function ($user) {
                    $resume = null;
                    if (!empty($user->resume)) {
                        // Remove the directory path and extract the file name
                        $resume = basename($user->resume);
                        // Remove the timestamp and underscore from the file name if present
                        $resume = preg_replace('/^\d+_/', '', $resume);
                    }
                    
                    return [
                        "id" => $user->id,
                        "email" => $user->email,
                        "name" => $this->getFullName($user),
                        "mobile_number" => $user->mobile_number,
                        "address" => $this->getFullAddress($user),
                        "dob" => $user->dob,
                        "gender" => $user->gender,
                        "resume" => $resume
                    ];
                });
                return response()->json(['data' => $usersData], 200);
            }
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch users',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function UserDetails($id){
        $user = User::find($id);
        $fullName = $this->getFullName($user);
        $fullAddress = $this->getFullAddress($user);
        if (!empty($user->resume)) {
            // Remove the directory path and extract the file name
            $resume = basename($user->resume);
            // Remove the timestamp and underscore from the file name
            $resume = preg_replace('/^\d+_/', '', $resume);
        }else{
            $resume=null;
        }
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
        else{
            return response()->json([
                "data"=>$user,
                "email"=>$user->email,
                "name"=>$fullName,
                "profile_image"=>$user->profile_image,
                "mobile_number"=>$user->mobile_number,
                "address" => $fullAddress,
                "dob"=>$user->dob,
                "gender"=>$user->gender,
                "resume"=>$resume
            ],200);
        }
    }
    private function getFullAddress($user)
    {
        if (!$user) {
            return ''; // Return an empty string if $user is null
        }
        $addressParts = [];
        // Check and add country if not null
        if (!empty($user->country)) {
            $addressParts[] = $user->country;
        }
        // Check and add state if not null
        if (!empty($user->state)) {
            $addressParts[] = $user->state;
        }
        // Check and add city if not null
        if (!empty($user->city)) {
            $addressParts[] = $user->city;
        }
        // Check and add street if not null
        if (!empty($user->street)) {
            $addressParts[] = $user->street;
        }
        // Check and add pincode if not null
        if (!empty($user->pincode)) {
            $addressParts[] = $user->pincode;
        }
        // Join the non-empty parts with commas and spaces
        return implode(', ', $addressParts);
    }
    private function getFullName($user)
    {
        if (!$user) {
        return ''; // Return an empty string if $user is null
         }
        $nameParts = [];
        // Check and add first_name if not null
        if (!empty($user->first_name)) {
            $nameParts[] = $user->first_name;
        }
        // Check and add middle_name if not null
        if (!empty($user->middle_name)) {
            $nameParts[] = $user->middle_name;
        }
        // Check and add last_name if not null
        if (!empty($user->last_name)) {
            $nameParts[] = $user->last_name;
        }
        // Join the non-empty parts with spaces
        return implode(' ', $nameParts);
    }
    public function updateUserDetails($id, Request $request){
            try {
                $user = User::find($id);
                $user->first_name=$request->first_name;
                $user->middle_name=$request->middle_name;
                $user->last_name=$request->last_name;
                $user->mobile_number=$request->mobile_number;
                $user->country=$request->country;
                $user->state=$request->state;
                $user->city=$request->city;
                $user->street=$request->street;
                $user->pincode=$request->pincode;            
                $user->dob=$request->dob;
                $user->gender=$request->gender;
                //$user->resume=$request->resume;
                //$user=new User();
                if (!$user) {
                    return response()->json(['message' => 'User not found'], 404);
                }

                // // Retrieve the updated data from the request
                $updatedData = $request->only([
                    'email' => 'email|unique:users,email,' . $user->id,
                    'first_name' => 'string|max:255',
                    'middle_name' => 'nullable|string|max:255',
                    'last_name' => 'string|max:255',
                    'mobile_number' => 'nullable|string|max:255',
                    'dob' => 'nullable|date',
                    'gender' => 'nullable|string|max:255',
                    'profile_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
                    'country'=>'nullable|string',
                    'state'=>'nullable|string',
                    'city'=>'nullable|string',
                    'street'=>'nullable|string',
                    'pincode'=>'nullable|string',
                ]);
        
                // // Update the user model with the updated data
                $user->fill($updatedData);
                if ($request->hasFile('profile_image')) {
                    $fileName = time() . '.' . $request->profile_image->getClientOriginalExtension();
                    $request->profile_image->storeAs('public/profile_images', $fileName); // Adjust path as needed
                    $user->profile_image = $fileName;
                }
                $user->save();
        
                // Optionally, update the full name as well
                $fullName = $this->getFullName($user);
                $fullAddress = $this->getFullAddress($user);
        
                // Return a success response with the updated user details
                return response()->json([
                    'message' => 'User details updated successfully',
                    'data' => [
                        //'user' => $user,
                        'email' => $user->email,
                        'profile image' => $user->profile_image,
                        'first_name' => $user->first_name,
                        'middle_name' => $user->middle_name,
                        'last_name' => $user->last_name,
                        'Full Name'=>$fullName,
                        'mobile_number' => $user->mobile_number,
                        'address' => $fullAddress,
                        'dob'=>$user->dob,
                        'gender'=>$user->gender,
                        //'resume'=>$user->resume,
                        'Time'=>$user->created_at
                    ]
                ], 200);
            } catch (Exception $e) {
                // If an exception occurs, return an error response
                return response()->json([
                    'message' => 'Profile update failed',
                    'error' => $e->getMessage(),
                ], 500);
            }
    }
    public function updateUserResume($id, Request $request)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
            }

            $request->validate([
                'email' => 'required|email|unique:users,email,' . $user->id,
                'first_name' => 'nullable|string|max:255',
                'middle_name' => 'nullable|string|max:255',
                'last_name' => 'nullable|string|max:255',
                'mobile_number' => 'nullable|string|max:255',
                'dob' => 'nullable|date',
                'gender' => 'nullable|string|max:255',
                'country' => 'nullable|string|max:255',
                'state' => 'nullable|string|max:255',
                'city' => 'nullable|string|max:255',
                'street' => 'nullable|string|max:255',
                'pincode' => 'nullable|string|max:255',
            ]);

            $user->email = $request->input('email');
            $user->first_name = $request->input('first_name');
            $user->middle_name = $request->input('middle_name');
            $user->last_name = $request->input('last_name');
            $user->mobile_number = $request->input('mobile_number');
            $user->dob = $request->input('dob');
            $user->gender = $request->input('gender');
            $user->country = $request->input('country');
            $user->state = $request->input('state');
            $user->city = $request->input('city');
            $user->street = $request->input('street');
            $user->pincode = $request->input('pincode');
            $user->save();

            return response()->json([
                'message' => 'User details updated successfully',
                'data' => [
                    'email' => $user->email,
                    'first_name' => $user->first_name,
                    'middle_name' => $user->middle_name,
                    'last_name' => $user->last_name,
                    'mobile_number' => $user->mobile_number,
                    'country'=>$user->country,
                    'state'=>$user->state,
                    'city'=>$user->city,
                    'street'=>$user->street,
                    'pincode'=>$user->pincode,
                    'dob'=>$user->dob,
                    'gender'=>$user->gender,
                ],
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Profile update failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    public function viewUserResumeDetails($id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json([
                    'message' => 'User not found',
                    'status' => 404,
                ], 404);
            }
            return response()->json([
                'data' => [
                    'email' => $user->email,
                    'first_name' => $user->first_name,
                    'middle_name' => $user->middle_name,
                    'last_name' => $user->last_name,
                    'mobile_number' => $user->mobile_number,
                    'dob' => $user->dob,
                    'gender' => $user->gender,
                    'country' => $user->country,
                    'state' => $user->state,
                    'city' => $user->city,
                    'street' => $user->street,
                    'pincode' => $user->pincode,
                ],
                'message' => 'User details retrieved successfully',
                'status' => 200,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve user details',
                'error' => $e->getMessage(),
                'status' => 500,
            ], 500);
        }
    }
    public function deleteUser($id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json(['message' => 'User not found'
            ], 404);
            }
            $user->delete();
                return response()->json(['message' => 'Profile deleted succesfully'
            ], 200);
            } catch (Exception $e) {
                return response()->json([
                    'message' => 'Failed to delete Profile',
                    'error' => $e->getMessage()], 500);
        }
    }
    public function getProfile($id)
    {
        try {
            $user = User::findOrFail($id);
            return response()->json([
                'success' => true,
                'data' => [
                    'first_name' => $user->first_name,
                    'middle_name' => $user->middle_name,
                    'last_name' => $user->last_name,
                    'mobile_number' => $user->mobile_number,
                    'email' => $user->email,
                    'country' => $user->country,
                    'state' => $user->state,
                    'city' => $user->city,
                    'street' => $user->street,
                    'pincode' => $user->pincode,
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 404);
        }
    }
    public function updateProfileData(Request $request, $id)
    {
        $request->validate([
            'first_name' => 'nullable|string|max:255',
            'middle_name' => 'nullable|string|max:255',
            'last_name' => 'required|string|max:255',
            'mobile_number' => 'nullable|string|max:20',
            'email' => 'required|string|email|max:255',
            'country' => 'nullable|string|max:255',
            'state' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:255',
            'street' => 'nullable|string|max:255', // Ensure this allows nulls and strings up to 255 characters
            'pincode' => 'nullable|string|max:20',
        ]);
        try {
            $user = User::findOrFail($id);
            $user->update([
                'first_name' => $request->input('first_name'),
                'middle_name' => $request->input('middle_name'),
                'last_name' => $request->input('last_name'),
                'mobile_number' => $request->input('mobile_number'),
                'email' => $request->input('email'),
                'country' => $request->input('country'),
                'state' => $request->input('state'),
                'city' => $request->input('city'),
                'street' => $request->input('street'),
                'pincode' => $request->input('pincode'),
            ]);
            $user->save();
            return response()->json([
                'message' => 'Profile updated successfully',
                'data' => $user->fresh(), // Retrieve fresh updated data
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update profile',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    
}
