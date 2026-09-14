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
         Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained()->onDelete('cascade');

            // Payment Method (which gateway)
            $table->enum('payment_method', [
                'stripe',
                'paypal',
                'cash_on_delivery',
                'bank_transfer',
                'wallet'
            ])->default('stripe');

            // Payment Status
            $table->enum('status', [
                'pending',      // Initial state
                'processing',   // Payment being processed
                'completed',    // Payment successful
                'failed',       // Payment failed
                'refunded',     // Fully refunded
                'partial_refunded', // Partially refunded
                'cancelled',    // Payment cancelled by user
                'on_hold'       // Payment on hold (for COD: waiting for delivery)
            ])->default('pending');

            // Amount fields (all in EGP)
            $table->decimal('amount', 10, 2);
            $table->decimal('refunded_amount', 10, 2)->default(0);
            $table->string('currency')->default('EGP');

            // Transaction IDs (provider-specific)
            $table->string('transaction_id')->nullable()->unique(); // Generic transaction ID
            $table->string('payment_intent_id')->nullable()->unique(); // Stripe PaymentIntent
            $table->string('stripe_session_id')->nullable()->unique(); // Stripe Checkout Session
            $table->string('stripe_charge_id')->nullable()->unique(); // Stripe Charge
            $table->string('paypal_order_id')->nullable()->unique(); // PayPal Order ID
            $table->string('paypal_payer_id')->nullable(); // PayPal Payer ID
            $table->string('paypal_payment_id')->nullable(); // PayPal Payment ID

            // Provider responses (full data)
            $table->json('stripe_response')->nullable(); // Full Stripe response
            $table->json('paypal_response')->nullable(); // Full PayPal response

            // Cash on Delivery specific fields
            $table->timestamp('cod_due_date')->nullable(); // When COD payment is due
            $table->timestamp('cod_collected_at')->nullable(); // When cash was collected
            $table->string('cod_collected_by')->nullable(); // Driver/employee who collected
            $table->text('cod_notes')->nullable(); // Notes about cash collection

            // Payment details
            $table->string('payment_description')->nullable();
            $table->json('metadata')->nullable(); // Additional data

            // Customer details at time of payment
            $table->string('customer_name')->nullable();
            $table->string('customer_email')->nullable();
            $table->string('customer_phone')->nullable();

            // Address details (useful for COD)
            $table->json('billing_address')->nullable();
            $table->json('shipping_address')->nullable();

            // Error tracking
            $table->string('failure_reason')->nullable();
            $table->string('failure_code')->nullable();
            $table->json('failure_response')->nullable();

            // ===== NEW FIELDS FOR REFUND FUNCTIONALITY =====

            // Refund tracking fields
            $table->timestamp('refunded_at')->nullable();
            $table->decimal('refund_amount', 10, 2)->nullable();
            $table->text('refund_reason')->nullable();
            $table->string('refund_transaction_id')->nullable();
            $table->string('stripe_refund_id')->nullable();

            // Additional refund metadata
            $table->json('refund_metadata')->nullable();
            $table->enum('refund_status', [
                'pending',
                'processing',
                'completed',
                'failed'
            ])->nullable();

            // Track multiple refunds (for partial refunds)
            $table->json('refund_history')->nullable();

            // Who processed the refund
            $table->foreignId('refunded_by')->nullable()
                  ->constrained('users');

            // ===== END NEW FIELDS =====

            // Timestamps
            $table->timestamp('paid_at')->nullable();
            $table->timestamp('completed_at')->nullable();

            // Audit fields
            $table->foreignId('created_by')->nullable()->constrained('users');
            $table->foreignId('updated_by')->nullable()->constrained('users');
            $table->foreignId('processed_by')->nullable()->constrained('users');
            $table->timestamps();
            $table->softDeletes();

            // Indexes for performance
            $table->index(['order_id', 'status']);
            $table->index('payment_method');
            $table->index('status');
            $table->index('transaction_id');
            $table->index('payment_intent_id');
            $table->index('stripe_session_id');
            $table->index('paypal_order_id');
            $table->index('created_at');

            // New indexes for refund queries
            $table->index('refund_status');
            $table->index('refunded_at');
            $table->index('stripe_refund_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
