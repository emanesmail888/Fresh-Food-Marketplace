<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\CheckoutRequest;
use App\Models\Cart;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\Product;
use App\Http\Services\PaymentService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Stripe\Stripe;
use Stripe\Checkout\Session;
use App\Models\Discount;


class CheckoutController extends Controller
{
    protected $paymentService;

    public function __construct(PaymentService $paymentService)
    {
        $this->paymentService = $paymentService;
    }

    /**
     * Get checkout summary (cart items and calculated totals)
     */
    public function summary(Request $request)
    {
        try {
            $user = $request->user();

            // Get user's cart with items and products

            $cart = Cart::with(['items.product'])
            ->where('user_id', $user->id)
            // ->where('status', 'active')
            ->latest()
            ->first();

            if (!$cart || $cart->items->isEmpty()) {
                return response()->json([
                    'message' => 'Cart is empty',
                    'cart' => [
                        'items' => [],
                        'items_count' => 0
                    ],
                    'summary' => [
                        'subtotal' => 0,
                        'tax' => 0,
                        'shipping_cost' => 6,
                        'discount' => 0,
                        'total' => 6
                    ]
                ]);
            }

        //      if (!$cart || $cart->items->isEmpty()) {
        //     return response()->json([
        //         'message' => 'Cart is empty',
        //         'errors' => ['cart' => ['Your shopping cart is empty']]
        //     ], 400);
        // }

            // Calculate totals with unit awareness
            $subtotal = $this->calculateSubtotal($cart);
            $tax = $this->calculateTax($subtotal);
            $shippingCost = 6;
            $discount = 0;
            $total = $subtotal + $tax + $shippingCost - $discount;

            // Format cart items for response
            $cartItems = $cart->items->map(function ($item) {
                $product = $item->product;
                $unit = $product->unit ?? 'kg';

                return [
                    'id' => $item->id,
                    'product_id' => $item->product_id,
                    'product_name' => $product->title ?? 'Product',
                    'product_image' => $product->image ?? null,
                    'quantity_grams' => $item->quantity_grams,
                    'quantity_display' => $this->getQuantityDisplayForCart($item, $product, $unit),
                    'unit' => $unit,
                    'unit_label' => $this->getUnitLabel($unit),
                    'price_per_unit' => $this->getPricePerUnit($item, $product, $unit),
                    'total_price' => $this->calculateItemTotal($item, $product, $unit),
                    'stock' => $product->stock ?? 0,
                    'is_low_stock' => ($product->stock ?? 0) <= 2
                ];
            });

            return response()->json([
                'message' => 'Checkout summary retrieved successfully',
                'cart' => [
                    'items' => $cartItems,
                    'items_count' => $cart->items->count()
                ],
                'summary' => [
                    'subtotal' => round($subtotal, 2),
                    'tax' => round($tax, 2),
                    'tax_rate' => 14,
                    'shipping_cost' => $shippingCost,
                    'discount' => $discount,
                    'total' => round($total, 2),
                    'currency' => 'EGP',
                    'currency_symbol' => 'E£'
                ],
                'shipping_methods' => $this->getShippingMethods(),
                'payment_methods' => $this->getPaymentMethods()
            ]);

        } catch (\Exception $e) {
            Log::error('Checkout summary failed: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'message' => 'Failed to load checkout summary',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process checkout and create order
     */
    public function process(CheckoutRequest $request)
    {
        $user = $request->user();

        // Clean up old "processing" carts that might be stuck
        Cart::where('user_id', $user->id)
            ->where('status', 'processing')
            ->where('updated_at', '<', now()->subMinutes(10))
            ->update(['status' => 'abandoned']);

        // Get user's cart with items and products
        $cart = Cart::with(['items.product'])
            ->where('user_id', $user->id)
            // ->orWhere('session_id',request()->session()->getId())
            // ->where('status', 'active')
            ->latest()
            ->first();

        if (!$cart || $cart->items->isEmpty()) {
            return response()->json([
                'message' => 'Cart is empty',
                'errors' => ['cart' => ['Your shopping cart is empty']]
            ], 400);
        }

        // Mark cart as processing immediately
        $cart->status = 'processing';
        $cart->save();

        // Validate stock availability
        $stockErrors = $this->validateStock($cart);
        if (!empty($stockErrors)) {
            return response()->json([
                'message' => 'Some products are out of stock',
                'errors' => $stockErrors
            ], 400);
        }

        // Calculate totals
        $subtotal = $this->calculateSubtotal($cart);
        $tax = $this->calculateTax($subtotal);
        $shippingCost = $request->shipping_cost ?? 6;

        // Calculate discounts
        $discountAmount = 0;
        $appliedDiscount = null;

        if ($request->discount_code) {
            $discount = Discount::where('code', strtoupper($request->discount_code))->first();
            if ($discount && $discount->isValid()) {
                $discountAmount = $discount->calculateDiscount($subtotal);

                // Increment usage count
                if ($discountAmount > 0) {
                    $discount->increment('used_count');
                    $appliedDiscount = $discount;
                }
            }
        }
        // $total = $subtotal + $tax + $shippingCost - $discount;
        $total = $subtotal + $tax + $shippingCost - $discountAmount;

        // Check minimum amount for Stripe payments
        $stripeMinEgp = 25.00;
        if ($request->payment_method === 'stripe' && $total < $stripeMinEgp) {
            return response()->json([
                'message' => "Minimum order amount for card payments is {$stripeMinEgp} EGP",
                'errors' => ['total' => ["Minimum order amount is {$stripeMinEgp} EGP"]]
            ], 400);
        }

        // Begin database transaction
        DB::beginTransaction();

        try {
            // Create order
            $order = Order::create([
                'order_number' => $this->generateOrderNumber(),
                'user_id' => $user->id,
                'subtotal' => $subtotal,
                'tax' => $tax,
                'shipping_cost' => $shippingCost,
                'discount' => $discountAmount,
                'discount_code' => $appliedDiscount ? $appliedDiscount->code : null,
                'discount_type' => $appliedDiscount ? $appliedDiscount->type : null,
                'total' => $total,
                'currency' => 'EGP',
                'currency_symbol' => 'E£',
                'status' => 'pending',
                'payment_status' => 'unpaid',
                'payment_method' => $request->payment_method,
                'shipping_status' => 'pending',
                'shipping_address' => $request->shipping_address,
                'billing_address' => $request->billing_address ?? $request->shipping_address,
                'shipping_method' => $request->shipping_method,
                'shipping_notes' => $request->shipping_notes,
                'customer_notes' => $request->customer_notes,
                'created_by' => $user->id,
                'updated_by' => $user->id,
            ]);

            // Create order items from cart items
            foreach ($cart->items as $cartItem) {
                $product = $cartItem->product;
                $unit = $product->unit ?? 'kg';

                // Calculate item values
                $itemTotal = $this->calculateItemTotal($cartItem, $product, $unit);
                $pricePerUnit = $this->getPricePerUnit($cartItem, $product, $unit);
                $quantityValue = $this->getQuantityValue($cartItem, $product, $unit);

                // Calculate weight in kg for the weight field
                $weightInKg = $this->getWeightInKg($cartItem, $product, $unit);

                // Create order item with existing schema
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $product->id,
                    'product_name' => $product->title,
                    // 'product_name_ar' => $product->title_ar,
                    'product_image' => $product->image,
                    'unit_price' => $pricePerUnit,
                    'unit_cost' => $product->cost ?? null,
                    'quantity_grams' => $cartItem->quantity_grams,
                    'total' => $itemTotal,
                    'discount' => 0,
                    'unit' => $unit,
                    'weight' => $weightInKg,
                    'options' => json_encode([
                        'unit_type' => $unit,
                        'quantity_value' => $quantityValue,
                        'unit_label' => $this->getUnitLabel($unit),
                        'quantity_display' => $this->getQuantityDisplayForOrder($cartItem, $product, $unit)
                    ])
                ]);

                // Update product stock based on unit type
                $stockReduction = $this->getStockReduction($cartItem, $product, $unit);
                $product->decrement('stock', $stockReduction);
            }

            // Create payment record
            $payment = $this->createPaymentRecord($order, $request);

            // Clear the cart
            $cart->status = 'completed';
            $cart->processed_at = now();
            $cart->save();
            $cart->items()->delete();


            DB::commit();

            // Process payment based on method
            if ($request->payment_method === 'stripe') {
                return $this->processStripeCheckout($order, $payment, $request);
            } elseif ($request->payment_method === 'cash_on_delivery') {
                return $this->processCashOnDelivery($order, $payment);
            }

            return response()->json([
                'message' => 'Order created successfully',
                'order' => $order->load('items'),
                'payment' => $payment
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            if (isset($cart)) {
            $cart->status = 'active';
            $cart->save();
    }
            Log::error('Checkout failed: ' . $e->getMessage(), [
                'user_id' => $user->id,
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'message' => 'Checkout failed. Please try again.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Calculate item total based on unit type
     */
    protected function calculateItemTotal($cartItem, $product, string $unit): float
    {
        $pricePerUnit = $this->getPricePerUnit($cartItem, $product, $unit);
        $quantity = $this->getQuantityValue($cartItem, $product, $unit);

        return round($pricePerUnit * $quantity, 2);
    }

    /**
     * Get price per unit based on product unit
     */
    protected function getPricePerUnit($cartItem, $product, string $unit): float
    {
        $priceAtAdd = (float) $cartItem->price_at_add;

        // For pack/piece items, price_at_add should already be per unit
        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            // If price seems too low (less than 50) but product price is higher, use product price
            if ($priceAtAdd < 50 && $priceAtAdd > 0) {
                $correctPrice = $product->sale_price ?? $product->price;
                if ($correctPrice >= 50) {
                    return $correctPrice;
                }
            }
            return $priceAtAdd;
        }

        // For weight-based items
        if ($unit === 'kg') {
            return $priceAtAdd;
        }

        if ($unit === 'g') {
            return $priceAtAdd / 1000;
        }

        if ($unit === 'liter') {
            return $priceAtAdd;
        }

        return $priceAtAdd;
    }

    /**
     * Get quantity value in product's natural unit
     */
    protected function getQuantityValue($cartItem, $product, string $unit): float
    {
        $quantityInGrams = (float) $cartItem->quantity_grams;

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            // For pack/piece items, quantity_grams stores the number of units
            return $quantityInGrams;
        }

        if ($unit === 'kg') {
            return $quantityInGrams / 1000;
        }

        if ($unit === 'g') {
            return $quantityInGrams;
        }

        if ($unit === 'liter') {
            return $quantityInGrams / 1000;
        }

        return $quantityInGrams / 1000;
    }

    /**
     * Get weight in kg for the weight field
     */
    protected function getWeightInKg($cartItem, $product, string $unit): float
    {
        $quantityInGrams = (float) $cartItem->quantity_grams;

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            // Convert pieces to kg using grams_per_unit
            $gramsPerUnit = $product->grams_per_unit ?? $this->getDefaultGramsPerUnit($unit);
            return ($quantityInGrams * $gramsPerUnit) / 1000;
        }

        // For weight-based items, just convert grams to kg
        return $quantityInGrams / 1000;
    }

    /**
     * Get quantity display for cart
     */
    protected function getQuantityDisplayForCart($cartItem, $product, string $unit): string
    {
        $quantity = $this->getQuantityValue($cartItem, $product, $unit);
        $label = $this->getUnitLabel($unit);

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            return round($quantity) . ' ' . $label;
        }

        if ($unit === 'kg') {
            return number_format($quantity, 2) . ' ' . $label;
        }

        if ($unit === 'g') {
            return round($quantity) . ' ' . $label;
        }

        return number_format($quantity, 2) . ' ' . $label;
    }

    /**
     * Get quantity display for order (stored in options)
     */
    protected function getQuantityDisplayForOrder($cartItem, $product, string $unit): string
    {
        $quantity = $this->getQuantityValue($cartItem, $product, $unit);
        $label = $this->getUnitLabel($unit);

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            return round($quantity) . ' ' . $label;
        }

        if ($unit === 'kg') {
            return number_format($quantity, 2) . ' ' . $label;
        }

        return number_format($quantity, 2) . ' ' . $label;
    }



    /**
     * Calculate cart subtotal with unit awareness
     */
    protected function calculateSubtotal($cart)
    {
        $subtotal = 0;

        foreach ($cart->items as $item) {
            $product = $item->product;
            $unit = $product->unit ?? 'kg';
            $subtotal += $this->calculateItemTotal($item, $product, $unit);
        }

        return $subtotal;
    }

    /**
     * Validate stock with unit awareness
     */
    protected function validateStock($cart)
    {
        $errors = [];

        foreach ($cart->items as $item) {
            $product = $item->product;
            $unit = $product->unit ?? 'kg';
            $requiredStock = $this->getStockReduction($item, $product, $unit);

            if ($product->stock < $requiredStock) {
                $quantityDisplay = $this->getQuantityDisplayForCart($item, $product, $unit);

                $errors["product_{$product->id}"] = [
                    'message' => "Insufficient stock for {$product->title}",
                    'available' => $product->stock,
                    'requested' => $requiredStock,
                    'requested_display' => $quantityDisplay
                ];
            }
        }

        return $errors;
    }

    /**
     * Get unit label
     */
    protected function getUnitLabel(string $unit): string
    {
        $labels = [
            'kg' => 'kg',
            'g' => 'g',
            'piece' => 'قطعة',
            'liter' => 'لتر',
            'pack' => 'حزمة',
            'bunch' => 'حزمة'
        ];

        return $labels[$unit] ?? $unit;
    }

    /**
     * Get default grams per unit for non-weight units
     */
    protected function getDefaultGramsPerUnit(string $unit): float
    {
        $defaults = [
            'piece' => 250,
            'pack' => 100,
            'bunch' => 200,
            'liter' => 1000
        ];

        return $defaults[$unit] ?? 1000;
    }

    /**
     * Calculate tax (14% VAT)
     */
    protected function calculateTax($subtotal)
    {
        return $subtotal * 0.14;
    }

    /**
     * Calculate discount
     */
    protected function calculateDiscount($subtotal, $discountCode = null)
    {
        if (!$discountCode) {
            return 0;
        }
        return 0;
    }



    public function applyDiscount(Request $request)
    {
        $request->validate([
            'code' => 'required|string',
            'subtotal' => 'required|numeric|min:0'
        ]);

        $discount = Discount::where('code', strtoupper($request->code))->first();

        if (!$discount) {
            return response()->json(['message' => 'Invalid coupon code', 'valid' => false], 404);
        }

        if (!$discount->isValid()) {
            return response()->json(['message' => 'This coupon is no longer valid', 'valid' => false], 400);
        }

        $discountAmount = $discount->calculateDiscount($request->subtotal);

        if ($discountAmount <= 0) {
            return response()->json(['message' => 'Coupon does not apply to this order', 'valid' => false], 400);
        }

        return response()->json([
            'valid' => true,
            'discount' => [
                'code' => $discount->code,
                'amount' => round($discountAmount, 2),
                'type' => $discount->type,
                'value' => $discount->value
            ]
        ]);
    }

    /**
     * Generate unique order number
     */
    protected function generateOrderNumber()
    {
        $prefix = 'ORD-';
        $date = now()->format('Ymd');
        $random = strtoupper(Str::random(6));
        $orderNumber = $prefix . $date . '-' . $random;

        while (Order::where('order_number', $orderNumber)->exists()) {
            $random = strtoupper(Str::random(6));
            $orderNumber = $prefix . $date . '-' . $random;
        }

        return $orderNumber;
    }

    /**
     * Create payment record
     */
    protected function createPaymentRecord($order, $request)
    {
        return Payment::create([
            'order_id' => $order->id,
            'payment_method' => $request->payment_method,
            'status' => $request->payment_method === 'cash_on_delivery' ? 'on_hold' : 'pending',
            'amount' => $order->total,
            'currency' => 'EGP',
            'customer_name' => $request->shipping_address['name'] ?? null,
            'customer_email' => $request->shipping_address['email'] ?? null,
            'customer_phone' => $request->shipping_address['phone'] ?? null,
            'billing_address' => $request->billing_address,
            'shipping_address' => $request->shipping_address,
            'payment_description' => "Order #{$order->order_number}",
            'created_by' => $order->user_id,
            'updated_by' => $order->user_id,
            'cod_due_date' => $request->payment_method === 'cash_on_delivery' ? now()->addDays(7) : null,
        ]);
    }

    /**
     * Process Stripe Checkout
     */
    protected function processStripeCheckout($order, $payment, $request)
    {
        try {
            $stripeSession = $this->paymentService->createStripeSession($order, $request);

            $payment->update([
                'stripe_session_id' => $stripeSession->id,
                'payment_intent_id' => $stripeSession->payment_intent,
                'stripe_response' => json_encode($stripeSession),
                'transaction_id' => $stripeSession->payment_intent
            ]);

            return response()->json([
                'message' => 'Redirecting to payment',
                'payment_method' => 'stripe',
                'session_id' => $stripeSession->id,
                'checkout_url' => $stripeSession->url,
                'order' => $order->load('items'),
                'cart' => [
                    'items' => [],
                    'items_count' => 0
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Stripe session creation failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Payment processing failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process Cash on Delivery
     */
    protected function processCashOnDelivery($order, $payment)
    {
        return response()->json([
            'message' => 'Order placed successfully with Cash on Delivery',
            'order' => $order->load('items'),
            'payment' => $payment,
            'cart' => [
                'items' => [],
                'items_count' => 0
            ]
        ]);
    }

    /**
     * Verify Stripe session
     */
    public function verifySession($sessionId)
    {
        try {
            $result = $this->paymentService->verifySession($sessionId);

            if ($result['success']) {
                return response()->json([
                    'success' => true,
                    'order' => $result['order']
                ]);
            }

            return response()->json([
                'success' => false,
                'message' => 'Payment not completed'
            ]);
        } catch (\Exception $e) {
            Log::error('Session verification failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Verification failed'
            ], 400);
        }
    }

    /**
     * Handle Stripe webhook
     */
    public function handleWebhook(Request $request)
    {
        return $this->paymentService->handleWebhook($request);
    }

    /**
     * Get shipping methods
     */
    protected function getShippingMethods()
    {
        return [
            [
                'id' => 'standard',
                'name' => 'Standard Shipping',
                'description' => 'Delivery in 3-5 business days',
                'cost' => 6,
                'estimated_days' => '3-5'
            ],
            [
                'id' => 'express',
                'name' => 'Express Shipping',
                'description' => 'Delivery in 1-2 business days',
                'cost' => 12,
                'estimated_days' => '1-2'
            ],
            [
                'id' => 'next_day',
                'name' => 'Next Day Delivery',
                'description' => 'Delivery next business day',
                'cost' => 20,
                'estimated_days' => '1'
            ]
        ];
    }

    /**
     * Get payment methods
     */
    protected function getPaymentMethods()
    {
        return [
            [
                'id' => 'stripe',
                'name' => 'Credit/Debit Card',
                'description' => 'Pay securely with Visa, Mastercard, or American Express',
                'icon' => 'card',
                'enabled' => true
            ],
            [
                'id' => 'cash_on_delivery',
                'name' => 'Cash on Delivery',
                'description' => 'Pay with cash when your order arrives',
                'icon' => 'cash',
                'enabled' => true,
                'additional_fee' => 0
            ]
        ];
    }




/**
 * Get requested quantity based on product unit
 */
protected function getRequestedQuantity($cartItem, $product, string $unit): float
{
    $quantityInGrams = (float) $cartItem->quantity_grams;

    if (in_array($unit, ['pack', 'piece', 'bunch'])) {
        // For pack/piece items, quantity_grams stores the number of units
        // But ensure we're not treating grams as pieces
        $gramsPerUnit = $product->grams_per_unit ?? $this->getDefaultGramsPerUnit($unit);

        // If quantity_grams is large (> 100) and grams_per_unit is small, it might be in grams
        if ($quantityInGrams > 100 && $gramsPerUnit < 1000) {
            // Convert from grams to pieces
            $pieces = round($quantityInGrams / $gramsPerUnit);
            Log::warning('Converting grams to pieces for stock check', [
                'product_id' => $product->id,
                'quantity_grams' => $quantityInGrams,
                'grams_per_unit' => $gramsPerUnit,
                'calculated_pieces' => $pieces
            ]);
            return max(1, $pieces);
        }

        // Otherwise, quantity_grams already represents number of units
        return max(1, $quantityInGrams);
    }

    // For weight-based items, convert to kg
    return $quantityInGrams / 1000;
}

/**
 * Get stock display
 */
protected function getStockDisplay($product): string
{
    $unit = $product->unit ?? 'kg';
    $stock = (float) ($product->stock ?? 0);
    $label = $this->getUnitLabel($unit);

    if (in_array($unit, ['pack', 'piece', 'bunch'])) {
        return round($stock) . ' ' . $label;
    }

    if ($unit === 'kg') {
        return number_format($stock, 2) . ' ' . $label;
    }

    if ($unit === 'g') {
        return number_format($stock * 1000) . ' ' . $label;
    }

    return number_format($stock, 2) . ' ' . $label;
}


protected function getStockReduction($cartItem, $product, string $unit): float
{
    $quantityInGrams = (float) $cartItem->quantity_grams;

    if (in_array($unit, ['pack', 'piece', 'bunch'])) {
        // Determine if quantity_grams is in grams or pieces
        $gramsPerUnit = $product->grams_per_unit ?? $this->getDefaultGramsPerUnit($unit);

        // If quantity_grams is large (> 100) and grams_per_unit is small, it's likely in grams
        if ($quantityInGrams > 100 && $gramsPerUnit < 1000) {
            $pieces = round($quantityInGrams / $gramsPerUnit);
            Log::info('Converting grams to pieces for stock reduction', [
                'product_id' => $product->id,
                'quantity_grams' => $quantityInGrams,
                'grams_per_unit' => $gramsPerUnit,
                'pieces_to_reduce' => $pieces
            ]);
            return max(1, $pieces);
        }

        // Otherwise, quantity_grams already represents number of units
        return max(1, $quantityInGrams);
    }

    // For kg, convert grams to kg
    if ($unit === 'kg') {
        return $quantityInGrams / 1000;
    }

    // For g, convert to kg
    if ($unit === 'g') {
        return $quantityInGrams / 1000;
    }

    // For liter, convert to kg equivalent
    if ($unit === 'liter') {
        return $quantityInGrams / 1000;
    }

    return $quantityInGrams / 1000;
}



}


