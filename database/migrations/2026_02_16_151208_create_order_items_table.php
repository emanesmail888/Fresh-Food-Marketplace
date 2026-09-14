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
        Schema::create('order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained()->onDelete('cascade');
            $table->foreignId('product_id')->constrained()->onDelete('cascade');

            // Product snapshot at time of order
            $table->string('product_name');
            $table->string('product_image')->nullable();

            // Pricing (in EGP)
            $table->decimal('unit_price', 10, 2); // Price per unit in EGP
            $table->decimal('unit_cost', 10, 2)->nullable(); // Cost for profit calculation
            $table->decimal('quantity_grams', 12, 3)->default(0);
            $table->decimal('total', 10, 2);
            $table->decimal('discount', 10, 2)->default(0);

            // Product details at time of order
            $table->string('unit')->default('kg');
            $table->decimal('weight', 8, 2)->nullable();
            $table->json('options')->nullable(); // Selected variations

            $table->timestamps();

            $table->index(['order_id', 'product_id']);
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_items');
    }
};
