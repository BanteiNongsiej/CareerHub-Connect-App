<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRegisterRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'email'=>'required|email',
            'password'=>'required|string|min:6|max:14'
        ];
    }
    public function messages():array
    {
        return[
            'password.required'=>'Password is required',
            'password.min|password.max'=>'Password must be between 6 and 14 characters',
            //'email.unique'=>'The entered email is already taken',
            'email.required'=>'Email is required'   
        ];
    }
}
