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
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('name_ar')->nullable();
            $table->text('image');
            $table->timestamps();
            $table->index('name');

            $table->index('name_ar');

            // Composite index for queries that filter on both name fields
            $table->index(['name', 'name_ar']);

            // For sorting/ordering by timestamps
            $table->index('created_at');
            $table->index('updated_at');


        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
