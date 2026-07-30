<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Stripe\Stripe;


class StripeWebhookController extends Controller
{
    public function handleWebhook(Request $request)
    {
        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');
        $endpointSecret = config('services.stripe.webhook_secret');

        try {
            $event = \Stripe\Webhook::constructEvent(
                $payload,
                $sigHeader,
                $endpointSecret
            );

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

                case 'charge.refunded':
                    $this->handleChargeRefunded($event->data->object);
                    break;
            }

            return response()->json(['status' => 'success']);

        } catch (\Exception $e) {
            Log::error('Stripe webhook failed: ' . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }

    protected function handleCheckoutSessionCompleted($session)
    {
        $payment = Payment::where('stripe_session_id', $session->id)->first();

        if ($payment && $payment->status !== 'completed') {
            $payment->markAsCompleted([
                'transaction_id' => $session->payment_intent,
                'stripe_response' => json_encode($session)
            ]);
        }
    }

    protected function handlePaymentIntentSucceeded($paymentIntent)
    {
        $payment = Payment::where('payment_intent_id', $paymentIntent->id)->first();

        if ($payment && $payment->status !== 'completed') {
            $payment->markAsCompleted([
                'transaction_id' => $paymentIntent->id,
                'stripe_response' => json_encode($paymentIntent)
            ]);
        }
    }

    protected function handlePaymentFailed($paymentIntent)
    {
        $payment = Payment::where('payment_intent_id', $paymentIntent->id)->first();

        if ($payment) {
            $payment->markAsFailed(
                $paymentIntent->last_payment_error?->message ?? 'Payment failed',
                $paymentIntent->last_payment_error?->code ?? 'unknown',
                $paymentIntent
            );
        }
    }

    protected function handleChargeRefunded($charge)
    {
        $payment = Payment::where('stripe_charge_id', $charge->id)
            ->orWhere('payment_intent_id', $charge->payment_intent)
            ->first();

        if ($payment) {
            $payment->refund(
                $charge->amount_refunded / 100,
                'Refunded via Stripe',
                $charge
            );
        }
    }
}
