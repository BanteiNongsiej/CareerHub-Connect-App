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
    public function UserDetails($id){
        $user = User::find($id);
        $fullName = $this->getFullName($user);
        $fullAddress = $this->getFullAddress($user);
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
                "gender"=>$user->gender
            ],200);
        }
    }
    private function getFullAddress($user)
    {
        $addressParts = [$user->country, $user->state, $user->city, $user->street, $user->pincode];
        return implode(', ', array_filter($addressParts));
    }
    private function getFullName($user)
    {
        $nameParts = [$user->first_name, $user->middle_name, $user->last_name];
        // Remove empty or null elements and join them with spaces
        return implode(' ', array_filter($nameParts));
    }
    public function updateUserDetails($id, Request $request){
        try {
            $user = User::find($id);
            //$user=new User();
            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
              }

            // // Retrieve the updated data from the request
            $updatedData = $request->only([
                'email' => 'required|email|unique:users,email,' . $user->id,
                'first_name' => 'required|string|max:255',
                'middle_name' => 'nullable|string|max:255',
                'last_name' => 'required|string|max:255',
                'mobile_number' => 'required|string|max:255',
                'dob' => 'nullable|date',
                'gender' => 'nullable|string|max:255',
                'profile_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
                'country',
                'state',
                'city',
                'street',
                'pincode',
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
                    'mobile_number' => $user->mobile_number,
                    'address' => $fullAddress,
                    'dob'=>$user->dob,
                    'gender'=>$user->gender
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
}
