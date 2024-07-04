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
            $table->dropColumn('skills'); // Drop the existing JSON skills column
        });

        Schema::table('jobs', function (Blueprint $table) {
            $table->string('skills')->nullable(); // Add the new string skills column
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('jobs', function (Blueprint $table) {
            $table->dropColumn('skills'); // Drop the new string skills column
        });

        Schema::table('jobs', function (Blueprint $table) {
            $table->json('skills')->nullable(); // Re-add the original JSON skills column
        });
    }
};
