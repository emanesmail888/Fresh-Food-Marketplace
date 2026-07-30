<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Discount;

class DiscountSeeder extends Seeder
{
    public function run()
    {
        Discount::create([
            'code' => 'WELCOME10',
            'type' => 'percentage',
            'value' => 10,
            'min_order_amount' => 100,
            'max_discount_amount' => 50,
            'expires_at' => now()->addMonths(3),
            'usage_limit' => 100,
            'is_active' => true
        ]);

        Discount::create([
            'code' => 'SAVE50',
            'type' => 'fixed',
            'value' => 50,
            'min_order_amount' => 200,
            'expires_at' => now()->addMonths(1),
            'usage_limit' => 50,
            'is_active' => true
        ]);
    }
}
