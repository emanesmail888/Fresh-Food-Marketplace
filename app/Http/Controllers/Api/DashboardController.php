<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\Product;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;


class DashboardController extends Controller
{
    public function stats(Request $request)
    {
        try {
            // Get current month and previous month for growth calculations
            $currentMonthStart = Carbon::now()->startOfMonth();
            $previousMonthStart = Carbon::now()->subMonth()->startOfMonth();
            $previousMonthEnd = Carbon::now()->subMonth()->endOfMonth();

            // Total Orders
            $totalOrders = Order::count();
            $lastMonthOrders = Order::whereBetween('created_at', [$previousMonthStart, $previousMonthEnd])->count();
            $ordersGrowth = $lastMonthOrders > 0
                ? round((($totalOrders - $lastMonthOrders) / $lastMonthOrders) * 100, 1)
                : 0;

            // Total Products
            $totalProducts = Product::count();
            $lastMonthProducts = Product::whereBetween('created_at', [$previousMonthStart, $previousMonthEnd])->count();
            $productsGrowth = $lastMonthProducts > 0
                ? round((($totalProducts - $lastMonthProducts) / $lastMonthProducts) * 100, 1)
                : 0;

            // Total Users
            $totalUsers = User::count();
            $lastMonthUsers = User::whereBetween('created_at', [$previousMonthStart, $previousMonthEnd])->count();
            $usersGrowth = $lastMonthUsers > 0
                ? round((($totalUsers - $lastMonthUsers) / $lastMonthUsers) * 100, 1)
                : 0;

            // Total Revenue (completed orders only)
            $totalRevenue = Order::where('status', 'completed')->sum('total');
            $lastMonthRevenue = Order::where('status', 'completed')
                ->whereBetween('created_at', [$previousMonthStart, $previousMonthEnd])
                ->sum('total');
            $revenueGrowth = $lastMonthRevenue > 0
                ? round((($totalRevenue - $lastMonthRevenue) / $lastMonthRevenue) * 100, 1)
                : 0;

            // Orders by status
            $pendingOrders = Order::where('status', 'pending')->count();
            $processingOrders = Order::where('status', 'processing')->count();
            $completedOrders = Order::where('status', 'completed')->count();
            $cancelledOrders = Order::where('status', 'cancelled')->count();

            // Revenue by period (for chart)
            $revenueData = $this->getRevenueData($request->input('days', 30));
            $ordersData = $this->getOrdersData($request->input('days', 30));

            return response()->json([
                'success' => true,
                'data' => [
                    'total_orders' => $totalOrders,
                    'total_products' => $totalProducts,
                    'total_users' => $totalUsers,
                    'total_revenue' => $totalRevenue,
                    'pending_orders' => $pendingOrders,
                    'processing_orders' => $processingOrders,
                    'completed_orders' => $completedOrders,
                    'cancelled_orders' => $cancelledOrders,
                    'orders_growth' => $ordersGrowth,
                    'products_growth' => $productsGrowth,
                    'users_growth' => $usersGrowth,
                    'revenue_growth' => $revenueGrowth,
                    'revenue_data' => $revenueData,
                    'orders_data' => $ordersData,
                ]
            ]);

        } catch (\Exception $e) {
            \Log::error('Failed to get dashboard stats: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to get dashboard statistics'
            ], 500);
        }
    }

    private function getRevenueData($days = 30)
    {
        $data = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = Carbon::now()->subDays($i);
            $dailyRevenue = Order::where('status', 'completed')
                ->whereDate('created_at', $date->toDateString())
                ->sum('total');

            $data[] = [
                'date' => $date->format('Y-m-d'),
                'revenue' => $dailyRevenue
            ];
        }
        return $data;
    }

    private function getOrdersData($days = 30)
    {
        $data = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = Carbon::now()->subDays($i);
            $dailyOrders = Order::whereDate('created_at', $date->toDateString())->count();

            $data[] = [
                'date' => $date->format('Y-m-d'),
                'orders' => $dailyOrders
            ];
        }
        return $data;
    }
}

