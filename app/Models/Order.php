<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Order extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * Order status constants
     */
    const STATUS_PENDING = 'pending';
    const STATUS_PROCESSING = 'processing';
    const STATUS_PAID = 'paid';
    const STATUS_COMPLETED = 'completed';
    const STATUS_CANCELLED = 'cancelled';
    const STATUS_REFUNDED = 'refunded';
    const STATUS_PARTIALLY_REFUNDED = 'partially_refunded';

    /**
     * Payment status constants
     */
    const PAYMENT_UNPAID = 'unpaid';
    const PAYMENT_PAID = 'paid';
    const PAYMENT_FAILED = 'failed';
    const PAYMENT_REFUNDED = 'refunded';
    const PAYMENT_PARTIALLY_REFUNDED = 'partially_refunded';

    /**
     * Shipping status constants
     */
    const SHIPPING_PENDING = 'pending';
    const SHIPPING_PROCESSING = 'processing';
    const SHIPPING_SHIPPED = 'shipped';
    const SHIPPING_DELIVERED = 'delivered';
    const SHIPPING_CANCELLED  = 'cancelled';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'order_number',
        'user_id',
        'subtotal',
        'tax',
        'shipping_cost',
        'discount',
        'discount_code',
        'discount_type',
        'total',
        'currency',
        'currency_symbol',
        'status',
        'payment_status',
        'payment_method',
        'shipping_status',
        'shipping_address',
        'billing_address',
        'tracking_number',
        'shipping_carrier',
        'shipping_method',
        'shipping_notes',
        'customer_notes',
        'admin_notes',
        // Refund fields
        'refunded_at',
        'refunded_total',
        'refund_reason',
        'refund_status',
        'partial_refunds',
        'refunded_by',
        'paid_at',
        'shipped_at',
        'delivered_at',
        'cancelled_at',
        'created_by',
        'updated_by',
        'cancelled_by',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'shipping_address' => 'array',
        'billing_address' => 'array',
        'partial_refunds' => 'array',
        'subtotal' => 'decimal:2',
        'tax' => 'decimal:2',
        'shipping_cost' => 'decimal:2',
        'discount' => 'decimal:2',
        'total' => 'decimal:2',
        'refunded_total' => 'decimal:2',
        'paid_at' => 'datetime',
        'shipped_at' => 'datetime',
        'delivered_at' => 'datetime',
        'cancelled_at' => 'datetime',
        'refunded_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'admin_notes',
    ];

    /**
     * The model's default values for attributes.
     *
     * @var array
     */
    protected $attributes = [
        'currency' => 'EGP',
        'currency_symbol' => 'E£',
        'status' => self::STATUS_PENDING,
        'payment_status' => self::PAYMENT_UNPAID,
        'shipping_status' => self::SHIPPING_PENDING,
        'refunded_total' => 0,
    ];

    /**
     * Get the user that owns the order.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the items for the order.
     */
    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }

    /**
     * Get the payments for the order.
     */
    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    /**
     * Get the user who created the order.
     */
    public function createdBy()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the user who last updated the order.
     */
    public function updatedBy()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }

    /**
     * Get the user who cancelled the order.
     */
    public function cancelledBy()
    {
        return $this->belongsTo(User::class, 'cancelled_by');
    }

    /**
     * Get the user who refunded the order.
     */
    public function refundedBy()
    {
        return $this->belongsTo(User::class, 'refunded_by');
    }

    /**
     * Scope a query to only include orders with specific status.
     */
    public function scopeStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope a query to only include orders with specific payment status.
     */
    public function scopePaymentStatus($query, $status)
    {
        return $query->where('payment_status', $status);
    }

    /**
     * Scope a query to only include orders with specific shipping status.
     */
    public function scopeShippingStatus($query, $status)
    {
        return $query->where('shipping_status', $status);
    }

    /**
     * Scope a query to only include refunded orders.
     */
    public function scopeRefunded($query)
    {
        return $query->whereIn('payment_status', [
            self::PAYMENT_REFUNDED,
            self::PAYMENT_PARTIALLY_REFUNDED
        ]);
    }

    /**
     * Scope a query to only include orders created between dates.
     */
    public function scopeCreatedBetween($query, $startDate, $endDate)
    {
        return $query->whereBetween('created_at', [$startDate, $endDate]);
    }

    /**
     * Scope a query to only include orders refunded between dates.
     */
    public function scopeRefundedBetween($query, $startDate, $endDate)
    {
        return $query->whereBetween('refunded_at', [$startDate, $endDate]);
    }

    /**
     * Scope a query to only include orders by user.
     */
    public function scopeByUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Get the formatted subtotal with currency symbol.
     */
    protected function formattedSubtotal(): Attribute
    {
        return Attribute::get(fn () => $this->currency_symbol . ' ' . number_format($this->subtotal, 2));
    }

    /**
     * Get the formatted total with currency symbol.
     */
    protected function formattedTotal(): Attribute
    {
        return Attribute::get(fn () => $this->currency_symbol . ' ' . number_format($this->total, 2));
    }

    /**
     * Get the formatted refunded total.
     */
    protected function formattedRefundedTotal(): Attribute
    {
        return Attribute::get(fn () => $this->refunded_total > 0
            ? $this->currency_symbol . ' ' . number_format($this->refunded_total, 2)
            : null);
    }

    /**
     * Get the remaining amount (total - refunded_total).
     */
    protected function remainingAmount(): Attribute
    {
        return Attribute::get(fn () => $this->total - $this->refunded_total);
    }

    /**
     * Get the formatted remaining amount.
     */
    protected function formattedRemainingAmount(): Attribute
    {
        return Attribute::get(fn () => $this->currency_symbol . ' ' . number_format($this->remaining_amount, 2));
    }

    /**
     * Check if order is paid.
     */
    protected function isPaid(): Attribute
    {
        return Attribute::get(fn () => $this->payment_status === self::PAYMENT_PAID);
    }

    /**
     * Check if order is shipped.
     */
    protected function isShipped(): Attribute
    {
        return Attribute::get(fn () => in_array($this->shipping_status, [
            self::SHIPPING_SHIPPED,
            self::SHIPPING_DELIVERED
        ]));
    }

    /**
     * Check if order is delivered.
     */
    protected function isDelivered(): Attribute
    {
        return Attribute::get(fn () => $this->shipping_status === self::SHIPPING_DELIVERED);
    }

    /**
     * Check if order is cancelled.
     */
    protected function isCancelled(): Attribute
    {
        return Attribute::get(fn () => $this->status === self::STATUS_CANCELLED);
    }

    /**
     * Check if order is refunded.
     */
    protected function isRefunded(): Attribute
    {
        return Attribute::get(fn () => $this->payment_status === self::PAYMENT_REFUNDED);
    }

    /**
     * Check if order is partially refunded.
     */
    protected function isPartiallyRefunded(): Attribute
    {
        return Attribute::get(fn () => $this->payment_status === self::PAYMENT_PARTIALLY_REFUNDED);
    }

    /**
     * Check if order can be refunded.
     */
    protected function canBeRefunded(): Attribute
    {
        return Attribute::get(function () {
            // Can refund if order is paid and not fully refunded
            return $this->payment_status === self::PAYMENT_PAID &&
                   $this->refunded_total < $this->total;
        });
    }

    /**
     * Get available refund amount.
     */
    protected function availableRefundAmount(): Attribute
    {
        return Attribute::get(fn () => $this->total - $this->refunded_total);
    }

    /**
     * Get refund progress percentage.
     */
    protected function refundProgress(): Attribute
    {
        return Attribute::get(function () {
            if ($this->total == 0) return 0;
            return round(($this->refunded_total / $this->total) * 100);
        });
    }

    /**
     * Get the shipping address as a formatted string.
     */
    protected function shippingAddressString(): Attribute
    {
        return Attribute::get(function () {
            $address = $this->shipping_address;
            if (!$address) return '';

            $parts = [
                $address['name'] ?? '',
                $address['address_line1'] ?? '',
                $address['address_line2'] ?? '',
                $address['city'] ?? '',
                $address['state'] ?? '',
                $address['postal_code'] ?? '',
                $address['country'] ?? ''
            ];

            return implode(', ', array_filter($parts));
        });
    }

    /**
     * Get the billing address as a formatted string.
     */
    protected function billingAddressString(): Attribute
    {
        return Attribute::get(function () {
            $address = $this->billing_address;
            if (!$address) return '';

            $parts = [
                $address['name'] ?? '',
                $address['address_line1'] ?? '',
                $address['address_line2'] ?? '',
                $address['city'] ?? '',
                $address['state'] ?? '',
                $address['postal_code'] ?? '',
                $address['country'] ?? ''
            ];

            return implode(', ', array_filter($parts));
        });
    }

    /**
     * Process a refund on the order.
     */
    public function processRefund($amount = null, $reason = null, $refundedBy = null)
    {
        $refundAmount = $amount ?? $this->total;
        $newRefundedTotal = $this->refunded_total + $refundAmount;

        // Update refund fields
        $this->refunded_total = $newRefundedTotal;
        $this->refund_reason = $reason;
        $this->refunded_at = now();
        $this->refunded_by = $refundedBy;

        // Determine payment status
        if ($newRefundedTotal >= $this->total) {
            $this->payment_status = self::PAYMENT_REFUNDED;
            $this->status = self::STATUS_REFUNDED;
        } else {
            $this->payment_status = self::PAYMENT_PARTIALLY_REFUNDED;
            $this->status = self::STATUS_PARTIALLY_REFUNDED;
        }

        // Add to partial refunds history
        $partialRefunds = $this->partial_refunds ?? [];
        $partialRefunds[] = [
            'amount' => $refundAmount,
            'reason' => $reason,
            'refunded_at' => now()->toDateTimeString(),
            'refunded_by' => $refundedBy
        ];
        $this->partial_refunds = $partialRefunds;

        $this->save();

        return $this;
    }

    /**
     * Get refund summary.
     */
    protected function refundSummary(): Attribute
    {
        return Attribute::get(function () {
            if ($this->refunded_total == 0) {
                return null;
            }

            return [
                'total_refunded' => $this->refunded_total,
                'formatted_total_refunded' => $this->formatted_refunded_total,
                'remaining' => $this->remaining_amount,
                'formatted_remaining' => $this->formatted_remaining_amount,
                'progress' => $this->refund_progress,
                'is_fully_refunded' => $this->is_refunded,
                'is_partially_refunded' => $this->is_partially_refunded,
                'refunded_at' => $this->refunded_at,
                'refund_reason' => $this->refund_reason,
                'partial_refunds' => $this->partial_refunds
            ];
        });
    }

    /**
     * Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($order) {
            if (empty($order->order_number)) {
                $order->order_number = static::generateOrderNumber();
            }
        });

        static::updating(function ($order) {
            // Update timestamps based on status changes
            if ($order->isDirty('payment_status') && $order->payment_status === self::PAYMENT_PAID && !$order->paid_at) {
                $order->paid_at = now();
            }

            if ($order->isDirty('shipping_status')) {
                if ($order->shipping_status === self::SHIPPING_SHIPPED && !$order->shipped_at) {
                    $order->shipped_at = now();
                } elseif ($order->shipping_status === self::SHIPPING_DELIVERED && !$order->delivered_at) {
                    $order->delivered_at = now();
                }
            }

            if ($order->isDirty('status') && $order->status === self::STATUS_CANCELLED && !$order->cancelled_at) {
                $order->cancelled_at = now();
            }

            if ($order->isDirty('payment_status') && in_array($order->payment_status, [
                self::PAYMENT_REFUNDED,
                self::PAYMENT_PARTIALLY_REFUNDED
            ]) && !$order->refunded_at) {
                $order->refunded_at = now();
            }
        });
    }

    /**
     * Generate a unique order number.
     */
    protected static function generateOrderNumber()
    {
        $prefix = 'ORD-';
        $date = now()->format('Ymd');
        $random = strtoupper(substr(uniqid(), -6));

        return $prefix . $date . '-' . $random;
    }
}
