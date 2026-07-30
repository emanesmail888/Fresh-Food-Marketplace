<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class Service extends Model
{
    use HasFactory;
    protected $fillable = [
        'title',
        'title_ar',
        'description',
        'description_ar',
        'image',

    ];

    protected static function booted()
    {
        static::saved(function () {
            Cache::flush(); // Clear all cache when service is saved
        });

        static::deleted(function () {
            Cache::flush(); // Clear all cache when service is deleted
        });
    }
}
