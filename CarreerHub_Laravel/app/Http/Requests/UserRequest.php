<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRequest extends FormRequest
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
            'password'=>'required|string|min:6|max:14',
            'profile_image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'first_name' => 'required|string|max:255|min:2',
            'middle_name' => 'nullable|string|max:255|min:1',
            'last_name' => 'required|string|max:255|min:2',
            'mobile_number' => 'required|string|size:10',
            'country' => 'required', 'string', 'max:255',
            'state' => 'required', 'string', 'max:255',
            'city' => 'required', 'string', 'max:255',
            'locality' => 'required', 'string', 'max:255',
            'district' => 'required', 'string', 'max:255',
            'pincode' => 'required', 'string', 'max:255',
        ];
    }
    public function messages():array
    {
        return[
            'password.required'=>'Password is required',
            'password.min|password.max'=>'Password must be between 6 and 14 characters',
            //'email.unique'=>'The entered email is already taken',
            'email.required'=>'Email is required',
            'profile_image.image' => 'The profile image must be an image file',
            'profile_image.mimes' => 'The profile image must be a JPEG, PNG, JPG, GIF, or SVG file',
            'profile_image.max' => 'The profile image cannot be larger than 2048 KB',
            'first_name.required' => 'First name is required',
            'first_name.min|first_name.max' => 'First name must be between 2 and 255 characters long',
            'middle_name.min|middle_name.max' => 'Middle name must be between 1 and 255 characters long (optional)',
            'last_name.required' => 'Last name is required',
            'last_name.min|last_name.max' => 'Last name must be between 2 and 255 characters long',
            'address.required' => 'Address is required',
            'address.min|address.max' => 'Address must be between 2 and 255 characters long',
            'mobile_number.required' => 'Mobile number is required',
            'mobile_number.size' => 'Mobile number must be exactly 10 characters long',
            'country.required' => 'Country is required',
            'state.required' => 'State is required',
            'city.required' => 'City is required',
            'locality.required' => 'Locality is required',
            'district.required' => 'District is required',
            'pincode.required' => 'Pincode is required',
        ];
    }
}
