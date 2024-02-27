<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserInfoRequest;
use App\Http\Resources\UserInfoResource;
use App\Models\User;
use App\Models\UserInfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class UserInfoController extends Controller
{
    public function UserDetails($id){
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // Return the user details as an array (you can customize this)
        return response()->json([
            "data"=>new UserInfoResource($user),
        ],200);
    }
}
