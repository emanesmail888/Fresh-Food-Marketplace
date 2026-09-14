<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Contact extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'phone',
        'subject',
        'message',
        'status',
        'user_id',
        'ip_address',
        'user_agent',
        'admin_notes',
        'reply',
        'read_at',
        'replied_at',
        'updated_by',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'read_at' => 'datetime',
        'replied_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Status constants
     */
    const STATUS_PENDING = 'pending';
    const STATUS_READ = 'read';
    const STATUS_REPLIED = 'replied';
    const STATUS_ARCHIVED = 'archived';

    /**
     * Get the user that sent the message
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the user who updated the message
     */
    public function updatedBy()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }

    /**
     * Scope a query to only include pending messages
     */
    public function scopePending($query)
    {
        return $query->where('status', self::STATUS_PENDING);
    }

    /**
     * Scope a query to only include unread messages
     */
    public function scopeUnread($query)
    {
        return $query->where('status', '!=', self::STATUS_READ)
                     ->where('status', '!=', self::STATUS_REPLIED);
    }

    /**
     * Mark message as read
     */
    public function markAsRead()
    {
        if ($this->status === self::STATUS_PENDING) {
            $this->update([
                'status' => self::STATUS_READ,
                'read_at' => now()
            ]);
        }
    }

    /**
     * Mark message as replied
     */
    public function markAsReplied($reply = null)
    {
        $this->update([
            'status' => self::STATUS_REPLIED,
            'reply' => $reply ?? $this->reply,
            'replied_at' => now()
        ]);
    }

    /**
     * Archive message
     */
    public function archive()
    {
        $this->update([
            'status' => self::STATUS_ARCHIVED
        ]);
    }
}
