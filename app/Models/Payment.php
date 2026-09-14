<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Payment extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * Payment methods constants
     */
    const METHOD_STRIPE = 'stripe';
    const METHOD_PAYPAL = 'paypal';
    const METHOD_COD = 'cash_on_delivery';
    const METHOD_BANK_TRANSFER = 'bank_transfer';
    const METHOD_WALLET = 'wallet';

    /**
     * Payment status constants
     */
    const STATUS_PENDING = 'pending';
    const STATUS_PROCESSING = 'processing';
    const STATUS_COMPLETED = 'completed';
    const STATUS_FAILED = 'failed';
    const STATUS_REFUNDED = 'refunded';
    const STATUS_PARTIAL_REFUNDED = 'partial_refunded';
    const STATUS_CANCELLED = 'cancelled';
    const STATUS_ON_HOLD = 'on_hold';

    /**
     * Refund status constants
     */
    const REFUND_STATUS_PENDING = 'pending';
    const REFUND_STATUS_PROCESSING = 'processing';
    const REFUND_STATUS_COMPLETED = 'completed';
    const REFUND_STATUS_FAILED = 'failed';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'order_id',
        'payment_method',
        'status',
        'amount',
        'refunded_amount',
        'currency',
        'transaction_id',
        'payment_intent_id',
        'stripe_session_id',
        'stripe_charge_id',
        'paypal_order_id',
        'paypal_payer_id',
        'paypal_payment_id',
        'stripe_response',
        'paypal_response',
        'cod_due_date',
        'cod_collected_at',
        'cod_collected_by',
        'cod_notes',
        'payment_description',
        'metadata',
        'customer_name',
        'customer_email',
        'customer_phone',
        'billing_address',
        'shipping_address',
        'failure_reason',
        'failure_code',
        'failure_response',
        // Refund fields
        'refunded_at',
        'refund_amount',
        'refund_reason',
        'refund_transaction_id',
        'stripe_refund_id',
        'refund_metadata',
        'refund_status',
        'refund_history',
        'refunded_by',
        'paid_at',
        'completed_at',
        'created_by',
        'updated_by',
        'processed_by'
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'amount' => 'float',
        'refunded_amount' => 'float',
        'refund_amount' => 'float',
        'billing_address' => 'array',
        'shipping_address' => 'array',
        'stripe_response' => 'array',
        'paypal_response' => 'array',
        'metadata' => 'array',
        'failure_response' => 'array',
        'refund_metadata' => 'array',
        'refund_history' => 'array',
        'cod_due_date' => 'datetime',
        'cod_collected_at' => 'datetime',
        'refunded_at' => 'datetime',
        'paid_at' => 'datetime',
        'completed_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    /**
     * The model's default values for attributes.
     *
     * @var array
     */
    protected $attributes = [
        'currency' => 'EGP',
        'status' => self::STATUS_PENDING,
        'refunded_amount' => 0,
    ];

    /**
     * Get the order that owns the payment.
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the user who created the payment.
     */
    public function createdBy()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the user who last updated the payment.
     */
    public function updatedBy()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }

    /**
     * Get the user who processed the payment (for COD).
     */
    public function processedBy()
    {
        return $this->belongsTo(User::class, 'processed_by');
    }

    /**
     * Get the user who processed the refund.
     */
    public function refundedBy()
    {
        return $this->belongsTo(User::class, 'refunded_by');
    }

    /**
     * Scope a query to only include payments with specific status.
     */
    public function scopeStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope a query to only include payments with specific method.
     */
    public function scopeMethod($query, $method)
    {
        return $query->where('payment_method', $method);
    }

    /**
     * Scope a query to only include completed payments.
     */
    public function scopeCompleted($query)
    {
        return $query->where('status', self::STATUS_COMPLETED);
    }

    /**
     * Scope a query to only include failed payments.
     */
    public function scopeFailed($query)
    {
        return $query->where('status', self::STATUS_FAILED);
    }

    /**
     * Scope a query to only include refunded payments.
     */
    public function scopeRefunded($query)
    {
        return $query->whereIn('status', [self::STATUS_REFUNDED, self::STATUS_PARTIAL_REFUNDED]);
    }

    /**
     * Scope a query to only include COD payments.
     */
    public function scopeCod($query)
    {
        return $query->where('payment_method', self::METHOD_COD);
    }

    /**
     * Scope a query to only include payments with specific refund status.
     */
    public function scopeRefundStatus($query, $status)
    {
        return $query->where('refund_status', $status);
    }

    /**
     * Scope a query to only include payments created between dates.
     */
    public function scopeCreatedBetween($query, $startDate, $endDate)
    {
        return $query->whereBetween('created_at', [$startDate, $endDate]);
    }

    /**
     * Scope a query to only include payments refunded between dates.
     */
    public function scopeRefundedBetween($query, $startDate, $endDate)
    {
        return $query->whereBetween('refunded_at', [$startDate, $endDate]);
    }

    /**
     * Get the formatted amount with currency symbol.
     */
    protected function formattedAmount(): Attribute
    {
        return Attribute::get(function () {
            return $this->currency_symbol . ' ' . number_format($this->amount, 2);
        });
    }

    /**
     * Get the formatted refunded amount.
     */
    protected function formattedRefundedAmount(): Attribute
    {
        return Attribute::get(function () {
            return $this->currency_symbol . ' ' . number_format($this->refunded_amount, 2);
        });
    }

    /**
     * Get the formatted refund amount.
     */
    protected function formattedRefundAmount(): Attribute
    {
        return Attribute::get(function () {
            return $this->refund_amount ? $this->currency_symbol . ' ' . number_format($this->refund_amount, 2) : null;
        });
    }

    /**
     * Get the remaining amount (amount - refunded_amount).
     */
    protected function remainingAmount(): Attribute
    {
        return Attribute::get(fn () => $this->amount - $this->refunded_amount);
    }

    /**
     * Check if payment is completed.
     */
    protected function isCompleted(): Attribute
    {
        return Attribute::get(fn () => $this->status === self::STATUS_COMPLETED);
    }

    /**
     * Check if payment is failed.
     */
    protected function isFailed(): Attribute
    {
        return Attribute::get(fn () => $this->status === self::STATUS_FAILED);
    }

    /**
     * Check if payment is refunded.
     */
    protected function isRefunded(): Attribute
    {
        return Attribute::get(fn () => $this->status === self::STATUS_REFUNDED);
    }

    /**
     * Check if payment is partially refunded.
     */
    protected function isPartiallyRefunded(): Attribute
    {
        return Attribute::get(fn () => $this->status === self::STATUS_PARTIAL_REFUNDED);
    }

    /**
     * Check if payment is for COD.
     */
    protected function isCod(): Attribute
    {
        return Attribute::get(fn () => $this->payment_method === self::METHOD_COD);
    }

    /**
     * Check if refund is pending.
     */
    protected function isRefundPending(): Attribute
    {
        return Attribute::get(fn () => $this->refund_status === self::REFUND_STATUS_PENDING);
    }

    /**
     * Check if refund is processing.
     */
    protected function isRefundProcessing(): Attribute
    {
        return Attribute::get(fn () => $this->refund_status === self::REFUND_STATUS_PROCESSING);
    }

    /**
     * Check if refund is completed.
     */
    protected function isRefundCompleted(): Attribute
    {
        return Attribute::get(fn () => $this->refund_status === self::REFUND_STATUS_COMPLETED);
    }

    /**
     * Check if refund failed.
     */
    protected function isRefundFailed(): Attribute
    {
        return Attribute::get(fn () => $this->refund_status === self::REFUND_STATUS_FAILED);
    }

    /**
     * Get the currency symbol.
     */
    protected function currencySymbol(): Attribute
    {
        return Attribute::get(function () {
            $symbols = [
                'EGP' => 'E£',
                'USD' => '$',
                'EUR' => '€',
            ];
            return $symbols[$this->currency] ?? $this->currency;
        });
    }

    /**
     * Get payment method display name.
     */
    protected function paymentMethodDisplay(): Attribute
    {
        return Attribute::get(function () {
            $methods = [
                self::METHOD_STRIPE => 'Credit/Debit Card',
                self::METHOD_PAYPAL => 'PayPal',
                self::METHOD_COD => 'Cash on Delivery',
                self::METHOD_BANK_TRANSFER => 'Bank Transfer',
                self::METHOD_WALLET => 'Wallet',
            ];
            return $methods[$this->payment_method] ?? $this->payment_method;
        });
    }

    /**
     * Get status display name.
     */
    protected function statusDisplay(): Attribute
    {
        return Attribute::get(function () {
            $statuses = [
                self::STATUS_PENDING => 'Pending',
                self::STATUS_PROCESSING => 'Processing',
                self::STATUS_COMPLETED => 'Completed',
                self::STATUS_FAILED => 'Failed',
                self::STATUS_REFUNDED => 'Refunded',
                self::STATUS_PARTIAL_REFUNDED => 'Partially Refunded',
                self::STATUS_CANCELLED => 'Cancelled',
                self::STATUS_ON_HOLD => 'On Hold',
            ];
            return $statuses[$this->status] ?? $this->status;
        });
    }

    /**
     * Get refund status display name.
     */
    protected function refundStatusDisplay(): Attribute
    {
        return Attribute::get(function () {
            if (!$this->refund_status) return null;

            $statuses = [
                self::REFUND_STATUS_PENDING => 'Pending',
                self::REFUND_STATUS_PROCESSING => 'Processing',
                self::REFUND_STATUS_COMPLETED => 'Completed',
                self::REFUND_STATUS_FAILED => 'Failed',
            ];
            return $statuses[$this->refund_status] ?? $this->refund_status;
        });
    }

    /**
     * Mark payment as completed.
     */
    public function markAsCompleted($transactionData = null)
    {
        $this->status = self::STATUS_COMPLETED;
        $this->paid_at = now();
        $this->completed_at = now();

        if ($transactionData) {
            if (isset($transactionData['transaction_id'])) {
                $this->transaction_id = $transactionData['transaction_id'];
            }
            if (isset($transactionData['stripe_charge_id'])) {
                $this->stripe_charge_id = $transactionData['stripe_charge_id'];
            }
            if (isset($transactionData['stripe_response'])) {
                $this->stripe_response = $transactionData['stripe_response'];
            }
            if (isset($transactionData['paypal_payment_id'])) {
                $this->paypal_payment_id = $transactionData['paypal_payment_id'];
            }
            if (isset($transactionData['paypal_response'])) {
                $this->paypal_response = $transactionData['paypal_response'];
            }
        }

        $this->save();

        // Update order payment status
        if ($this->order) {
            $this->order->update([
                'payment_status' => 'paid',
                'paid_at' => now()
            ]);
        }

        return $this;
    }

    /**
     * Mark payment as failed.
     */
    public function markAsFailed($reason = null, $code = null, $response = null)
    {
        $this->status = self::STATUS_FAILED;
        $this->failure_reason = $reason;
        $this->failure_code = $code;

        if ($response) {
            $this->failure_response = $response;
        }

        $this->save();

        // Update order payment status
        if ($this->order) {
            $this->order->update([
                'payment_status' => 'failed'
            ]);
        }

        return $this;
    }

    /**
     * Process a refund.
     */
    public function refund($amount = null, $reason = null, $refundData = [])
    {
        $refundAmount = $amount ?? $this->amount;
        $newRefundedAmount = $this->refunded_amount + $refundAmount;

        // Update refund fields
        $this->refund_amount = $refundAmount;
        $this->refund_reason = $reason;
        $this->refunded_at = now();
        $this->refund_status = self::REFUND_STATUS_COMPLETED;
        $this->refunded_amount = $newRefundedAmount;

        // Set refund transaction IDs if provided
        if (isset($refundData['transaction_id'])) {
            $this->refund_transaction_id = $refundData['transaction_id'];
        }
        if (isset($refundData['stripe_refund_id'])) {
            $this->stripe_refund_id = $refundData['stripe_refund_id'];
        }
        if (isset($refundData['metadata'])) {
            $this->refund_metadata = $refundData['metadata'];
        }
        if (isset($refundData['refunded_by'])) {
            $this->refunded_by = $refundData['refunded_by'];
        }

        // Determine new status
        if ($newRefundedAmount >= $this->amount) {
            $this->status = self::STATUS_REFUNDED;
        } else {
            $this->status = self::STATUS_PARTIAL_REFUNDED;
        }

        // Add to refund history
        $this->addRefundHistory([
            'amount' => $refundAmount,
            'reason' => $reason,
            'transaction_id' => $refundData['transaction_id'] ?? null,
            'stripe_refund_id' => $refundData['stripe_refund_id'] ?? null,
            'status' => self::REFUND_STATUS_COMPLETED,
            'processed_by' => $refundData['refunded_by'] ?? null
        ]);

        $this->save();

        // Update order if fully refunded
        if ($this->status === self::STATUS_REFUNDED && $this->order) {
            $this->order->update([
                'payment_status' => 'refunded',
                'refunded_at' => now(),
                'refund_reason' => $reason
            ]);
        } elseif ($this->order) {
            $this->order->update([
                'payment_status' => 'partially_refunded'
            ]);
        }

        return $this;
    }

    /**
     * Initialize a refund (for pending/processing status).
     */
    public function initiateRefund($amount = null, $reason = null, $refundData = [])
    {
        $this->refund_status = self::REFUND_STATUS_PENDING;
        $this->refund_amount = $amount ?? $this->amount;
        $this->refund_reason = $reason;

        if (isset($refundData['refunded_by'])) {
            $this->refunded_by = $refundData['refunded_by'];
        }

        // Add to refund history
        $this->addRefundHistory([
            'amount' => $amount ?? $this->amount,
            'reason' => $reason,
            'status' => self::REFUND_STATUS_PENDING,
            'initiated_at' => now(),
            'initiated_by' => $refundData['refunded_by'] ?? null
        ]);

        $this->save();

        return $this;
    }

    /**
     * Mark refund as processing.
     */
    public function markRefundAsProcessing($refundData = [])
    {
        $this->refund_status = self::REFUND_STATUS_PROCESSING;

        if (isset($refundData['transaction_id'])) {
            $this->refund_transaction_id = $refundData['transaction_id'];
        }

        $this->save();

        return $this;
    }

    /**
     * Mark refund as failed.
     */
    public function markRefundAsFailed($reason = null, $failureData = [])
    {
        $this->refund_status = self::REFUND_STATUS_FAILED;
        $this->failure_reason = $reason;

        if (isset($failureData['failure_code'])) {
            $this->failure_code = $failureData['failure_code'];
        }
        if (isset($failureData['failure_response'])) {
            $this->failure_response = $failureData['failure_response'];
        }

        // Add to refund history
        $this->addRefundHistory([
            'amount' => $this->refund_amount,
            'reason' => $reason,
            'status' => self::REFUND_STATUS_FAILED,
            'failed_at' => now()
        ]);

        $this->save();

        return $this;
    }

    /**
     * Add entry to refund history.
     */
    public function addRefundHistory($entry)
    {
        $history = $this->refund_history ?? [];
        $history[] = array_merge($entry, [
            'timestamp' => now()->toDateTimeString()
        ]);

        $this->refund_history = $history;

        return $this;
    }

    /**
     * Mark COD as collected.
     */
    public function markCodAsCollected($collectedBy = null, $notes = null)
    {
        if ($this->payment_method !== self::METHOD_COD) {
            return false;
        }

        $this->cod_collected_at = now();
        $this->cod_collected_by = $collectedBy;
        $this->cod_notes = $notes;
        $this->status = self::STATUS_COMPLETED;
        $this->paid_at = now();
        $this->completed_at = now();
        $this->save();

        // Update order payment status
        if ($this->order) {
            $this->order->update([
                'payment_status' => 'paid',
                'paid_at' => now()
            ]);
        }

        return true;
    }

    /**
     * Get refund history summary.
     */
    protected function refundHistorySummary(): Attribute
    {
        return Attribute::get(function () {
            if (!$this->refund_history) {
                return [];
            }

            return array_map(function ($entry) {
                return [
                    'amount' => $entry['amount'] ?? null,
                    'reason' => $entry['reason'] ?? null,
                    'status' => $entry['status'] ?? null,
                    'timestamp' => $entry['timestamp'] ?? null,
                    'transaction_id' => $entry['transaction_id'] ?? null
                ];
            }, $this->refund_history);
        });
    }

    /**
     * Check if can be refunded.
     */
    protected function canBeRefunded(): Attribute
    {
        return Attribute::get(function () {
            // Can refund if payment is completed and not fully refunded
            return $this->status === self::STATUS_COMPLETED &&
                   $this->refunded_amount < $this->amount;
        });
    }

    /**
     * Get available refund amount.
     */
    protected function availableRefundAmount(): Attribute
    {
        return Attribute::get(fn () => $this->amount - $this->refunded_amount);
    }

    /**
     * Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($payment) {
            // Set COD due date for COD payments
            if ($payment->payment_method === self::METHOD_COD && !$payment->cod_due_date) {
                $payment->cod_due_date = now()->addDays(7);
            }
        });

        static::updated(function ($payment) {
            // Update order payment status based on payment status
            if ($payment->isDirty('status') && $payment->order) {
                $orderStatusMap = [
                    self::STATUS_COMPLETED => 'paid',
                    self::STATUS_FAILED => 'failed',
                    self::STATUS_REFUNDED => 'refunded',
                    self::STATUS_PARTIAL_REFUNDED => 'partially_refunded',
                    self::STATUS_CANCELLED => 'cancelled',
                    self::STATUS_ON_HOLD => 'on_hold',
                ];

                if (isset($orderStatusMap[$payment->status])) {
                    $payment->order->update([
                        'payment_status' => $orderStatusMap[$payment->status]
                    ]);
                }
            }
        });
    }
}
