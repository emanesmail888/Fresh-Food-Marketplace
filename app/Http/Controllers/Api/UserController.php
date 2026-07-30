<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Order;
use App\Models\Review;
use App\Models\Wishlist;
use App\Models\Address;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * Get authenticated user profile
     */
    public function profile(Request $request)
    {
        $user = Auth::user();

        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone,
            'email_verified_at' => $user->email_verified_at,
            'avatar' => $user->avatar,
            'created_at' => $user->created_at
        ]);
    }

    /**
     * Update user profile
     */
    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $user->update([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone
        ]);

        return response()->json([
            'message' => 'Profile updated successfully',
            'user' => $user->fresh()
        ]);
    }

    /**
     * Change user password
     */
    public function changePassword(Request $request)
    {
        $user = Auth::user();

        $validator = Validator::make($request->all(), [
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        // Check current password
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect'
            ], 422);
        }

        // Update password
        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'message' => 'Password changed successfully'
        ]);
    }

    /**
     * Get user orders
     */
  public function orders(Request $request)
{
    $user = Auth::user();

    $orders = Order::where('user_id', $user->id)
        ->with(['items.product']) // ✅ تأكد من تحميل product مع items
        ->orderBy('created_at', 'desc')
        ->paginate($request->get('per_page', 10));

    return response()->json($orders);
}

    /**
     * Get single order details
     */
    public function orderDetails($orderId)
    {
        $user = Auth::user();

        $order = Order::where('user_id', $user->id)
            ->with(['items.product', 'items.product.category'])
            ->findOrFail($orderId);

        return response()->json($order);
    }

    /**
     * Get user reviews
     */
    public function reviews(Request $request)
    {
        $user = Auth::user();

        $reviews = Review::where('user_id', $user->id)
            ->with(['product'])
            ->orderBy('created_at', 'desc')
            ->paginate($request->get('per_page', 10));

        return response()->json($reviews);
    }



    /**
     * Get user address
     */
    public function address()
    {
        $user = Auth::user();

        $address = Address::where('user_id', $user->id)->first();

        return response()->json($address);
    }

    /**
     * Update or create user address
     */
    public function updateAddress(Request $request)
    {
        $user = Auth::user();

        $validator = Validator::make($request->all(), [
            'address_line1' => 'required|string|max:255',
            'address_line2' => 'nullable|string|max:255',
            'city' => 'required|string|max:100',
            'state' => 'nullable|string|max:100',
            'postal_code' => 'nullable|string|max:20',
            'country' => 'required|string|max:100',
            'phone' => 'nullable|string|max:20'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $address = Address::updateOrCreate(
            ['user_id' => $user->id],
            $request->all()
        );

        return response()->json([
            'message' => 'Address updated successfully',
            'address' => $address
        ]);
    }

    /**
     * Upload user avatar
     */
    public function uploadAvatar(Request $request)
    {
        $user = Auth::user();

        $validator = Validator::make($request->all(), [
            'avatar' => 'required|image|max:2048' // 2MB max
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        // Delete old avatar if exists
        if ($user->avatar) {
            \Storage::disk('public')->delete($user->avatar);
        }

        $path = $request->file('avatar')->store('avatars', 'public');

        $user->update([
            'avatar' => $path
        ]);

        return response()->json([
            'message' => 'Avatar uploaded successfully',
            'avatar' => $path
        ]);
    }

    /**
     * Get user statistics
     */
    public function stats()
    {
        $user = Auth::user();

        $stats = [
            'total_orders' => Order::where('user_id', $user->id)->count(),
            'total_reviews' => Review::where('user_id', $user->id)->count(),
            'wishlist_count' => Wishlist::where('user_id', $user->id)->count(),
            'total_spent' => Order::where('user_id', $user->id)
                ->where('status', 'completed')
                ->sum('total'),
            'pending_orders' => Order::where('user_id', $user->id)
                ->whereIn('status', ['pending', 'processing'])
                ->count()
        ];

        return response()->json($stats);
    }

    /**
     * Deactivate account
     */
    public function deactivate(Request $request)
    {
        $user = Auth::user();

        $validator = Validator::make($request->all(), [
            'password' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        // Verify password
        if (!Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Password is incorrect'
            ], 422);
        }

        // Soft delete user
        $user->delete();

        // Revoke tokens
        $user->tokens()->delete();

        return response()->json([
            'message' => 'Account deactivated successfully'
        ]);
    }

    /**
     * Reactivate account
     */
    public function reactivate(Request $request)
    {
        $user = User::onlyTrashed()
            ->where('email', $request->email)
            ->first();

        if (!$user) {
            return response()->json([
                'message' => 'Account not found'
            ], 404);
        }

        $user->restore();

        return response()->json([
            'message' => 'Account reactivated successfully'
        ]);
    }

    // /**
    //  * Get order tracking information
    //  */
    // public function trackOrder($orderId)
    // {
    //     $user = Auth::user();

    //     $order = Order::where('user_id', $user->id)
    //         ->with(['items.product', 'tracking'])
    //         ->findOrFail($orderId);

    //     return response()->json([
    //         'order' => $order,
    //         'status' => $order->status,
    //         'tracking' => $order->tracking ?? null,
    //         'estimated_delivery' => $order->estimated_delivery ?? null
    //     ]);
    // }

    // /**
    //  * Cancel order
    //  */
    // public function cancelOrder($orderId)
    // {
    //     $user = Auth::user();

    //     $order = Order::where('user_id', $user->id)
    //         ->whereIn('status', ['pending', 'processing'])
    //         ->findOrFail($orderId);

    //     $order->update([
    //         'status' => 'cancelled',
    //         'cancelled_at' => now()
    //     ]);

    //     // Return stock to inventory
    //     foreach ($order->items as $item) {
    //         $product = $item->product;
    //         $product->increment('stock', $item->quantity);
    //     }

    //     return response()->json([
    //         'message' => 'Order cancelled successfully',
    //         'order' => $order
    //     ]);
    // }

    /**
     * Get user notifications
     */
    public function notifications()
    {
        $user = Auth::user();

        $notifications = $user->notifications()
            ->latest()
            ->paginate(20);

        return response()->json($notifications);
    }

    /**
     * Mark notification as read
     */
    public function markNotificationRead($id)
    {
        $user = Auth::user();

        $notification = $user->notifications()->findOrFail($id);
        $notification->markAsRead();

        return response()->json([
            'message' => 'Notification marked as read'
        ]);
    }

    /**
     * Mark all notifications as read
     */
    public function markAllNotificationsRead()
    {
        $user = Auth::user();

        $user->unreadNotifications->markAsRead();

        return response()->json([
            'message' => 'All notifications marked as read'
        ]);
    }

    /**
     * Get user activity log
     */
    public function activityLog(Request $request)
    {
        $user = Auth::user();

        // Assuming you have an ActivityLog model
        $activities = ActivityLog::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($activities);
    }
}
