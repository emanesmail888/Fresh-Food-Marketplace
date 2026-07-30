<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Cart;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Stripe\Stripe;
use Stripe\Refund;


class OrderController extends Controller
{

    /**
     * Display a listing of the admin's orders.
     */
    public function index(Request $request)
    {
        try {
            $user = $request->user();

            // Start query
           $query = Order::with([
                'user:id,name,email,phone',
                'items',
                'items.product:id,title,title_ar,slug,image,price'
            ]);

            // Apply status filter if provided
            if ($request->has('status') && $request->status !== 'all' && !empty($request->status)) {
                $status = $request->status;

                // Handle special status cases
                if ($status === 'refunded') {
                    $query->where(function($q) {
                        $q->where('payment_status', 'refunded')
                          ->orWhere('status', 'refunded');
                    });
                } elseif ($status === 'partially_refunded') {
                    $query->where('payment_status', 'partially_refunded');
                } else {
                    $query->where('status', $status);
                }
            }

            // Apply search if provided
            if ($request->has('search') && !empty($request->search)) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('order_number', 'LIKE', "%{$search}%")
                      ->orWhere('id', 'LIKE', "%{$search}%");
                });
            }

            // Apply sorting
            $sortField = $request->input('sort_field', 'created_at');
            $sortDirection = $request->input('sort_direction', 'desc');

            // Only allow sorting on specific fields
            $allowedSortFields = ['id', 'order_number', 'total', 'status', 'payment_status', 'shipping_status', 'created_at'];
            if (in_array($sortField, $allowedSortFields)) {
                $query->orderBy($sortField, $sortDirection);
            } else {
                $query->orderBy('created_at', 'desc');
            }

            // Paginate
            $perPage = $request->input('per_page', 10);
            $orders = $query->paginate($perPage);

            // Log for debugging
            // Log::info('Orders fetched', [
            //     'user_id' => $user->id,
            //     'status_filter' => $request->status,
            //     'search' => $request->search,
            //     'total' => $orders->total()
            // ]);

            return response()->json([
                'success' => true,
                'data' => $orders
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to fetch orders: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch orders',
                'error' => $e->getMessage()
            ], 500);
        }
    }


    /**
     * Display the specified order.
     */
    public function show(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            $order = Order::with(['items'])
                ->where('order_number', $orderNumber)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            // Decode shipping_address if it's stored as JSON
            if (is_string($order->shipping_address)) {
                $order->shipping_address = json_decode($order->shipping_address, true);
            }

            if (is_string($order->billing_address)) {
                $order->billing_address = json_decode($order->billing_address, true);
            }

            return response()->json($order);

        } catch (\Exception $e) {
            Log::error('Failed to fetch order: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch order',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cancel an order.
     */

    public function cancel(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            $order = Order::with(['items', 'payments'])
                ->where('order_number', $orderNumber)
                ->where('user_id', $user->id)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            // Check if order can be cancelled
            $cancellableStatuses = ['pending', 'processing'];
            if (!in_array($order->status, $cancellableStatuses)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order cannot be cancelled at this stage'
                ], 400);
            }

            DB::beginTransaction();

            // Process refund if order was paid
            $refundResult = null;
            if ($order->payment_status === 'paid') {
                $refundResult = $this->processRefund($order, $request->reason ?? 'Cancelled by customer');

                if (!$refundResult['success']) {
                    DB::rollBack();
                    return response()->json([
                        'success' => false,
                        'message' => 'Refund failed: ' . $refundResult['message']
                    ], 400);
                }
            }

            // Update order status
            $order->update([
                'status' => 'cancelled',
                'cancelled_at' => now(),
                'cancellation_reason' => $request->reason ?? 'Cancelled by customer',
                'payment_status' => $refundResult ? 'refunded' : $order->payment_status,
                'updated_by' => $user->id
            ]);

            // Restore product stock
            foreach ($order->items as $item) {
                $product = $item->product;
                if ($product) {
                    $product->increment('stock', $item->quantity_grams / 1000);
                    Log::info('Stock restored for product: ' . $product->id, [
                        'quantity' => $item->quantity_grams / 1000
                    ]);
                }
            }

            // Update payment record if exists// Get the payment record
        $payment = $order->payments()->latest()->first();

        // Update payment record if exists
        if ($payment && $refundResult) {
            $payment->update([
                'status' => 'refunded',
                'refunded_at' => now(),
                'refund_amount' => $order->total,
                'refund_reason' => $request->reason ?? 'Cancelled by customer',
                'refund_transaction_id' => $refundResult['transaction_id'] ?? null,
                'stripe_refund_id' => $refundResult['stripe_refund_id'] ?? null
            ]);
        }



            DB::commit();

            // Send cancellation notification
            $this->sendCancellationNotification($order, $refundResult);

            return response()->json([
                'success' => true,
                'message' => $refundResult ? 'Order cancelled and refunded successfully' : 'Order cancelled successfully',
                'order' => $order->fresh(['items', 'payments']),
                'refund' => $refundResult
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Failed to cancel order: ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to cancel order',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process refund based on payment method
     */
    private function processRefund($order, $reason)
    {
        try {
            // Only process refund for paid orders
            if ($order->payment_method !== 'stripe') {
                return [
                    'success' => true,
                    'message' => 'No payment to refund for this payment method',
                    'transaction_id' => null,
                    'stripe_refund_id' => null
                ];
            }

            // Initialize Stripe
            Stripe::setApiKey(config('services.stripe.secret'));

            // Get payment record
            $payment = $order->payments()->latest()->first();

            if (!$payment) {
                Log::error('No payment record found for order: ' . $order->order_number);
                return [
                    'success' => false,
                    'message' => 'No payment record found for this order'
                ];
            }

            // Log payment details for debugging
            Log::info('Processing refund for order', [
                'order_number' => $order->order_number,
                'payment_id' => $payment->id,
                'payment_intent_id' => $payment->payment_intent_id,
                'stripe_session_id' => $payment->stripe_session_id,
                'transaction_id' => $payment->transaction_id
            ]);

            // Get payment intent ID
            $paymentIntentId = null;

            if ($payment->payment_intent_id) {
                $paymentIntentId = $payment->payment_intent_id;
            } elseif ($payment->transaction_id) {
                // Check if transaction_id is actually a payment intent ID
                if (strpos($payment->transaction_id, 'pi_') === 0) {
                    $paymentIntentId = $payment->transaction_id;
                }
            } elseif ($payment->stripe_session_id) {
                // Try to retrieve from session
                try {
                    $session = \Stripe\Checkout\Session::retrieve($payment->stripe_session_id);
                    $paymentIntentId = $session->payment_intent;

                    // Update payment record with the payment intent ID
                    $payment->payment_intent_id = $paymentIntentId;
                    $payment->transaction_id = $paymentIntentId;
                    $payment->save();

                    Log::info('Retrieved payment intent from session', [
                        'order_number' => $order->order_number,
                        'payment_intent_id' => $paymentIntentId
                    ]);
                } catch (\Exception $e) {
                    Log::error('Failed to retrieve session', [
                        'order_number' => $order->order_number,
                        'session_id' => $payment->stripe_session_id,
                        'error' => $e->getMessage()
                    ]);
                }
            }

            if (!$paymentIntentId) {
                Log::error('No payment intent found for order', [
                    'order_number' => $order->order_number,
                    'payment_id' => $payment->id,
                    'payment_method' => $order->payment_method
                ]);

                // For development/testing, you might want to allow mock refunds
                if (app()->environment('local')) {
                    Log::warning('Using mock refund for local environment', [
                        'order_number' => $order->order_number
                    ]);

                    return [
                        'success' => true,
                        'message' => 'Mock refund processed in local environment',
                        'transaction_id' => 'mock_refund_' . uniqid(),
                        'stripe_refund_id' => 'mock_refund_' . uniqid()
                    ];
                }

                return [
                    'success' => false,
                    'message' => 'No payment information found for refund. Please contact support.'
                ];
            }

            // Process the refund with Stripe
            try {
                $refund = Refund::create([
                    'payment_intent' => $paymentIntentId,
                    'amount' => (int) round($order->total * 100), // Convert to cents/piasters
                    'reason' => 'requested_by_customer',
                    'metadata' => [
                        'order_number' => $order->order_number,
                        'cancellation_reason' => $reason,
                        'customer_id' => (string) $order->user_id
                    ]
                ]);

                if ($refund->status === 'succeeded' || $refund->status === 'pending') {
                    Log::info('Refund processed successfully', [
                        'order_number' => $order->order_number,
                        'refund_id' => $refund->id,
                        'amount' => $order->total,
                        'status' => $refund->status
                    ]);

                    return [
                        'success' => true,
                        'message' => 'Refund processed successfully',
                        'transaction_id' => $refund->id,
                        'stripe_refund_id' => $refund->id,
                        'status' => $refund->status,
                        'amount' => $order->total
                    ];
                } else {
                    Log::error('Refund failed', [
                        'order_number' => $order->order_number,
                        'refund_status' => $refund->status,
                        'failure_reason' => $refund->failure_reason ?? 'Unknown'
                    ]);

                    return [
                        'success' => false,
                        'message' => 'Refund failed: ' . ($refund->failure_reason ?? 'Unknown error')
                    ];
                }
            } catch (\Stripe\Exception\InvalidRequestException $e) {
                // Handle specific Stripe errors
                Log::error('Stripe invalid request error: ' . $e->getMessage(), [
                    'order_number' => $order->order_number,
                    'payment_intent_id' => $paymentIntentId
                ]);

                return [
                    'success' => false,
                    'message' => 'Stripe error: ' . $e->getMessage()
                ];
            } catch (\Stripe\Exception\ApiErrorException $e) {
                Log::error('Stripe API error: ' . $e->getMessage(), [
                    'order_number' => $order->order_number,
                    'trace' => $e->getTraceAsString()
                ]);

                return [
                    'success' => false,
                    'message' => 'Stripe error: ' . $e->getMessage()
                ];
            }

        } catch (\Exception $e) {
            Log::error('Refund processing error: ' . $e->getMessage(), [
                'order_number' => $order->order_number,
                'trace' => $e->getTraceAsString()
            ]);

            return [
                'success' => false,
                'message' => 'Refund processing failed: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Send cancellation notification
     */
    private function sendCancellationNotification($order, $refundResult = null)
    {
        try {
            // Get customer email from shipping address
            $shippingAddress = is_string($order->shipping_address)
                ? json_decode($order->shipping_address, true)
                : $order->shipping_address;

            $email = $shippingAddress['email'] ?? null;

            if (!$email) {
                Log::warning('No email found for cancellation notification', [
                    'order_number' => $order->order_number
                ]);
                return;
            }

            // Log the notification (implement actual email sending here)
            Log::info('Cancellation notification prepared', [
                'order_number' => $order->order_number,
                'email' => $email,
                'refund_processed' => !is_null($refundResult)
            ]);

            // You can implement email notification here
            // Mail::to($email)->send(new OrderCancelledNotification($order, $refundResult));

        } catch (\Exception $e) {
            Log::error('Failed to send cancellation notification: ' . $e->getMessage());
        }
    }

    /**
     * Get refund status for an order
     */
    public function refundStatus(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            $order = Order::with(['payment'])
                ->where('order_number', $orderNumber)
                ->where('user_id', $user->id)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            $refundInfo = [
                'order_number' => $order->order_number,
                'status' => $order->payment_status,
                'amount' => $order->total,
                'payment_method' => $order->payment_method,
                'cancelled_at' => $order->cancelled_at,
                'cancellation_reason' => $order->cancellation_reason
            ];

            // Add Stripe refund details if available
            if ($orders->payment) {
                $refundInfo['refunded_at'] = $order->payments->refunded_at;
                $refundInfo['refund_amount'] = $order->payments->refund_amount;
                $refundInfo['refund_transaction_id'] = $order->payments->refund_transaction_id;

                // If we have Stripe refund ID, get more details from Stripe
                if ($order->payments->stripe_refund_id && $order->payment_method === 'stripe') {
                    try {
                        Stripe::setApiKey(config('services.stripe.secret'));
                        $stripeRefund = Refund::retrieve($order->payments->stripe_refund_id);
                        $refundInfo['stripe_status'] = $stripeRefund->status;
                    } catch (\Exception $e) {
                        Log::error('Failed to retrieve Stripe refund: ' . $e->getMessage());
                    }
                }
            }

            return response()->json([
                'success' => true,
                'data' => $refundInfo
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to get refund status: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to get refund status'
            ], 500);
        }
    }


    /**
     * Reorder (add previous order items to cart).
     */
    public function reorder(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            $order = Order::with(['items'])
                ->where('order_number', $orderNumber)
                ->where('user_id', $user->id)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            // Get or create user's cart
            $cart = Cart::firstOrCreate([
                'user_id' => $user->id
            ]);

            DB::beginTransaction();

            $addedItems = [];

            foreach ($order->items as $orderItem) {
                $product = $orderItem->product;

                // Check if product exists and has stock
                if (!$product) {
                    continue;
                }

                // Check if product already in cart
                $existingCartItem = $cart->items()
                    ->where('product_id', $product->id)
                    ->first();

                if ($existingCartItem) {
                    // Update quantity
                    $newQuantity = $existingCartItem->quantity_grams + $orderItem->quantity_grams;

                    // Check stock
                    if ($product->stock < ($newQuantity / 1000)) {
                        continue; // Skip if not enough stock
                    }

                    $existingCartItem->update([
                        'quantity_grams' => $newQuantity,
                        'price_at_add' => $product->price // Update to current price
                    ]);

                    $addedItems[] = [
                        'product_id' => $product->id,
                        'quantity' => $orderItem->quantity_grams / 1000,
                        'updated' => true
                    ];
                } else {
                    // Check stock
                    if ($product->stock < ($orderItem->quantity_grams / 1000)) {
                        continue; // Skip if not enough stock
                    }

                    // Add new item
                    $cart->items()->create([
                        'product_id' => $product->id,
                        'quantity_grams' => $orderItem->quantity_grams,
                        'price_at_add' => $product->price // Use current price
                    ]);

                    $addedItems[] = [
                        'product_id' => $product->id,
                        'quantity' => $orderItem->quantity_grams / 1000,
                        'added' => true
                    ];
                }
            }

            DB::commit();

            // Refresh cart with items
            $cart->load('items.product');

            return response()->json([
                'success' => true,
                'message' => 'Items added to cart successfully',
                'cart' => [
                    'items' => $cart->items,
                    'items_count' => $cart->items->count()
                ],
                'added_items' => $addedItems
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Failed to reorder: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to add items to cart',
                'error' => $e->getMessage()
            ], 500);
        }
    }



    /**
     * Track order status.
     */
    public function track(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            $order = Order::with(['items'])
                ->where('order_number', $orderNumber)
                ->where('user_id', $user->id)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            // Decode shipping address if it's stored as JSON
            $shippingAddress = is_string($order->shipping_address)
                ? json_decode($order->shipping_address, true)
                : $order->shipping_address;

            // Define tracking timeline based on order status
            $trackingInfo = [
                'order_number' => $order->order_number,
                'current_status' => $order->status,
                'payment_status' => $order->payment_status,
                'shipping_status' => $order->shipping_status,
                'order_total' => (float) $order->total,
                'items_count' => $order->items->count(),
                'created_at' => $order->created_at,
                'updated_at' => $order->updated_at,
                'shipped_at' => $order->shipped_at,
                'delivered_at' => $order->delivered_at,
                'timeline' => $this->getOrderTimeline($order),
                'estimated_delivery' => $this->calculateEstimatedDelivery($order),
                'tracking_number' => $order->tracking_number ?? null,
                'carrier' => $order->shipping_method ?? null,
                'shipping_address' => $shippingAddress
            ];

            return response()->json([
                'success' => true,
                'data' => $trackingInfo
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to track order: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to track order',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get user's recent orders (for quick access).
     */
    public function recent(Request $request)
    {
        try {
            $user = $request->user();

            $orders = Order::with(['items'])
                ->where('user_id', $user->id)
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get();

            return response()->json([
                'success' => true,
                'data' => $orders
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to fetch recent orders: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch recent orders',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get order timeline based on status.
     */
    private function getOrderTimeline($order)
    {
        $timeline = [
            [
                'status' => 'order_placed',
                'label' => 'Order Placed',
                'date' => $order->created_at,
                'completed' => true
            ],
            [
                'status' => 'payment_confirmed',
                'label' => 'Payment Confirmed',
                'date' => $order->payment_status === 'paid' ? $order->updated_at : null,
                'completed' => $order->payment_status === 'paid'
            ]
        ];

        // Add processing status
        if (in_array($order->status, ['processing', 'shipped', 'delivered'])) {
            $timeline[] = [
                'status' => 'processing',
                'label' => 'Processing',
                'date' => $order->updated_at,
                'completed' => true
            ];
        }

        // Add shipped status
        if (in_array($order->status, ['shipped', 'delivered'])) {
            $timeline[] = [
                'status' => 'shipped',
                'label' => 'Shipped',
                'date' => $order->shipped_at ?? $order->updated_at,
                'completed' => true
            ];
        }

        // Add delivered status
        if ($order->status === 'delivered') {
            $timeline[] = [
                'status' => 'delivered',
                'label' => 'Delivered',
                'date' => $order->delivered_at ?? $order->updated_at,
                'completed' => true
            ];
        }

        return $timeline;
    }

    /**
     * Calculate estimated delivery date.
     */
    private function calculateEstimatedDelivery($order)
    {
        if ($order->status === 'delivered') {
            return $order->delivered_at ?? $order->updated_at;
        }

        // Calculate based on shipping method
        $shippingDays = [
            'standard' => 5,
            'express' => 2,
            'next_day' => 1
        ];

        $days = $shippingDays[$order->shipping_method] ?? 5;

        return now()->addDays($days);
    }



/**
     * Update order status (Admin only)
     */
    public function updateStatus(Request $request, $orderNumber)
    {
        try {
            $user = $request->user();

            // Check if user is admin
            if (!$user->isAdmin())  {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized. Admin access required.'
                ], 403);
            }

            $order = Order::with(['items'])
                ->where('order_number', $orderNumber)
                ->first();

            if (!$order) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }

            // Validate the request
            $validated = $request->validate([
                'status' => 'required|in:pending,processing,completed,cancelled,refunded'
            ]);

            // Define valid status transitions
            $validTransitions = [
                'pending' => ['processing', 'completed'],
                'processing' => ['completed'],
                'completed' => [],
                'cancelled' => ['cancelled'],
                'refunded' => [],
            ];

            $currentStatus = $order->status;
            $newStatus = $validated['status'];

            // Check if transition is allowed
            if (!in_array($newStatus, $validTransitions[$currentStatus] ?? [])) {
                return response()->json([
                    'success' => false,
                    'message' => "Cannot change status from {$currentStatus} to {$newStatus}"
                ], 400);
            }

            DB::beginTransaction();

            // Update the status
            $order->status = $newStatus;
            $order->updated_by = $user->id;

            // Update shipping status based on order status
            if ($newStatus === 'completed') {
                // Check if payment is unpaid and mark it as paid
            if ($order->payment_status === 'unpaid' || $order->payment_status === 'UnPaid') {
                $order->payment_status = 'paid';
                $order->paid_at = now();
            }

                $order->delivered_at = now();
                $order->shipping_status = 'delivered';

            } elseif ($newStatus === 'processing') {
                $order->shipping_status = 'processing';
            } elseif ($newStatus === 'pending') {
                $order->shipping_status = 'pending';
            }
             elseif ($newStatus === 'cancelled') {
                $order->shipping_status = 'cancelled';
            }

            $order->save();

            // Log the status change
            Log::info('Order status updated', [
                'order_number' => $order->order_number,
                'old_status' => $currentStatus,
                'new_status' => $newStatus,
                'updated_by' => $user->id,
                'updated_by_email' => $user->email
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Order status updated successfully',
                'data' => $order->fresh(['items', 'payments'])
            ]);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Failed to update order status: ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to update order status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

}

