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
        Schema::create('carts', function (Blueprint $table) {
            $table->id();
            $table->string('cart_token')->unique()->nullable();

            $table->string('session_id')->nullable()->index(); // For guest users
            $table->string('ip_address')->nullable();
            $table->timestamp('last_activity')->nullable();

            $table->foreignId('user_id')->nullable()->constrained()->onDelete('cascade'); // For authenticated users
            $table->string('status')->default('active'); // active, processed, abandoned
            $table->timestamp('processed_at')->nullable();
            $table->index(['session_id', 'cart_token']);
            $table->index(['session_id', 'user_id']);

            $table->timestamps();


        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('carts');
    }
};
