<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserRequest;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class AuthController extends Controller
{
    public function register(Request $request) {
        try {
            $existingUser = User::where('email', $request->email)->first();
            if ($existingUser) {
                return response()->json([
                    'message' => 'Email account already registered',
                    'status' => 400,
                ], 400);
            }
            $user = new User();
            $user->email = $request->email;
            $user->password = Hash::make($request->password);
            $user->save();
            //$response = ['status' => 200, 'message' => 'Registered Successfully'];
            return response()->json([
                'message'=>'Registered succesfully',
                'status'=>200,
            ],200);
        } catch (Exception $e) {
            //$response = ['status' => 500, 'message' => 'Registration failed: ' . $e->getMessage()];
            return response()->json([
                'message'=>'Registration failed'.$e->getMessage()
            ],404);
        }
    }

    public function login(Request $request) {
        $user = User::where('email', $request->email)->first();

        if($user && Hash::check($request->password, $user->password)){
            $token = $user->createToken('auth_token')->plainTextToken;
            $user_id=$user->id;
           // $response=['status' => 200, 'token' => $token, 'user' => $user, 'message' => 'Successfully Logged In'];
            return response()->json([
                'token'=>$token,
                'user'=>$user,
                'email'=>$request->email,
                'user_id'=>$user_id,
                'message'=>'Successfully Logged in'
            ],200);
        } elseif (!$user) {
           // $response=['status' => 404, 'message' => 'No Account has been registered with this email'];
            return response()->json([
                'message'=>'No Account has been registered with this email'
            ],404);
        } else {
           // $response=['status' => 401, 'message' => 'Wrong Email or Password'];
            return response()->json([
                'message'=>'Wrong email or password.'
            ],401);
        }
    }
}
