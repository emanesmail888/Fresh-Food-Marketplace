<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Casts\Attribute;


class OrderItem extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'order_id',
        'product_id',
        'product_name',
        'product_image',
        'unit_price',
        'unit_cost',
        'quantity_grams',
        'total',
        'discount',
        'unit',
        'weight',
        'options',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'unit_price' => 'decimal:2',
        'unit_cost' => 'decimal:2',
        'quantity_grams' => 'decimal:3',
        'total' => 'decimal:2',
        'discount' => 'decimal:2',
        'weight' => 'decimal:2',
        'options' => 'array',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    //        'unit_price' => 'float',
    //   'total' => 'float',
    ];

    /**
     * The model's default values for attributes.
     *
     * @var array
     */
    protected $attributes = [
        'unit' => 'kg',
        'discount' => 0,
    ];

    /**
     * Get the order that owns the item.
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the product that this item represents.
     */
    public function product()
    {
        return $this->belongsTo(Product::class)->withTrashed();
    }

    /**
     * Get the formatted unit price.
     */
    protected function formattedUnitPrice(): Attribute
    {
        return Attribute::get(function () {
            return $this->order->currency_symbol . ' ' . number_format($this->unit_price, 2);
        });
    }

    /**
     * Get the formatted total.
     */
    protected function formattedTotal(): Attribute
    {
        return Attribute::get(function () {
            return $this->order->currency_symbol . ' ' . number_format($this->total, 2);
        });
    }

    /**
     * Get the quantity in kilograms.
     */
    protected function quantityKg(): Attribute
    {
        return Attribute::get(fn () => $this->quantity_grams / 1000);
    }

    /**
     * Get the formatted quantity.
     */
    protected function formattedQuantity(): Attribute
    {
        return Attribute::get(function () {
            $kg = $this->quantity_grams / 1000;
            return number_format($kg, 3) . ' ' . $this->unit;
        });
    }

    /**
     * Get the profit for this item (if unit_cost is available).
     */
    protected function profit(): Attribute
    {
        return Attribute::get(function () {
            if ($this->unit_cost === null) {
                return null;
            }
            return ($this->unit_price - $this->unit_cost) * ($this->quantity_grams / 1000);
        });
    }

    /**
     * Get the margin percentage (if unit_cost is available).
     */
    protected function marginPercentage(): Attribute
    {
        return Attribute::get(function () {
            if ($this->unit_cost === null || $this->unit_cost == 0) {
                return null;
            }
            return (($this->unit_price - $this->unit_cost) / $this->unit_price) * 100;
        });
    }

    /**
     * Get the product image URL.
     */
    protected function productImageUrl(): Attribute
    {
        return Attribute::get(function () {
            if (!$this->product_image) {
                return null;
            }
            return asset('storage/' . $this->product_image);
        });
    }

    /**
     * Scope a query to only include items from a specific order.
     */
    public function scopeOfOrder($query, $orderId)
    {
        return $query->where('order_id', $orderId);
    }

    /**
     * Scope a query to only include items with a specific product.
     */
    public function scopeOfProduct($query, $productId)
    {
        return $query->where('product_id', $productId);
    }

    /**
     * Calculate total for this item based on quantity and unit price.
     */
    public static function calculateTotal($unitPrice, $quantityGrams)
    {
        return $unitPrice * ($quantityGrams / 1000);
    }
}

