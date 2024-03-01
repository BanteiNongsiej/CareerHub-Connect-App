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
           'title'=>'required|string|max:60',
           'company_name'=>'nullable|string|max:100',
           'salary'=>'required|integer',
           'location'=>'required|string|min:3|max:100',
           'job_type'=>'nullable|string',
           'descrition'=>'required|string'    
        ];
    }
}
