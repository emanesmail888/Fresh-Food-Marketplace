<?php

namespace App\Http\Services;

use App\Models\Order;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Stripe\Checkout\Session;
use Stripe\Stripe;
use Stripe\Webhook;


class PaymentService
{
    public function __construct()
    {
        Stripe::setApiKey(config('services.stripe.secret'));
    }

    /**
     * Create Stripe Checkout Session with unit-aware product display
     */
    public function createStripeSession(Order $order, $request)
    {
        $lineItems = [];

        foreach ($order->items as $item) {
            // Get product details with unit awareness
            $productName = $this->getProductDisplayName($item);
            $unitAmount = $this->getUnitAmountInPiasters($item);

            // Get product image
            $productImage = $item->product_image ? url('storage/' . $item->product_image) : null;

            $lineItems[] = [
                'price_data' => [
                    'currency' => 'egp',
                    'unit_amount' => $unitAmount,
                    'product_data' => [
                        'name' => $productName,
                        'images' => $productImage ? [$productImage] : [],
                        'metadata' => [
                            'product_id' => (string) $item->product_id,
                            'unit' => $item->unit ?? 'kg',
                            'quantity' => (string) ($item->quantity_value ?? $item->quantity_grams),
                            'quantity_display' => $item->quantity_display ?? $this->getQuantityDisplay($item)
                        ]
                    ],
                ],
                'quantity' => 1,
            ];
        }

        // Add shipping as a line item
        if ($order->shipping_cost > 0) {
            $lineItems[] = [
                'price_data' => [
                    'currency' => 'egp',
                    'unit_amount' => (int) round($order->shipping_cost * 100),
                    'product_data' => [
                        'name' => 'Shipping (' . ($order->shipping_method ?? 'Standard') . ')',
                    ],
                ],
                'quantity' => 1,
            ];
        }

        // Add tax as a line item
        if ($order->tax > 0) {
            $lineItems[] = [
                'price_data' => [
                    'currency' => 'egp',
                    'unit_amount' => (int) round($order->tax * 100),
                    'product_data' => [
                        'name' => 'Tax (VAT 14%)',
                    ],
                ],
                'quantity' => 1,
            ];
        }

        $frontendUrl = config('app.frontend_url', 'http://localhost:5173');

        $session = Session::create([
            'payment_method_types' => ['card'],
            'line_items' => $lineItems,
            'mode' => 'payment',
            'success_url' => $frontendUrl . '/checkout/success?session_id={CHECKOUT_SESSION_ID}',
            'cancel_url' => $frontendUrl . '/checkout',
            'customer_email' => $request->shipping_address['email'] ?? $order->user?->email ?? null,
            'client_reference_id' => (string) $order->id,
            'metadata' => [
                'order_number' => $order->order_number,
                'user_id' => (string) $order->user_id,
                'order_total' => (string) $order->total,
                'payment_method' => 'stripe'
            ],
            'shipping_address_collection' => [
                'allowed_countries' => ['EG'],
            ],
            'phone_number_collection' => [
                'enabled' => true,
            ],
            'payment_intent_data' => [
                'metadata' => [
                    'order_number' => $order->order_number,
                    'order_id' => (string) $order->id,
                    'user_id' => (string) $order->user_id
                ]
            ]
        ]);

        // Update the payment record with session and payment intent IDs
        $payment = Payment::where('order_id', $order->id)->latest()->first();
        if ($payment) {
            $payment->update([
                'stripe_session_id' => $session->id,
                'payment_intent_id' => $session->payment_intent,
                'transaction_id' => $session->payment_intent,
                'stripe_response' => json_encode($session)
            ]);

            Log::info('Payment record updated with Stripe IDs', [
                'order_number' => $order->order_number,
                'session_id' => $session->id,
                'payment_intent_id' => $session->payment_intent
            ]);
        }

        return $session;
    }

    /**
     * Get product display name with unit-aware quantity
     */
    protected function getProductDisplayName($item): string
    {
        $unit = $item->unit ?? 'kg';
        $quantityDisplay = $item->quantity_display ?? $this->getQuantityDisplay($item);

        // For pack/piece items, show quantity in pieces/packs
        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            $quantity = $item->quantity_value ?? $item->quantity_grams;
            $unitLabel = $this->getUnitLabel($unit);
            return sprintf("%s – %s %s", $item->product_name, round($quantity), $unitLabel);
        }

