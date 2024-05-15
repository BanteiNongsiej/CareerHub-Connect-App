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
        Schema::create('education', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users');
            $table->string('level');
            $table->string('field')->nullable();
            $table->string('school_name');
            $table->string('state');
            $table->string('city');
            $table->string('locality');
            $table->string('pincode');
            $table->string('start_month');
            $table->string('start_year');
            $table->string('finish_month')->nullable();
            $table->string('finish_year')->nullable();
            $table->string('grade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('education');
    }
};
