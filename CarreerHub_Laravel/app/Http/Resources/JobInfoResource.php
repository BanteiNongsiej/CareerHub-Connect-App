<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class JobInfoResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'title'=>$this->title,
            'company_name'=>$this->company_name,
            'salary'=>$this->salary,
            'location'=>$this->location,
            'job_type'=>$this->job_type,
            'description'=>$this->description
        ];
    }
}
