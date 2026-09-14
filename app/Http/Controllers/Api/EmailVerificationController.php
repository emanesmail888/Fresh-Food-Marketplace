<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Auth\Events\Verified;
use Illuminate\Support\Facades\URL;
use Illuminate\Http\JsonResponse;
use Illuminate\Foundation\Auth\EmailVerificationRequest;


class EmailVerificationController extends Controller
{


    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    /**
     * Get current user's email verification status
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'verified' => $user->hasVerifiedEmail(),
            'email'    => $user->email,
        ]);
    }

    /**
     * Resend verification email
     * Protected by rate limiting
     */
    public function resend(Request $request): JsonResponse
    {
        $user = $request->user();

        if ($user->hasVerifiedEmail()) {
            return response()->json([
                'message' => 'Email is already verified.'
            ], 400);
        }

        $user->sendEmailVerificationNotification();

        return response()->json([
            'message' => 'Verification link has been sent to your email.'
        ]);
    }

    /**
     * Handle the actual verification when user clicks the link
     * (Usually called via GET /email/verify/{id}/{hash})
     *
     * using Laravel  EmailVerificationRequest
     */
    public function verify(EmailVerificationRequest $request): JsonResponse
    {
        $request->fulfill();

        return response()->json([
            'message' => 'Email has been successfully verified.'
        ]);
    }
}
