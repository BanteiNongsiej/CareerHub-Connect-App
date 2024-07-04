<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Application_Record extends Model
{
    use HasFactory;
    protected $table='application_records';
    protected $fillable = [
        'candidate_id',
        'job_id',
        'candidate_email',
        'resume',
        'application_date',
    ];
}
