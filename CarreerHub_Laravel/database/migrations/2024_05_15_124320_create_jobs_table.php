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
        Schema::create('jobs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users');
            $table->string('title');
            $table->string('name')->nullable();
            $table->string('street')->nullable();
            $table->string('city');
            $table->string('state');
            $table->string('country');
            $table->string('min_salary');
            $table->string('max_salary')->nullable();
            $table->string('job_type');
            $table->string('shift_type')->nullable();
            $table->string('no_people');
            $table->string('experience_req')->nullable();
            $table->string('qualification_req')->nullable();
            $table->json('skills')->nullable();
            $table->string('description');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jobs');
    }
};
