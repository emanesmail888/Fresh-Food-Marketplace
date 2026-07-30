<?php

namespace App\Models\Traits;

use App\Models\Order;

trait HasOrders
{
    /**
     * Get all orders for the user.
     */
    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    /**
     * Get pending orders.
     */
    public function pendingOrders()
    {
        return $this->orders()->where('status', 'pending');
    }

    /**
     * Get completed orders.
     */
    public function completedOrders()
    {
        return $this->orders()->where('status', 'completed');
    }

    /**
     * Get orders by status.
     */
    public function ordersByStatus($status)
    {
        return $this->orders()->where('status', $status);
    }

    /**
     * Get orders created between dates.
     */
    public function ordersBetween($startDate, $endDate)
    {
        return $this->orders()->whereBetween('created_at', [$startDate, $endDate]);
    }

    /**
     * Get total spent by user.
     */
    public function totalSpent()
    {
        return $this->orders()
            ->where('payment_status', 'paid')
            ->sum('total');
    }

    /**
     * Get order count.
     */
    public function orderCount()
    {
        return $this->orders()->count();
    }

    /**
     * Get average order value.
     */
    public function averageOrderValue()
    {
        $count = $this->orderCount();
        if ($count === 0) {
            return 0;
        }

        return $this->totalSpent() / $count;
    }
}
