<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ExperienceRequest extends FormRequest
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
            'title' => 'required|string|max:255|min:2',
            'company' => 'nullable|string|max:255|min:2',
            'state' => 'required|string|max:255|min:3',
            'city' => 'required|string|max:255|min:2',
            'start_month' => 'required|string|max:255|min:3',
            'start_year' => 'required|string|size:4',
            'finish_month' => 'nullable|string|max:255|min:3',
            'finish_year' => 'nullable|string|size:3',
            'description' => 'nullable|string',
        ];
    }
    public function messages()
        {
            return [
                'title.required' => 'The title field is required.',
                'title.min' => 'The title must have at least :min characters.',
                'title.max' => 'The title may not be greater than :max characters.',
                'company.min' => 'The company must have at least :min characters.',
                'company.max' => 'The company may not be greater than :max characters.',
                'state.required' => 'The state field is required.',
                'state.min' => 'The state must have at least :min characters.',
                'state.max' => 'The state may not be greater than :max characters.',
                'city.required' => 'The city field is required.',
                'city.min' => 'The city must have at least :min characters.',
                'city.max' => 'The city may not be greater than :max characters.',
                'start_month.required' => 'The start month field is required.',
                'start_month.min' => 'The start month must have at least :min characters.',
                'start_month.max' => 'The start month may not be greater than :max characters.',
                'start_year.required' => 'The start year field is required.',
                'start_year.size' => 'The start year must be :size characters long.',
                'finish_month.min' => 'The finish month must have at least :min characters.',
                'finish_month.max' => 'The finish month may not be greater than :max characters.',
                'finish_year.size' => 'The finish year must be :size characters long.',
            ];
        }
}
