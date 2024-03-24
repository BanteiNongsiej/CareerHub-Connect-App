<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class JobRequest extends FormRequest
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
           'title'=>'required|string|max:60|min:2',
           'company_name'=>'nullable|string|max:100',
           'salary'=>'required|string',
           'location'=>'required|string|min:3|max:100',
           'job_type'=>'nullable|string',
           'description'=>'required|string'    
        ];
    }
    public function messages(): array{
        return [
            'title.required'=>'Job title is required',
            'title.max|title.min'=>'Job title should have at least 2 characters and maximum 60 characters',
            'company_name.max'=>'Company name should not have more than 100 characters',
            'salary.required'=>'Salary is required',
            'location.required'=>'Location is required',
            'location.min|location.max'=>'Location should have at least 3 to 100 characters',
            'description'=>'Description about the job is required'
        ];
    }
}
