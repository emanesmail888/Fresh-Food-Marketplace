<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\UserResource;
use  App\Http\Services\CartService;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use App\Models\User;
use App\Models\Cart;
use Illuminate\Auth\Events\Registered;




class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email'=> ['required', 'email'],
            'password' => 'required',
            'remember' => 'boolean'
        ]);

        $remember = $credentials['remember'] ?? false;

        unset($credentials['remember']);
        if (!Auth::attempt($credentials, $remember)) {
            return response([
                'message' => 'Email or password is incorrect'
            ], 422);
        }


        /** @var \App\Models\User $user */
        $user = Auth::user();

        // if (!$user->is_admin) {
        //     Auth::logout();
        //     return response([
        //         'message' => 'You don\'t have permission to authenticate as admin'
        //     ], 403);
        // }
        // if (!$user->email_verified_at) {
        //     Auth::logout();
        //     return response([
        //         'message' => 'Your email address is not verified'
        //     ], 403);
        // }
        $token = $user->createToken('main')->plainTextToken;

         // Merge guest cart with user cart
        try {


            $cartService = app(CartService::class);
            $cartService->mergeGuestCartWithUserCart($user);
        } catch (\Exception $e) {
            Log::error('Cart merge error during login: ' . $e->getMessage());
            // Continue even if cart merge fails
        }

        return response([
            'user' => new UserResource($user),
            'token' => $token,

        ]);

    }


    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'confirmed', Password::min(8)],
            'terms' => ['required', 'accepted'],
        ]);

        // Create user
        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'is_admin' => false, // Default to non-admin
        ]);

        // 🔥 Fire the Registered event here
        event(new Registered($user));

        // Log the user in
        Auth::login($user);

        // Generate token
        $token = $user->createToken('main')->plainTextToken;

        // Merge guest cart with user cart if needed
        try {
            $cartService = app(CartService::class);
            $cartService->mergeGuestCartWithUserCart($user);
        } catch (\Exception $e) {
            Log::error('Cart merge error during registration: ' . $e->getMessage());
            // Continue even if cart merge fails
        }

        return response()->json([
            'user' => new UserResource($user),
            'token' => $token,
            'message' => 'Registration successful'
        ], 201);
    }



    public function logout(Request $request)
    {


            if ($request->user()) {

                // ===== CLEANUP CART =====
                // $this->cleanupUserCart($request->user());
                $currentToken = $request->user()->currentAccessToken();

                if ($currentToken) {

                $tokenClass = get_class($currentToken);

                    if ($tokenClass !== 'Laravel\Sanctum\TransientToken') {
                        $currentToken->delete();
                        $request->session()->invalidate();
                        $request->session()->regenerateToken();

                        return response('', 204);

                     } else {
                        Log::info('TransientToken detected, skipping deletion');
                    }
                } else {
                    Log::info('No current access token found');
                }
            } else {
                Log::info('No authenticated user found during logout');
            }

            return response()->json([
                'success' => true,
                'message' => 'تم تسجيل الخروج بنجاح'
            ]);

    }


    /**
 * Clean up user's cart on logout
 */
    private function cleanupUserCart($user)
    {
        try {
            // Option 1: Delete cart completely
            Cart::where('user_id', $user->id)->delete();


        } catch (\Exception $e) {
            Log::error("Failed to clear cart: " . $e->getMessage());
        }
    }
    public function getUser(Request $request)
    {
         $cartService = app(CartService::class);
            $cartService->mergeGuestCartWithUserCart($request->user());
        return new UserResource($request->user());

    }

}
