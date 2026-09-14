<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
     public function up(): void
    {
     Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number')->unique();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');

            // Financial fields (all in EGP)
            $table->decimal('subtotal', 10, 2);
            $table->decimal('tax', 10, 2)->default(0);
            $table->decimal('shipping_cost', 10, 2)->default(0);
            $table->decimal('discount', 10, 2)->default(0);
            $table->decimal('total', 10, 2);
            $table->string('currency')->default('EGP');
            $table->string('currency_symbol')->default('E£');

            $table->string('discount_code')->nullable();;
            $table->string('discount_type')->nullable();;


            // Status fields
            $table->string('status')->default('pending'); // pending, processing, paid, completed, cancelled, refunded, partially_refunded
            $table->string('payment_status')->default('unpaid'); // unpaid, paid, failed, refunded, partially_refunded
            $table->string('payment_method')->nullable(); // stripe, cash_on_delivery
            $table->string('shipping_status')->default('pending'); // pending, processing, shipped, delivered

            // Addresses (stored as JSON for historical accuracy)
            $table->json('shipping_address');
            $table->json('billing_address');

            // Shipping tracking
            $table->string('tracking_number')->nullable(); // Carrier tracking number
            $table->string('shipping_carrier')->nullable(); // DHL, FedEx, Aramex, Egypt Post
            $table->string('shipping_method')->nullable(); // Standard, Express, etc.
            $table->text('shipping_notes')->nullable();

            // Order notes
            $table->text('customer_notes')->nullable();
            $table->text('admin_notes')->nullable();

            // ===== REFUND FIELDS =====

            // Refund tracking
            $table->timestamp('refunded_at')->nullable();
            $table->decimal('refunded_total', 10, 2)->default(0); // Total amount refunded
            $table->text('refund_reason')->nullable(); // Reason for refund
            $table->string('refund_status')->nullable(); // pending, processing, completed, failed

            // Partial refund support
            $table->json('partial_refunds')->nullable(); // Track multiple partial refunds

            // Who processed the refund
            $table->foreignId('refunded_by')->nullable()->constrained('users');

            // ===== END REFUND FIELDS =====

            // Timestamps for order progress
            $table->timestamp('paid_at')->nullable();
            $table->timestamp('shipped_at')->nullable();
            $table->timestamp('delivered_at')->nullable();
            $table->timestamp('cancelled_at')->nullable();

            // Audit fields
            $table->foreignId('created_by')->constrained('users');
            $table->foreignId('updated_by')->constrained('users');
            $table->foreignId('cancelled_by')->nullable()->constrained('users');

            $table->timestamps();
            $table->softDeletes();

            // Indexes for performance
            $table->index('order_number');
            $table->index(['user_id', 'status']);
            $table->index(['payment_status', 'status']);
            $table->index('tracking_number');
            $table->index('shipping_status');
            $table->index('created_at');

            // New indexes for refund queries
            $table->index('refund_status');
            $table->index('refunded_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
