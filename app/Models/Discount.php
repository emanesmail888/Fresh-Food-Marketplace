<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


class Discount extends Model
{
    protected $fillable = [
        'code', 'type', 'value', 'min_order_amount',
        'max_discount_amount', 'expires_at', 'usage_limit',
        'used_count', 'is_active'
    ];

    protected $casts = [
        'expires_at' => 'datetime',
        'is_active' => 'boolean'
    ];

    public function isValid()
    {
        if (!$this->is_active) return false;
        if ($this->expires_at && $this->expires_at->isPast()) return false;
        if ($this->usage_limit && $this->used_count >= $this->usage_limit) return false;
        return true;
    }

    public function calculateDiscount($subtotal)
    {
        if (!$this->isValid()) return 0;
        if ($this->min_order_amount && $subtotal < $this->min_order_amount) return 0;

        if ($this->type === 'percentage') {
            $discount = $subtotal * ($this->value / 100);
            return $this->max_discount_amount ? min($discount, $this->max_discount_amount) : $discount;
        }

        if ($this->type === 'fixed') {
            return min($this->value, $subtotal);
        }

        return 0;
    }
}
