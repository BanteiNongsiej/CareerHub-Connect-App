<?php

namespace App\Http\Controllers;

use App\Models\certification;
use Exception;
use Illuminate\Http\Request;

class CertificationController extends Controller
{
    public function insert(Request $request,$user_id){
        try{
            $certification=new certification();
            $certification->user_id=$user_id;
            $certification->certification_name=$request->certification_name;
            $certification->save();
            return response()->json([
                'data'=>$certification,
                'message'=>'Certification added successfully',
                'status'=>200,
            ],200);
        }catch(Exception $e){
            return response()->json([
                "message"=> $e,//"Record insertion failed"
                'status'=>404,
            ],404); 
        }
    }
    public function update(Request $request,$user_id){
        try{
            $certification=new certification();
            $certification->user_id=$user_id;
            $certification->certification_name=$request->certification_name;
            $certification->save();
            return response()->json([
                'data'=>$certification,
                'message'=>'Certification updated successfully',
                'status'=>200,
            ],200);
        }catch(Exception $e){
            return response()->json([
                "message"=> $e,//"Record insertion failed"
                'status'=>404,
            ],404); 
        }
    }
}
