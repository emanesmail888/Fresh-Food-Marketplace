<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class Cart extends Model
{
    use HasFactory;

    protected $fillable = [

        'user_id','session_id','guest_token','status','processed_at'
    ];

     protected $casts = [
        'processed_at' => 'datetime',
    ];


     public function items()
    {
        return $this->hasMany(CartItem::class);
    }


    // ============= SCOPES =============


    // Scope for guest carts
    public function scopeGuest($query)
    {
        return $query->whereNotNull('session_id')->whereNull('user_id');
    }

    // Scope for abandoned carts
    public function scopeAbandoned($query)
    {
        return $query->where('status', 'abandoned');
    }

    // Scope for carts inactive for X days
    public function scopeInactiveFor($query, $days = 7)
    {
        return $query->where('updated_at', '<', now()->subDays($days));
    }

    // ============= HELPER METHODS =============

    // Check if cart should be marked as abandoned or deleted
    public function shouldBeAbandoned($days = 7): bool
    {
        return $this->status === 'active'
            && $this->session_id !== null
            && $this->user_id === null
            && $this->updated_at < now()->subDays($days);
    }

    public function shouldBeDeleted($days = 8): bool
    {
        return $this->status === 'abandoned'
            && $this->session_id !== null
            && $this->user_id === null
            && $this->updated_at < now()->subDays($days);
    }

    // ============= MODEL EVENTS =============

    protected static function booted()
    {
    static::saving(function ($cart) {
        // Mark as abandoned if inactive for 7 days
        if ($cart->status === 'active'
            && $cart->session_id !== null
            && $cart->user_id === null
            && $cart->updated_at < now()->subDays(7)) {

            $cart->status = 'abandoned';

            Log::info("Cart marked as abandoned via model event", [
                'cart_id' => $cart->id,
                'session_id' => $cart->session_id,
                'updated_at' => $cart->updated_at
            ]);
        }
    });


        // Auto-delete abandoned carts when retrieving or updating
        static::retrieved(function ($cart) {
            if ($cart->shouldBeDeleted()) {
                $cart->delete();

                Log::info("Cart deleted via model event", [
                    'cart_id' => $cart->id,
                    'session_id' => $cart->session_id
                ]);
            }
        });
    }


}