        // For weight-based items
        if ($unit === 'kg') {
            $weight = $item->weight ?? ($item->quantity_grams / 1000);
            return sprintf("%s – %.2f kg", $item->product_name, $weight);
        }

        if ($unit === 'g') {
            $grams = $item->quantity_grams;
            return sprintf("%s – %d g", $item->product_name, round($grams));
        }

        if ($unit === 'liter') {
            $liters = $item->quantity_grams / 1000;
            return sprintf("%s – %.2f L", $item->product_name, $liters);
        }

        return sprintf("%s – %s", $item->product_name, $quantityDisplay);
    }

    /**
     * Get unit amount in piasters (cents)
     */
    protected function getUnitAmountInPiasters($item): int
    {
        $itemTotal = $item->total;

        // Ensure minimum amount (Stripe requires at least 0.50 EGP = 50 piasters)
        if ($itemTotal < 0.50) {
            Log::warning('Item total below Stripe minimum', [
                'product_name' => $item->product_name,
                'original_total' => $itemTotal,
                'adjusted_total' => 0.50
            ]);
            $itemTotal = 0.50;
        }

        return (int) round($itemTotal * 100);
    }

    /**
     * Get quantity display string
     */
    protected function getQuantityDisplay($item): string
    {
        $unit = $item->unit ?? 'kg';
        $quantity = $item->quantity_value ?? $item->quantity_grams;
        $label = $this->getUnitLabel($unit);

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            return round($quantity) . ' ' . $label;
        }

        if ($unit === 'kg') {
            $kgValue = $quantity / 1000;
            return number_format($kgValue, 2) . ' ' . $label;
        }

        if ($unit === 'g') {
            return round($quantity) . ' ' . $label;
        }

        if ($unit === 'liter') {
            $literValue = $quantity / 1000;
            return number_format($literValue, 2) . ' ' . $label;
        }

        return $quantity . ' ' . $label;
    }

    /**
     * Get unit label
     */
    protected function getUnitLabel(string $unit): string
    {
        $labels = [
            'kg' => 'kg',
            'g' => 'g',
            'piece' => 'piece',
            'liter' => 'L',
            'pack' => 'pack',
            'bunch' => 'bunch'
        ];

        return $labels[$unit] ?? $unit;
    }

    /**
     * Verify Stripe session after return
     */
    public function verifySession($sessionId)
    {
        try {
            $session = Session::retrieve($sessionId);

            Log::info('Verifying Stripe session', [
                'session_id' => $sessionId,
                'payment_status' => $session->payment_status,
                'payment_intent' => $session->payment_intent
            ]);

            if ($session->payment_status === 'paid') {
                // Find the payment record
                $payment = Payment::where('stripe_session_id', $sessionId)->first();

                if ($payment) {
                    // Update payment intent if not already set
                    if (!$payment->payment_intent_id && $session->payment_intent) {
                        $payment->payment_intent_id = $session->payment_intent;
                        $payment->transaction_id = $session->payment_intent;
                    }

                    if ($payment->status !== 'completed') {
                        $payment->markAsCompleted([
                            'transaction_id' => $session->payment_intent,
                            'stripe_response' => json_encode($session)
                        ]);
                    } else {
                        $payment->save();
                    }
                }

                $order = Order::with('items')
                    ->where('id', $session->client_reference_id)
                    ->first();

                if ($order && $order->payment_status !== 'paid') {
                    // Update order payment status
                    $order->update([
                        'payment_status' => 'paid',
                        'status' => 'processing'
                    ]);

                    Log::info('Order payment verified', [
                        'order_id' => $order->id,
                        'order_number' => $order->order_number
                    ]);
                }

                if ($order) {
                    return [
                        'success' => true,
                        'order' => $order
                    ];
                }
            }

            return [
                'success' => false,
                'message' => 'Payment not completed'
            ];
        } catch (\Exception $e) {
            Log::error('Session verification failed: ' . $e->getMessage(), [
                'session_id' => $sessionId,
                'trace' => $e->getTraceAsString()
            ]);
            throw $e;
        }
    }

    /**
     * Handle Stripe webhook
     */
    public function handleWebhook(Request $request)
    {
        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');
        $endpointSecret = config('services.stripe.webhook_secret');

        if (!$endpointSecret) {
            Log::error('Stripe webhook secret not configured');
            return response()->json(['error' => 'Webhook secret not configured'], 500);
        }

        try {
            $event = Webhook::constructEvent($payload, $sigHeader, $endpointSecret);

            Log::info('Stripe webhook received', [
                'event_type' => $event->type,
                'event_id' => $event->id
            ]);

            switch ($event->type) {
                case 'checkout.session.completed':
                    $this->handleCheckoutSessionCompleted($event->data->object);
                    break;

                case 'payment_intent.succeeded':
                    $this->handlePaymentIntentSucceeded($event->data->object);
                    break;

                case 'payment_intent.payment_failed':
                    $this->handlePaymentFailed($event->data->object);
                    break;

                case 'checkout.session.expired':
                    $this->handleCheckoutSessionExpired($event->data->object);
                    break;
            }

            return response()->json(['status' => 'success']);

        } catch (\Exception $e) {
            Log::error('Stripe webhook failed: ' . $e->getMessage(), [
                'payload' => $payload,
                'signature' => $sigHeader
            ]);
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }

    /**
     * Handle checkout.session.completed webhook
     */
    protected function handleCheckoutSessionCompleted($session)
    {
        $payment = Payment::where('stripe_session_id', $session->id)->first();

        if ($payment) {
            // Update payment intent if not already set
            if (!$payment->payment_intent_id && $session->payment_intent) {
                $payment->payment_intent_id = $session->payment_intent;
                $payment->transaction_id = $session->payment_intent;
            }

            if ($payment->status !== 'completed') {
                $payment->markAsCompleted([
                    'transaction_id' => $session->payment_intent,
                    'stripe_response' => json_encode($session)
                ]);
            } else {
                $payment->save();
            }

            // Update order status
            $order = Order::find($payment->order_id);
            if ($order && $order->payment_status !== 'paid') {
                $order->update([
                    'payment_status' => 'paid',
                    'status' => 'processing'
                ]);
            }

            Log::info('Webhook: Checkout session completed', [
                'session_id' => $session->id,
                'payment_intent' => $session->payment_intent,
                'order_id' => $session->client_reference_id
            ]);
        } else {
            Log::warning('Webhook: Payment record not found for session', [
                'session_id' => $session->id,
                'order_id' => $session->client_reference_id
            ]);
        }
    }

    /**
     * Handle payment_intent.succeeded webhook
     */
    protected function handlePaymentIntentSucceeded($paymentIntent)
    {
        $payment = Payment::where('payment_intent_id', $paymentIntent->id)
            ->orWhere('transaction_id', $paymentIntent->id)
            ->first();

        if ($payment && $payment->status !== 'completed') {
            $payment->markAsCompleted([
                'transaction_id' => $paymentIntent->id,
                'stripe_response' => json_encode($paymentIntent)
            ]);

            // Update order status
            $order = Order::find($payment->order_id);
            if ($order && $order->payment_status !== 'paid') {
                $order->update([
                    'payment_status' => 'paid',
                    'status' => 'processing'
                ]);
            }

            Log::info('Webhook: Payment intent succeeded', [
                'payment_intent_id' => $paymentIntent->id,
                'order_id' => $payment->order_id
            ]);
        }
    }

    /**
     * Handle payment_intent.payment_failed webhook
     */
    protected function handlePaymentFailed($paymentIntent)
    {
        $payment = Payment::where('payment_intent_id', $paymentIntent->id)
            ->orWhere('transaction_id', $paymentIntent->id)
            ->first();

        if ($payment) {
            $payment->markAsFailed(
                $paymentIntent->last_payment_error?->message ?? 'Payment failed',
                $paymentIntent->last_payment_error?->code ?? 'unknown',
                $paymentIntent
            );

            // Update order status
            $order = Order::find($payment->order_id);
            if ($order) {
                $order->update([
                    'payment_status' => 'failed'
                ]);
            }

            Log::warning('Webhook: Payment intent failed', [
                'payment_intent_id' => $paymentIntent->id,
                'error' => $paymentIntent->last_payment_error?->message,
                'order_id' => $payment->order_id
            ]);
        }
    }

    /**
     * Handle checkout.session.expired webhook
     */
    protected function handleCheckoutSessionExpired($session)
    {
        $payment = Payment::where('stripe_session_id', $session->id)->first();

        if ($payment && $payment->status === 'pending') {
            $payment->markAsFailed('Checkout session expired', 'session_expired', $session);

            Log::info('Webhook: Checkout session expired', [
                'session_id' => $session->id,
                'order_id' => $payment->order_id
            ]);
        }
    }
}
