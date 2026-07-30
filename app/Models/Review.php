<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Review extends Model
{
    use HasFactory;
    protected $fillable = [
        'product_id',
        'user_id',
        'rating',
        'comment',
        'is_verified',
        'images'
    ];

    protected $casts = [
        'images' => 'array',
        'is_verified' => 'boolean',
        'rating' => 'integer'
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Scope for verified reviews
    public function scopeVerified($query)
    {
        return $query->where('is_verified', true);
    }

    // Scope for high ratings
    public function scopeHighRating($query, $min = 4)
    {
        return $query->where('rating', '>=', $min);
    }
}
