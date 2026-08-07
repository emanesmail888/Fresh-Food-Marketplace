<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\User;


return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('title', 255);
            $table->string('slug', 255);
            $table->string('title_ar', 255);
            $table->string('image')->nullable();
            $table->text('images')->nullable();
            $table->longText('description')->nullable();
            $table->longText('description_ar')->nullable();
            $table->decimal('price', 10, 2);
            $table->decimal('sale_price', 10, 2)->nullable();
            $table->integer('stock');
            $table->enum('unit', ['kg','g','piece','liter','pack','bunch'])->default('kg');
            $table->decimal('weight_per_unit', 12, 3)->default(1000);// 1000 = 1 kg, 1 = 1 g, 500 = 0.5 kg
            $table->unsignedBigInteger('category_id');
            $table->tinyInteger('new_arrival')->default('0')->nullable();
            $table->foreign('category_id')->references('id')->on('categories')->onDelete(('cascade'));
            $table->softDeletes();
            $table->foreignIdFor(User::class, 'deleted_by')->nullable();
            $table->timestamps();


             // ============ INDEXES FOR PERFORMANCE ============

            // For shop() - search functionality
            $table->index('title');
            $table->index('title_ar');

            // For shop() - sorting
            $table->index('created_at');
            $table->index('updated_at');

            // For home() - unit filtering
            $table->index('unit');

            // For soft deletes (exclude deleted records automatically)
            $table->index('deleted_at');

            // For WHERE HAS queries with categories
            $table->index('category_id');

            // Composite indexes for common query patterns
            $table->index(['unit', 'deleted_at']);  // For home() whereIn query
            $table->index(['category_id', 'deleted_at']);  // For category filtering
            $table->index(['created_at', 'deleted_at']);  // For shop() sorting with soft deletes

            $table->index(['price', 'sale_price']);

            // Full-text index for better search performance (RECOMMENDED)
            $table->fullText('title');  // For faster text search
            $table->fullText('title_ar');  // For faster text search in Arabic

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
