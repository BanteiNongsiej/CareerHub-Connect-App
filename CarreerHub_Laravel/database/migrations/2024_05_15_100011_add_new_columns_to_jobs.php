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
        Schema::table('jobs', function (Blueprint $table) {
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
            $table->foreignId('skills_id')->constrained('skills');
            $table->string('description');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('jobs', function (Blueprint $table) {
            $table->dropColumn('name');
            $table->dropColumn('street');
            $table->dropColumn('city');
            $table->dropColumn('state');
            $table->dropColumn('country');
            $table->dropColumn('min_salary');
            $table->dropColumn('max_salary');
            $table->dropColumn('job_type');
            $table->dropColumn('shift_type');
            $table->dropColumn('no_people');
            $table->dropColumn('experience_req');
            $table->dropColumn('qualification_req');
            $table->dropColumn('skills_id');
            $table->dropColumn('description');
        });
    }
};
