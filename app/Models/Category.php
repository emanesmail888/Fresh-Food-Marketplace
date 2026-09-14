<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class Category extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'name_ar',
        'image',

    ];

     public function products()
    {
        return $this->hasMany(Category::class);
    }


    protected static function booted()
    {
        static::saved(function () {
            Cache::flush(); // Clear all cache when category is saved
        });

        static::deleted(function () {
            Cache::flush(); // Clear all cache when category is deleted
        });
    }
}
