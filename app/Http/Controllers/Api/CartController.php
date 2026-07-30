<?php

namespace App\Http\Controllers\Api;


use App\Http\Controllers\Controller;
use App\Http\Requests\AddItemRequest;
use App\Http\Requests\UpdateQuantityRequest;
use App\Http\Resources\CartResource;
use App\Http\Resources\CartItemResource;
use App\Models\Cart;
use App\Models\Product;
use  App\Http\Services\CartService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;


class CartController extends Controller
{
     public function __construct(
        private CartService $cartService
    ) {}

    /**
     * Get current user's cart (authenticated or guest)
     */
    public function index(Request $request): JsonResponse
    {
        // Log::info('Cart index called', [
        //     'session_id' => Session::getId(),
        //     'user' => $request->user()?->id
        // ]);

        $user = $request->user();
        $cart = $this->cartService->getCartWithItems($user);

        return response()->json([
            'success' => true,
            'data' => new CartResource($cart)
        ]);
    }

    /**
     * Add item to cart (authenticated or guest)
     */
    public function addItem(AddItemRequest $request): JsonResponse
    {
        Log::info('Add item endpoint called', [
            'session_id' => Session::getId(),
            'user' => $request->user()?->id,
            'request_data' => $request->validated()
        ]);

        $validated = $request->validated();
        $user = $request->user();

        try {
            $cartItem = $this->cartService->addItem(
                $user,
                $validated['product_id'],
                $validated['quantity_grams']
            );

            // Get the cart with all items loaded
            $cart = $this->cartService->getCartWithItems($user);

            return response()->json([
                'success' => true,
                'message' => 'تمت إضافة المنتج إلى السلة',
                'data' => [
                    'item' => new CartItemResource($cartItem),
                    'cart' => new CartResource($cart)
                ]
            ], 201);
        } catch (\Exception $e) {
            Log::error('Failed to add item to cart', [
                'error' => $e->getMessage(),
                'product_id' => $validated['product_id'],
                'session_id' => Session::getId()
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }





    /**
     * Update item quantity (authenticated or guest)
     */
    public function updateQuantity(UpdateQuantityRequest $request, $itemId): JsonResponse
    {
        $validated = $request->validated();
        $user = $request->user();

        try {
            $cartItem = $this->cartService->updateQuantity(
                $user,
                $itemId,
                $validated['quantity_grams']
            );

            $cart = $this->cartService->getCartWithItems($user);

            return response()->json([
                'success' => true,
                'message' => 'تم تحديث الكمية',
                'data' => [
                    'item' => new CartItemResource($cartItem),
                    'cart' => new CartResource($cart)
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to update quantity', [
                'error' => $e->getMessage(),
                'item_id' => $itemId
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    /**
     * Remove item from cart (authenticated or guest)
     */
    public function removeItem(Request $request, $itemId): JsonResponse
    {
        $user = $request->user();

        try {
            $cartItem = $this->cartService->removeItem($user, $itemId);
            $cart = $this->cartService->getCartWithItems($user);

            return response()->json([
                'success' => true,
                'message' => 'تم حذف المنتج من السلة',
                'data' => [
                    'removed_item_id' => $itemId,
                    'cart' => new CartResource($cart)
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to remove item', [
                'error' => $e->getMessage(),
                'item_id' => $itemId
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Clear cart (authenticated or guest)
     */
    public function clear(Request $request): JsonResponse
    {
        $user = $request->user();

        try {
            $this->cartService->clearCart($user);

            $cart = $this->cartService->getCartWithItems($user);

            return response()->json([
                'success' => true,
                'message' => 'تم إفراغ السلة',
                'data' => [
                    'cart' => new CartResource($cart)
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to clear cart', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    /**
     * Merge guest cart after login
     */
    public function mergeCart(Request $request): JsonResponse
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'يجب تسجيل الدخول أولاً'
            ], 401);
        }

        try {
            $this->cartService->mergeGuestCartWithUserCart($user);

            $cart = $this->cartService->getCartWithItems($user);

            return response()->json([
                'success' => true,
                'message' => 'تم دمج السلة بنجاح',
                'data' => new CartResource($cart)
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to merge cart', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }
}
