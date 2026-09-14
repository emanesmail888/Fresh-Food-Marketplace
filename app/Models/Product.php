<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;


class Product extends Model
{
    use HasFactory, SoftDeletes;
    protected $fillable = [
        'title','title_ar',
        'slug',
        'image',
        'images',
        'description','description_ar',
        'price',
        'sale_price',
        'stock',
        'unit',
        'category_id',
        'new_arrival',
    ];

    protected $casts = [
        'new_arrival' => 'boolean',
        'price'       => 'decimal:2',
        'sale_price'  => 'decimal:2',
        'stock'       => 'integer',
        'unit'          => 'string',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function cartItems()
    {
        return $this->hasMany(CartItem::class);
    }


    protected static function booted()
    {
        static::saved(function ($product) {
            // Check if product belongs to seeds category
            if ($product->category && in_array($product->category->name, ['seeds', 'بذور'])) {
                Cache::forget('home_seed_products');
                \Log::info('Seed products cache cleared due to product update');
            }
        });

         // Auto-generate slug when creating
        static::creating(function ($product) {
            if (empty($product->slug)) {
                $product->slug = Str::slug($product->title);
            } else {
                $product->slug = Str::slug($product->slug);
            }
        });

        // Auto-generate slug when updating
        static::updating(function ($product) {

            if (empty($product->slug)) {
                $product->slug = Str::slug($product->title);
            } else {
                $product->slug = Str::slug($product->slug);
            }



        });

        static::deleted(function ($product) {
            if ($product->category && in_array($product->category->name, ['seeds', 'بذور'])) {
                Cache::forget('home_seed_products');
                \Log::info('Seed products cache cleared due to product deletion');
            }
        });
    }


   

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function getAverageRatingAttribute()
    {
        return $this->reviews()->avg('rating') ?? 0;
    }

    public function getReviewsCountAttribute()
    {
        return $this->reviews()->count();
    }

    public function getVerifiedReviewsCountAttribute()
    {
        return $this->reviews()->where('is_verified', true)->count();
    }



     /**
     * Get the users who have this product in their wishlist.
     */
    public function wishlistUsers()
    {
        return $this->belongsToMany(User::class, 'wishlists');
    }

    /**
     * Check if this product is in any user's wishlist.
     */
    public function isInWishlist($userId): bool
    {
        return $this->wishlistUsers()->where('user_id', $userId)->exists();
    }

}
