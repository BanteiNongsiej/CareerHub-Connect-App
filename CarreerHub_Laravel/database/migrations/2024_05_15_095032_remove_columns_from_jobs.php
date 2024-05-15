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
            $table->dropColumn('company_name');
            $table->dropColumn('salary');
            $table->dropColumn('location');
            $table->dropColumn('job_type');
            $table->dropColumn('description');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('jobs', function (Blueprint $table) {
            $table->string('company_name');
            $table->string('salary');
            $table->string('location');
            $table->string('job_type');
            $table->string('description');
        });
    }
};
