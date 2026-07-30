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
        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('title_ar')->nullable();
            $table->string('description');
            $table->string('description_ar')->nullable();
            $table->text('image');
            $table->timestamps();
            $table->index('title');
            $table->index('title_ar');
            $table->index('description');
            $table->index('description_ar');
            $table->index('image');

            // Composite index for queries that filter on both title fields
            $table->index(['title', 'title_ar']);

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
        Schema::dropIfExists('services');
    }
};
