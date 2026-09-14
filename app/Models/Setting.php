<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;


class Setting extends Model
{
    use HasFactory;
    protected $fillable = ['group', 'name', 'value', 'type', 'metadata'];
    
    protected $casts = [
        'metadata' => 'array',
    ];
    
    // Helper method to get file URL
    public function getFileUrlAttribute()
    {
        if (in_array($this->type, ['image', 'video']) && $this->value) {
            return Storage::url($this->value);
        }
        return null;
    }
    
    // Scope for specific group
    public function scopeGroup($query, $group)
    {
        return $query->where('group', $group);
    }
}
