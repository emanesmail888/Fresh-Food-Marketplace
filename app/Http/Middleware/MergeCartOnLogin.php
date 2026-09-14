<?php

namespace App\Http\Middleware;

use App\Http\Services\CartService;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class MergeCartOnLogin
{

protected $cartService;

    public function __construct(CartService $cartService)
    {
        $this->cartService = $cartService;
    }
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
         // Check if user is authenticated
        if (Auth::check()) {
            $user = Auth::user();
            
            // Only merge if session has guest cart
            $guestCartId = session()->get('cart_id');
            
            if ($guestCartId) {
                Log::info('Middleware: Merging cart on request', [
                    'user_id' => $user->id,
                    'guest_cart_id' => $guestCartId
                ]);
                
                try {
                    $this->cartService->mergeGuestCartWithUserCart($user);
                } catch (\Exception $e) {
                    Log::error('Middleware: Failed to merge cart', [
                        'error' => $e->getMessage()
                    ]);
                }
            }
        }

        return $next($request);
    
    }
}
