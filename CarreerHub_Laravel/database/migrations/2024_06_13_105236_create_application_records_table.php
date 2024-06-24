<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('application_records', function (Blueprint $table) {
            $table->id();
            $table->foreignId('candidate_id')->constrained('users');
            $table->foreignId('job_id')->constrained('jobs');
            $table->string('resume')->nullable();
            $table->timestamp('application_date')->useCurrent();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('application_records');
    }
};
