<?php

namespace App\Http\Services;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Product;
use App\Models\User;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Str;

// class CartService
// {

//     private function getGuestSessionId(): string
//     {
//     $currentSessionId = Session::getId();

//     // Check if we have a stored guest cart ID
//     if (Session::has('guest_cart_id')) {
//     $storedSessionId = Session::get('guest_cart_id');

//     // If the stored ID is different from current session, update it
//     if ($storedSessionId !== $currentSessionId) {
//     Log::info('Updating stored guest session ID', [
//     'old' => $storedSessionId,
//     'new' => $currentSessionId
//     ]);

//     // Update any carts with the old session ID to the new one
//     Cart::where('session_id', $storedSessionId)
//     ->where('user_id', null)
//     ->update(['session_id' => $currentSessionId]);

//     Session::put('guest_cart_id', $currentSessionId);
//     Session::save();
//     }

//     return $currentSessionId;
//     }

//     // No stored guest cart ID, create one
//     Session::put('guest_cart_id', $currentSessionId);
//     Session::save();

//     Log::info('Created new guest session', [
//     'session_id' => $currentSessionId
//     ]);

//     return $currentSessionId;
//     }

//     /**
//      * Get or create cart for user (authenticated or guest via session)
//      */
//     public function getOrCreateCart(?User $user = null): Cart
//     {
//         // Log::info('Getting or creating cart - START', [
//         //     'user_id' => $user?->id,
//         //     'is_guest' => is_null($user),
//         //     'current_session_id' => Session::getId()
//         // ]);

//         if ($user) {
//             // Authenticated user - get or create cart
//             $cart = Cart::firstOrCreate(
//                 ['user_id' => $user->id],
//                 [
//                     'session_id' => null,
//                     'user_id' => $user->id
//                 ]
//             );

//             Log::info('Cart for authenticated user', [
//                 'cart_id' => $cart->id,
//                 'user_id' => $user->id,
//                 'session_id' => $cart->session_id
//             ]);

//             return $cart;
//         } else {
//             // Guest user - use session
//             $sessionId = $this->getGuestSessionId();

//             // Log::info('Looking for guest cart', [
//             //     'looking_for_session_id' => $sessionId,
//             //     'current_session_id' => Session::getId()
//             // ]);

//             // First, try to find existing cart with this session_id
//             $cart = Cart::where('session_id', $sessionId)->first();

//             if ($cart) {
//                 // Log::info('Found existing guest cart', [
//                 //     'cart_id' => $cart->id,
//                 //     'session_id' => $cart->session_id,
//                 //     'items_count' => $cart->items()->count()
//                 // ]);

//                 // Double-check this cart belongs to the current session
//                 if ($cart->session_id !== Session::getId()) {
//                     Log::warning('Cart session mismatch', [
//                         'cart_session' => $cart->session_id,
//                         'current_session' => Session::getId()
//                     ]);

//                     // Update the cart with correct session ID
//                     $cart->update(['session_id' => Session::getId()]);
//                     Log::info('Updated cart session ID', [
//                         'cart_id' => $cart->id,
//                         'new_session_id' => Session::getId()
//                     ]);
//                 }

//                 return $cart;
//             }

//             // Create new cart if none exists
//             Log::info('No existing cart found, creating new one', [
//                 'session_id' => $sessionId
//             ]);

//             $cart = Cart::create([
//                 'session_id' => $sessionId,
//                 'user_id' => null
//             ]);

//             Log::info('Created new guest cart', [
//                 'cart_id' => $cart->id,
//                 'session_id' => $sessionId
//             ]);

//             return $cart;
//         }
//     }

//     /**
//      * Add item to cart
//      */

//     public function addItem(?User $user, int $productId, float $quantityGrams): CartItem
//     {
//         $product = Product::findOrFail($productId);
//         $unit = $product->unit ?? 'kg';

//         // Determine the price to store
//         $priceToStore = $product->sale_price ?? $product->price;

//         // For pack/piece items, store the price per unit correctly
//         if (in_array($unit, ['piece', 'pack', 'bunch'])) {
//             // quantity_grams actually represents the number of units
//             // price_at_add should be the price per unit
//             // Already using sale_price or price which is per unit
//             $priceToStore = $product->sale_price ?? $product->price;
//         } else {
//             // For weight-based items, price is per kg
//             $priceToStore = $product->sale_price ?? $product->price;
//         }

//         Log::info('Adding item with price', [
//             'product_id' => $productId,
//             'unit' => $unit,
//             'price_to_store' => $priceToStore,
//             'quantity_grams' => $quantityGrams
//         ]);

//         Log::info('=== ADDING ITEM TO CART ===', [
//             'product_id' => $productId,
//             'product_name' => $product->title,
//             'quantity_grams' => $quantityGrams,
//             'product_unit' => $product->unit,
//             'user_id' => $user?->id,
//             'session_id' => Session::getId()
//         ]);

//         // Validate based on unit type
//         $this->validateQuantityByUnit($product, $quantityGrams);

//         // Check stock availability based on unit type
//         $this->checkStockByUnit($product, $quantityGrams);

//         $cart = $this->getOrCreateCart($user);

//         Log::info('Using cart for add item', [
//             'cart_id' => $cart->id,
//             'session_id' => $cart->session_id,
//             'existing_items_count' => $cart->items()->count()
//         ]);

//         return DB::transaction(function () use ($cart, $product, $quantityGrams) {
//             // Check if item already exists in cart
//             $existingItem = CartItem::where('cart_id', $cart->id)
//                 ->where('product_id', $product->id)
//                 ->first();

//             if ($existingItem) {
//                 Log::info('Updating existing cart item', [
//                     'item_id' => $existingItem->id,
//                     'cart_id' => $cart->id,
//                     'old_quantity' => $existingItem->quantity_grams,
//                     'new_quantity' => $existingItem->quantity_grams + $quantityGrams
//                 ]);

//                 // Update existing item quantity
//                 $newQuantity = $existingItem->quantity_grams + $quantityGrams;

//                 // Check stock for total quantity
//                 $this->checkStockByUnit($product, $newQuantity);

//                 $existingItem->update(['quantity_grams' => $newQuantity]);
//                 $existingItem->load('product');

//                 return $existingItem->fresh();
//             }

//             // Create new cart item
//             $price = $product->sale_price ?? $product->price;

//             $cartItem = CartItem::create([
//                 'cart_id' => $cart->id,
//                 'product_id' => $product->id,
//                 'quantity_grams' => $quantityGrams,
//                 'price_at_add' => $price
//             ]);

//             Log::info('Created new cart item', [
//                 'item_id' => $cartItem->id,
//                 'cart_id' => $cart->id,
//                 'product_id' => $product->id
//             ]);

//             // Load the product relationship
//             $cartItem->load('product');

//             // Log all items in cart after addition
//             $allItems = $cart->items()->with('product')->get();
//             Log::info('All items in cart after addition', [
//                 'cart_id' => $cart->id,
//                 'items' => $allItems->map(function($item) {
//                     return [
//                         'item_id' => $item->id,
//                         'product_id' => $item->product_id,
//                         'product_name' => $item->product->title,
//                         'quantity' => $item->quantity_grams,
//                         'unit' => $item->product->unit
//                     ];
//                 })
//             ]);

//             return $cartItem;
//         });
//     }

//     /**
//      * Convert grams to product unit
//      */
//     private function convertToProductUnit($product, float $grams): float
//     {
//         switch ($product->unit) {
//             case 'kg':
//                 return $grams / 1000;
//             case 'g':
//                 return $grams;
//             case 'piece':
//             case 'liter':
//             case 'pack':
//             case 'bunch':
//                 // For these units, you might need a conversion factor
//                 // For example, 1 piece = X grams
//                 $conversionFactor = $product->grams_per_unit ?? 1;
//                 return $grams / $conversionFactor;
//             default:
//                 return $grams / 1000;
//         }
//     }

//     /**
//      * Check stock availability
//      */
//     private function checkStockAvailability($product, float $quantity): bool
//     {
//         switch ($product->unit) {
//             case 'kg':
//                 return $product->stock >= $quantity;
//             case 'g':
//                 return ($product->stock * 1000) >= $quantity;
//             case 'piece':
//             case 'liter':
//             case 'pack':
//             case 'bunch':
//                 $conversionFactor = $product->grams_per_unit ?? 1;
//                 $stockInUnits = $product->stock * $conversionFactor;
//                 return $stockInUnits >= $quantity;
//             default:
//                 return $product->stock >= $quantity;
//         }
//     }

//     /**
//      * Get cart with items
//      */
//     public function getCartWithItems(?User $user): Cart
//     {
//         $cart = $this->getOrCreateCart($user);

//         // Load items with products
//         $cart->load('items.product');

//         // If this is a guest cart, ensure session_id matches
//         if (!$user && $cart->session_id !== request()->session()->getId()) {
//             Log::warning('Session mismatch detected, updating cart', [
//                 'cart_id' => $cart->id,
//                 'old_session' => $cart->session_id,
//                 'new_session' => request()->session()->getId()
//             ]);

//             $cart->session_id = request()->session()->getId();
//             $cart->save();
//         }

//         return $cart;
//     }

//     /**
//      * Clear entire cart
//      */
//     public function clearCart(?User $user): void
//     {
//         $cart = $this->getOrCreateCart($user);
//         $cart->items()->delete();
//     }

//     /**
//      * Get cart summary
//      */
//     public function getCartSummary(Cart $cart): array
//     {
//         // Make sure items are loaded
//         if (!$cart->relationLoaded('items')) {
//             $cart->load('items.product');
//         }

//         $items = $cart->items;

//         Log::info('Getting cart summary', ['cart_id' => $cart->id, 'items_count' => $items->count()]);

//         $subtotal = $items->sum(function ($item) {
//             return $item->price_at_add * ($item->quantity_grams / 1000);
//         });

//         $taxRate = 0.14; // 14% VAT
//         $tax = round($subtotal * $taxRate, 2);
//         $total = round($subtotal + $tax, 2);

//         return [
//             'total_items_kg' => round($items->sum('quantity_grams') / 1000, 3),
//             'unique_products' => $items->count(),
//             'subtotal' => round($subtotal, 2),
//             'tax' => $tax,
//             'total' => $total,
//             'shipping' => 0,
//         ];
//     }

//     /**
//      * Merge guest cart with user cart after login
//      */
//     public function mergeGuestCartWithUserCart(User $user, ?Cart $guestCart = null): void
//     {
//         try {
//             Log::info('Starting cart merge process', [
//                 'user_id' => $user->id,
//                 'guest_cart_provided' => !is_null($guestCart)
//             ]);

//             // If guest cart not provided, try to find it from current session
//             if (!$guestCart) {
//                 $sessionId = $this->getGuestSessionId();

//                 // IMPORTANT: Look for guest cart with the session ID
//                 $guestCart = Cart::where('session_id', $sessionId)
//                     ->where('user_id', null)
//                     ->first();

//                 // If not found with session_id, try to find by the actual session ID
//                 if (!$guestCart) {
//                     $currentSessionId = Session::getId();
//                     $guestCart = Cart::where('session_id', $currentSessionId)
//                         ->where('user_id', null)
//                         ->first();
//                 }

//                 Log::info('Looking for guest cart in session', [
//                     'session_id' => $sessionId,
//                     'current_session' => Session::getId(),
//                     'found' => !is_null($guestCart)
//                 ]);
//             }

//             // If no guest cart found or it's empty, nothing to merge
//             if (!$guestCart || $guestCart->items()->count() === 0) {
//                 Log::info('No guest cart to merge', [
//                     'cart_exists' => !is_null($guestCart),
//                     'items_count' => $guestCart ? $guestCart->items()->count() : 0
//                 ]);
//                 return;
//             }

//             // Get or create user cart
//             $userCart = $this->getOrCreateCart($user);

//             Log::info('Found user cart', [
//                 'user_cart_id' => $userCart->id,
//                 'guest_cart_id' => $guestCart->id,
//                 'guest_items_count' => $guestCart->items()->count()
//             ]);

//             // Merge items in a transaction
//             DB::transaction(function () use ($guestCart, $userCart) {
//                 // Load guest cart items with products
//                 $guestCart->load('items.product');

//                 foreach ($guestCart->items as $guestItem) {
//                     // Check if product exists in user cart
//                     $existingItem = CartItem::where('cart_id', $userCart->id)
//                         ->where('product_id', $guestItem->product_id)
//                         ->first();

//                     if ($existingItem) {
//                         // Combine quantities
//                         $newQuantity = $existingItem->quantity_grams + $guestItem->quantity_grams;

//                         // Check stock availability based on unit
//                         $product = $guestItem->product;
//                         $unit = $product->unit ?? 'kg';

//                         try {
//                             $this->checkStockByUnit($product, $newQuantity);
//                             $existingItem->update(['quantity_grams' => $newQuantity]);

//                             Log::info('Updated existing item quantity', [
//                                 'product_id' => $guestItem->product_id,
//                                 'old_quantity' => $existingItem->quantity_grams,
//                                 'new_quantity' => $newQuantity
//                             ]);
//                         } catch (\Exception $e) {
//                             // If stock is insufficient, keep the existing quantity
//                             Log::warning('Stock limit reached for product', [
//                                 'product_id' => $guestItem->product_id,
//                                 'error' => $e->getMessage()
//                             ]);
//                         }

//                         // Delete guest item
//                         $guestItem->delete();
//                     } else {
//                         // Move item to user cart
//                         $guestItem->update([
//                             'cart_id' => $userCart->id
//                         ]);

//                         Log::info('Moved item to user cart', [
//                             'item_id' => $guestItem->id,
//                             'product_id' => $guestItem->product_id,
//                             'new_cart_id' => $userCart->id
//                         ]);
//                     }
//                 }

//                 // Delete the guest cart
//                 $guestCart->delete();

//                 Log::info('Guest cart deleted', [
//                     'guest_cart_id' => $guestCart->id
//                 ]);
//             });

//             // Clear guest cart ID from session
//             $session = Session::getFacadeRoot();
//             if ($session->has('guest_cart_id')) {
//                 $session->forget('guest_cart_id');
//                 $session->save();

//                 Log::info('Cleared guest_cart_id from session');
//             }

//             Log::info('Cart merge completed successfully', [
//                 'user_id' => $user->id,
//                 'user_cart_id' => $userCart->id,
//                 'final_items_count' => $userCart->fresh()->items()->count()
//             ]);

//         } catch (\Exception $e) {
//             Log::error('Failed to merge guest cart with user cart', [
//                 'user_id' => $user->id,
//                 'error' => $e->getMessage(),
//                 'trace' => $e->getTraceAsString()
//             ]);

//             throw new \Exception('فشل في دمج سلة المشتريات: ' . $e->getMessage());
//         }
//     }

//     public function updateQuantity(?User $user, int $itemId, float $quantityGrams): CartItem
//     {
//         $cartItem = CartItem::with('product', 'cart')->findOrFail($itemId);

//         Log::info('Updating quantity - before verification', [
//             'item_id' => $itemId,
//             'cart_id' => $cartItem->cart_id,
//             'cart_session' => $cartItem->cart->session_id,
//             'current_session' => request()->session()->getId(),
//             'user_id' => $user?->id,
//             'cart_user_id' => $cartItem->cart->user_id,
//             'quantity_grams' => $quantityGrams,
//             'product_unit' => $cartItem->product->unit
//         ]);

//         // Verify cart belongs to user or session
//         try {
//             $this->verifyCartOwnership($cartItem->cart, $user);
//         } catch (\Exception $e) {
//             Log::error('Cart ownership verification failed', [
//                 'error' => $e->getMessage(),
//                 'item_id' => $itemId,
//                 'cart_session' => $cartItem->cart->session_id,
//                 'current_session' => request()->session()->getId()
//             ]);

//             // If it's a guest cart with mismatched session, try to recover
//             if (!$user && $cartItem->cart->session_id !== request()->session()->getId()) {
//                 Log::info('Attempting to recover guest cart', [
//                     'old_session' => $cartItem->cart->session_id,
//                     'new_session' => request()->session()->getId()
//                 ]);

//                 // Update the cart with the new session ID
//                 $cartItem->cart->update([
//                     'session_id' => request()->session()->getId()
//                 ]);

//                 Log::info('Cart session updated successfully');
//             } else {
//                 throw $e;
//             }
//         }

//         // Get product unit and validate based on unit type
//         $product = $cartItem->product;
//         $unit = $product->unit ?? 'kg';

//         // Validate quantity based on product unit
//         $this->validateQuantityByUnit($product, $quantityGrams);

//         // Check stock based on product unit
//         $this->checkStockByUnit($product, $quantityGrams);

//         $cartItem->update(['quantity_grams' => $quantityGrams]);

//         return $cartItem->fresh()->load('product');
//     }

//     /**
//      * Validate quantity based on product unit
//      */
//     private function validateQuantityByUnit($product, float $quantityGrams): void
//     {
//         $unit = $product->unit ?? 'kg';

//         switch ($unit) {
//             case 'piece':
//             case 'pack':
//             case 'bunch':
//                 // For piece-based items, quantity_grams represents the number of pieces
//                 // Minimum 1 piece, maximum based on stock
//                 if ($quantityGrams < 1) {
//                     throw new \Exception('الحد الأدنى للكمية هو 1 قطعة');
//                 }
//                 if ($quantityGrams != (int)$quantityGrams) {
//                     throw new \Exception('يجب أن تكون الكمية عدداً صحيحاً');
//                 }
//                 break;

//             case 'kg':
//                 // For kg, quantity_grams is in grams, convert to kg for validation
//                 $quantityKg = $quantityGrams / 1000;
//                 if ($quantityKg < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
//                 }
//                 if ($quantityKg > 50) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
//                 }
//                 break;

//             case 'g':
//                 // For grams
//                 if ($quantityGrams < 100) {
//                     throw new \Exception('الحد الأدنى للكمية هو 100 جرام');
//                 }
//                 if ($quantityGrams > 50000) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
//                 }
//                 break;

//             case 'liter':
//                 // For liters, quantity_grams is in grams (1L = 1000g)
//                 $quantityLiters = $quantityGrams / 1000;
//                 if ($quantityLiters < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 لتر');
//                 }
//                 if ($quantityLiters > 50) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 لتر');
//                 }
//                 break;

//             default:
//                 // Default to kg behavior
//                 $quantityKg = $quantityGrams / 1000;
//                 if ($quantityKg < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
//                 }
//                 break;
//         }
//     }

//     /**
//      * Check stock based on product unit
//      */
//     private function checkStockByUnit($product, float $quantityGrams): void
//     {
//         $unit = $product->unit ?? 'kg';

//         switch ($unit) {
//             case 'piece':
//             case 'pack':
//             case 'bunch':
//                 // For piece-based items, quantity_grams represents number of pieces
//                 $requestedPieces = (int)$quantityGrams;
//                 if ($product->stock < $requestedPieces) {
//                     throw new \Exception("الكمية المطلوبة ($requestedPieces قطعة) غير متوفرة في المخزون. المتوفر: {$product->stock} قطعة");
//                 }
//                 break;

//             case 'kg':
//                 // For kg, stock is in kg, convert requested grams to kg
//                 $requestedKg = $quantityGrams / 1000;
//                 if ($product->stock < $requestedKg) {
//                     throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
//                 }
//                 break;

//             case 'g':
//                 // For grams, stock is in kg, convert to grams
//                 $stockInGrams = $product->stock * 1000;
//                 if ($stockInGrams < $quantityGrams) {
//                     $requestedKg = $quantityGrams / 1000;
//                     throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
//                 }
//                 break;

//             case 'liter':
//                 // For liters, stock is in kg (assuming 1L = 1kg for water)
//                 $stockInLiters = $product->stock;
//                 $requestedLiters = $quantityGrams / 1000;
//                 if ($stockInLiters < $requestedLiters) {
//                     throw new \Exception("الكمية المطلوبة ($requestedLiters لتر) غير متوفرة في المخزون. المتوفر: {$stockInLiters} لتر");
//                 }
//                 break;

//             default:
//                 // Default to kg behavior
//                 $requestedKg = $quantityGrams / 1000;
//                 if ($product->stock < $requestedKg) {
//                     throw new \Exception("الكمية المطلوبة غير متوفرة في المخزون");
//                 }
//                 break;
//         }
//     }

//     /**
//      * Verify cart ownership
//      */
//     private function verifyCartOwnership(Cart $cart, ?User $user): void
//     {
//         $currentSessionId = request()->session()->getId();

//         Log::info('Verifying cart ownership', [
//             'cart_id' => $cart->id,
//             'cart_user_id' => $cart->user_id,
//             'cart_session' => $cart->session_id,
//             'current_session' => $currentSessionId,
//             'user_id' => $user?->id
//         ]);

//         if ($user && $cart->user_id && $cart->user_id !== $user->id) {
//             throw new \Exception('غير مصرح بالوصول إلى هذه السلة');
//         }

//         if (!$user && $cart->session_id && $cart->session_id !== $currentSessionId) {
//             // Don't throw immediately, try to recover in the calling method
//             Log::warning('Session mismatch detected', [
//                 'cart_session' => $cart->session_id,
//                 'current_session' => $currentSessionId
//             ]);

//             // We'll let the calling method handle recovery
//             throw new \Exception('غير مصرح بالوصول إلى هذه السلة');
//         }

//         // If cart has no session_id but is a guest cart, update it
//         if (!$user && !$cart->session_id) {
//             $cart->update(['session_id' => $currentSessionId]);
//             Log::info('Updated cart with session_id', [
//                 'cart_id' => $cart->id,
//                 'new_session' => $currentSessionId
//             ]);
//         }
//     }

//     /**
//      * Remove item from cart
//      */
//     public function removeItem(?User $user, int $itemId): CartItem
//     {
//         $cartItem = CartItem::with('cart')->findOrFail($itemId);

//         Log::info('Removing item - before verification', [
//             'item_id' => $itemId,
//             'cart_id' => $cartItem->cart_id,
//             'cart_session' => $cartItem->cart->session_id,
//             'current_session' => request()->session()->getId()
//         ]);

//         // Verify cart belongs to user or session
//         try {
//             $this->verifyCartOwnership($cartItem->cart, $user);
//         } catch (\Exception $e) {
//             // If it's a guest cart with mismatched session, try to recover
//             if (!$user && $cartItem->cart->session_id !== request()->session()->getId()) {
//                 Log::info('Attempting to recover guest cart during removal', [
//                     'old_session' => $cartItem->cart->session_id,
//                     'new_session' => request()->session()->getId()
//                 ]);

//                 // Update the cart with the new session ID
//                 $cartItem->cart->update([
//                     'session_id' => request()->session()->getId()
//                 ]);

//                 Log::info('Cart session updated successfully during removal');
//             } else {
//                 throw $e;
//             }
//         }

//         $cartItem->delete();

//         return $cartItem;
//     }
// }

// class CartService
// {
//     public function getCartWithItems($user = null)
//     {
//         $cart = $this->getOrCreateCart($user);

//         return $cart->load('items.product');
//     }

//     protected function getOrCreateCart($user = null)
//     {
//         // For authenticated users
//         if ($user) {
//             // Check if user already has a cart
//             $cart = Cart::where('user_id', $user->id)->first();

//             if ($cart) {
//                 // User has existing cart
//                 session()->put('cart_id', $cart->id);
//                 session()->save();

//                 return $cart;
//             }

//             // Check if there's a guest cart with this session
//             $guestCart = $this->getGuestCart();

//             if ($guestCart) {
//                 // Convert guest cart to user cart
//                 $guestCart->update([
//                     'user_id' => $user->id,
//                     'session_id' => null,
//                 ]);

//                 session()->put('cart_id', $guestCart->id);
//                 session()->save();

//                 return $guestCart;
//             }

//             // Create new user cart
//             $cart = Cart::create([
//                 'user_id' => $user->id,
//                 'session_id' => null,
//                 'cart_token' => (string) Str::uuid(),
//             ]);

//             session()->put('cart_id', $cart->id);
//             session()->save();

//             return $cart;
//         }

//         // For guest users
//         return $this->getOrCreateGuestCart();
//     }

//     protected function getGuestCart()
//     {
//         // Try by session ID
//         $sessionId = session()->getId();
//         $cart = Cart::where('session_id', $sessionId)
//             ->whereNull('user_id')
//             ->first();

//         if ($cart) {
//             return $cart;
//         }

//         // Try by cart_id from session
//         $cartId = session()->get('cart_id');
//         if ($cartId) {
//             $cart = Cart::where('id', $cartId)
//                 ->whereNull('user_id')
//                 ->first();

//             if ($cart) {
//                 return $cart;
//             }
//         }

//         // Try by cookie
//         $cartId = request()->cookie('cart_id');
//         if ($cartId) {
//             $cart = Cart::where('id', $cartId)
//                 ->whereNull('user_id')
//                 ->first();

//             if ($cart) {
//                 return $cart;
//             }
//         }

//         return null;
//     }

//     protected function getOrCreateGuestCart()
//     {
//         $cart = $this->getGuestCart();

//         if ($cart) {
//             return $cart;
//         }

//         // Create new guest cart
//         $cart = Cart::create([
//             'session_id' => session()->getId(),
//             'user_id' => null,
//             'cart_token' => (string) Str::uuid(),
//             'ip_address' => request()->ip(),
//             'last_activity' => now(),
//         ]);

//         Log::info('Created new guest cart', [
//             'cart_id' => $cart->id,
//             'session_id' => session()->getId(),
//         ]);

//         session()->put('cart_id', $cart->id);
//         session()->save();

//         cookie()->queue('cart_id', $cart->id, 60 * 24 * 30);

//         return $cart;
//     }

//     /**
//      * Merge guest cart with user cart
//      */
//     public function mergeGuestCartWithUserCart($user)
//     {
//         if (! $user) {
//             throw new \Exception('User must be authenticated to merge cart');
//         }

//         try {
//             DB::beginTransaction();

//             // Get guest cart
//             $guestCart = $this->getGuestCart();

//             if (! $guestCart) {
//                 Log::info('No guest cart to merge');
//                 DB::commit();

//                 return null;
//             }

//             // Check if guest cart has items
//             if ($guestCart->items->count() === 0) {
//                 Log::info('Guest cart is empty, deleting');
//                 $guestCart->delete();
//                 DB::commit();

//                 return null;
//             }

//             // Get or create user cart
//             $userCart = Cart::firstOrCreate(
//                 ['user_id' => $user->id],
//                 ['session_id' => null, 'cart_token' => (string) Str::uuid()]
//             );

//             Log::info('Merging carts', [
//                 'guest_cart_id' => $guestCart->id,
//                 'user_cart_id' => $userCart->id,
//                 'items_count' => $guestCart->items->count(),
//             ]);

//             // Merge items
//             foreach ($guestCart->items as $guestItem) {
//                 // Check if product already exists in user cart
//                 $existingItem = CartItem::where('cart_id', $userCart->id)
//                     ->where('product_id', $guestItem->product_id)
//                     ->first();

//                 if ($existingItem) {
//                     // Update quantity
//                     $existingItem->update([
//                         'quantity_grams' => $existingItem->quantity_grams + $guestItem->quantity_grams,
//                     ]);

//                     Log::info('Updated existing item', [
//                         'product_id' => $guestItem->product_id,
//                         'new_quantity' => $existingItem->quantity_grams,
//                     ]);
//                 } else {
//                     // Move item to user cart
//                     $guestItem->update([
//                         'cart_id' => $userCart->id,
//                     ]);

//                     Log::info('Moved item to user cart', [
//                         'product_id' => $guestItem->product_id,
//                         'quantity' => $guestItem->quantity_grams,
//                     ]);
//                 }
//             }

//             // Delete guest cart
//             $guestCart->delete();

//             // Update session
//             session()->put('cart_id', $userCart->id);
//             session()->put('user_id', $user->id);
//             session()->save();

//             // Update cookie
//             cookie()->queue('cart_id', $userCart->id, 60 * 24 * 30);

//             DB::commit();

//             Log::info('Cart merged successfully', [
//                 'user_id' => $user->id,
//                 'cart_id' => $userCart->id,
//             ]);

//             return $userCart->load('items.product');

//         } catch (\Exception $e) {
//             DB::rollBack();
//             Log::error('Failed to merge cart', [
//                 'error' => $e->getMessage(),
//                 'user_id' => $user->id,
//             ]);
//             throw $e;
//         }
//     }

//     /**
//      * Add item to cart
//      */
//     public function addItem(?User $user, int $productId, float $quantityGrams): CartItem
//     {
//         $cart = $this->getOrCreateCart($user);
//         $product = Product::findOrFail($productId);
//         $unit = $product->unit ?? 'kg';

//         // Determine the price to store
//         $priceToStore = $product->sale_price ?? $product->price;

//         // For pack/piece items, store the price per unit correctly
//         if (in_array($unit, ['piece', 'pack', 'bunch'])) {
//             // quantity_grams actually represents the number of units
//             // price_at_add should be the price per unit
//             // Already using sale_price or price which is per unit
//             $priceToStore = $product->sale_price ?? $product->price;
//         } else {
//             // For weight-based items, price is per kg
//             $priceToStore = $product->sale_price ?? $product->price;
//         }

//         Log::info('Adding item with price', [
//             'product_id' => $productId,
//             'unit' => $unit,
//             'price_to_store' => $priceToStore,
//             'quantity_grams' => $quantityGrams,
//         ]);

//         Log::info('=== ADDING ITEM TO CART ===', [
//             'product_id' => $productId,
//             'product_name' => $product->title,
//             'quantity_grams' => $quantityGrams,
//             'product_unit' => $product->unit,
//             'user_id' => $user?->id,
//             'session_id' => Session::getId(),
//         ]);

//         // Validate based on unit type
//         $this->validateQuantityByUnit($product, $quantityGrams);

//         // Check stock availability based on unit type
//         $this->checkStockByUnit($product, $quantityGrams);

//         $cart = $this->getOrCreateCart($user);

//         Log::info('Using cart for add item', [
//             'cart_id' => $cart->id,
//             'session_id' => $cart->session_id,
//             'existing_items_count' => $cart->items()->count(),
//         ]);

//         return DB::transaction(function () use ($cart, $product, $quantityGrams) {
//             // Check if item already exists in cart
//             $existingItem = CartItem::where('cart_id', $cart->id)
//                 ->where('product_id', $product->id)
//                 ->first();

//             if ($existingItem) {
//                 Log::info('Updating existing cart item', [
//                     'item_id' => $existingItem->id,
//                     'cart_id' => $cart->id,
//                     'old_quantity' => $existingItem->quantity_grams,
//                     'new_quantity' => $existingItem->quantity_grams + $quantityGrams,
//                 ]);

//                 // Update existing item quantity
//                 $newQuantity = $existingItem->quantity_grams + $quantityGrams;

//                 // Check stock for total quantity
//                 $this->checkStockByUnit($product, $newQuantity);

//                 $existingItem->update(['quantity_grams' => $newQuantity]);
//                 $existingItem->load('product');

//                 return $existingItem->fresh();
//             }

//             // Create new cart item
//             $price = $product->sale_price ?? $product->price;

//             $cartItem = CartItem::create([
//                 'cart_id' => $cart->id,
//                 'product_id' => $product->id,
//                 'quantity_grams' => $quantityGrams,
//                 'price_at_add' => $price,
//             ]);

//             Log::info('Created new cart item', [
//                 'item_id' => $cartItem->id,
//                 'cart_id' => $cart->id,
//                 'product_id' => $product->id,
//             ]);

//             // Load the product relationship
//             $cartItem->load('product');

//             // Log all items in cart after addition
//             $allItems = $cart->items()->with('product')->get();
//             Log::info('All items in cart after addition', [
//                 'cart_id' => $cart->id,
//                 'items' => $allItems->map(function ($item) {
//                     return [
//                         'item_id' => $item->id,
//                         'product_id' => $item->product_id,
//                         'product_name' => $item->product->title,
//                         'quantity' => $item->quantity_grams,
//                         'unit' => $item->product->unit,
//                     ];
//                 }),
//             ]);

//             return $cartItem;
//         });
//     }

//     /**
//      * Convert grams to product unit
//      */
//     private function convertToProductUnit($product, float $grams): float
//     {
//         switch ($product->unit) {
//             case 'kg':
//                 return $grams / 1000;
//             case 'g':
//                 return $grams;
//             case 'piece':
//             case 'liter':
//             case 'pack':
//             case 'bunch':
//                 // For these units, you might need a conversion factor
//                 // For example, 1 piece = X grams
//                 $conversionFactor = $product->grams_per_unit ?? 1;

//                 return $grams / $conversionFactor;
//             default:
//                 return $grams / 1000;
//         }
//     }

//     /**
//      * Check stock availability
//      */
//     private function checkStockAvailability($product, float $quantity): bool
//     {
//         switch ($product->unit) {
//             case 'kg':
//                 return $product->stock >= $quantity;
//             case 'g':
//                 return ($product->stock * 1000) >= $quantity;
//             case 'piece':
//             case 'liter':
//             case 'pack':
//             case 'bunch':
//                 $conversionFactor = $product->grams_per_unit ?? 1;
//                 $stockInUnits = $product->stock * $conversionFactor;

//                 return $stockInUnits >= $quantity;
//             default:
//                 return $product->stock >= $quantity;
//         }
//     }

//     /**
//      * Get cart with items
//      */
//     // public function getCartWithItems(?User $user): Cart
//     // {
//     //     $cart = $this->getOrCreateCart($user);

//     //     // Load items with products
//     //     $cart->load('items.product');

//     //     // If this is a guest cart, ensure session_id matches
//     //     if (!$user && $cart->session_id !== request()->session()->getId()) {
//     //         Log::warning('Session mismatch detected, updating cart', [
//     //             'cart_id' => $cart->id,
//     //             'old_session' => $cart->session_id,
//     //             'new_session' => request()->session()->getId()
//     //         ]);

//     //         $cart->session_id = request()->session()->getId();
//     //         $cart->save();
//     //     }

//     //     return $cart;
//     // }

//     /**
//      * Get cart summary
//      */
//     public function getCartSummary(Cart $cart): array
//     {
//         // Make sure items are loaded
//         if (! $cart->relationLoaded('items')) {
//             $cart->load('items.product');
//         }

//         $items = $cart->items;

//         Log::info('Getting cart summary', ['cart_id' => $cart->id, 'items_count' => $items->count()]);

//         $subtotal = $items->sum(function ($item) {
//             return $item->price_at_add * ($item->quantity_grams / 1000);
//         });

//         $taxRate = 0.14; // 14% VAT
//         $tax = round($subtotal * $taxRate, 2);
//         $total = round($subtotal + $tax, 2);

//         return [
//             'total_items_kg' => round($items->sum('quantity_grams') / 1000, 3),
//             'unique_products' => $items->count(),
//             'subtotal' => round($subtotal, 2),
//             'tax' => $tax,
//             'total' => $total,
//             'shipping' => 0,
//         ];
//     }

//     /**
//      * Update item quantity
//      */
//     // public function updateQuantity(?User $user, int $itemId, float $quantityGrams): CartItem
//     // {
//     //     $cartItem = CartItem::with('product', 'cart')->findOrFail($itemId);

//     //     Log::info('Updating quantity - before verification', [
//     //         'item_id' => $itemId,
//     //         'cart_id' => $cartItem->cart_id,
//     //         'cart_session' => $cartItem->cart->session_id,
//     //         'current_session' => request()->session()->getId(),
//     //         'user_id' => $user?->id,
//     //         'cart_user_id' => $cartItem->cart->user_id,
//     //         'quantity_grams' => $quantityGrams,
//     //         'product_unit' => $cartItem->product->unit
//     //     ]);

//     //     // Verify cart belongs to user or session
//     //     try {
//     //         $this->verifyCartOwnership($cartItem->cart, $user);
//     //     } catch (\Exception $e) {
//     //         Log::error('Cart ownership verification failed', [
//     //             'error' => $e->getMessage(),
//     //             'item_id' => $itemId,
//     //             'cart_session' => $cartItem->cart->session_id,
//     //             'current_session' => request()->session()->getId()
//     //         ]);

//     //         // If it's a guest cart with mismatched session, try to recover
//     //         if (!$user && $cartItem->cart->session_id !== request()->session()->getId()) {
//     //             Log::info('Attempting to recover guest cart', [
//     //                 'old_session' => $cartItem->cart->session_id,
//     //                 'new_session' => request()->session()->getId()
//     //             ]);

//     //             // Update the cart with the new session ID
//     //             $cartItem->cart->update([
//     //                 'session_id' => request()->session()->getId()
//     //             ]);

//     //             Log::info('Cart session updated successfully');
//     //         } else {
//     //             throw $e;
//     //         }
//     //     }

//     //     // Get product unit and validate based on unit type
//     //     $product = $cartItem->product;
//     //     $unit = $product->unit ?? 'kg';

//     //     // Validate quantity based on product unit
//     //     $this->validateQuantityByUnit($product, $quantityGrams);

//     //     // Check stock based on product unit
//     //     $this->checkStockByUnit($product, $quantityGrams);

//     //     $cartItem->update(['quantity_grams' => $quantityGrams]);

//     //     return $cartItem->fresh()->load('product');
//     // }

//     public function updateQuantity($user, $itemId, $quantityGrams)
//     {
//         $cart = $this->getOrCreateCart($user);

//         $cartItem = CartItem::where('cart_id', $cart->id)
//             ->where('id', $itemId)
//             ->firstOrFail();

//         $product = Product::findOrFail($cartItem->product_id);

//         // Get product unit and validate based on unit type
//         $unit = $product->unit ?? 'kg';

//         // Validate quantity based on product unit
//         $this->validateQuantityByUnit($product, $quantityGrams);

//         // Check stock based on product unit
//         $this->checkStockByUnit($product, $quantityGrams);

//         $cartItem->update(['quantity_grams' => $quantityGrams]);

//         return $cartItem;
//     }

//     /**
//      * Validate quantity based on product unit
//      */
//     private function validateQuantityByUnit($product, float $quantityGrams): void
//     {
//         $unit = $product->unit ?? 'kg';

//         switch ($unit) {
//             case 'piece':
//             case 'pack':
//             case 'bunch':
//                 // For piece-based items, quantity_grams represents the number of pieces
//                 // Minimum 1 piece, maximum based on stock
//                 if ($quantityGrams < 1) {
//                     throw new \Exception('الحد الأدنى للكمية هو 1 قطعة');
//                 }
//                 if ($quantityGrams != (int) $quantityGrams) {
//                     throw new \Exception('يجب أن تكون الكمية عدداً صحيحاً');
//                 }
//                 break;

//             case 'kg':
//                 // For kg, quantity_grams is in grams, convert to kg for validation
//                 $quantityKg = $quantityGrams / 1000;
//                 if ($quantityKg < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
//                 }
//                 if ($quantityKg > 50) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
//                 }
//                 break;

//             case 'g':
//                 // For grams
//                 if ($quantityGrams < 100) {
//                     throw new \Exception('الحد الأدنى للكمية هو 100 جرام');
//                 }
//                 if ($quantityGrams > 50000) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
//                 }
//                 break;

//             case 'liter':
//                 // For liters, quantity_grams is in grams (1L = 1000g)
//                 $quantityLiters = $quantityGrams / 1000;
//                 if ($quantityLiters < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 لتر');
//                 }
//                 if ($quantityLiters > 50) {
//                     throw new \Exception('الحد الأقصى للكمية هو 50 لتر');
//                 }
//                 break;

//             default:
//                 // Default to kg behavior
//                 $quantityKg = $quantityGrams / 1000;
//                 if ($quantityKg < 0.5) {
//                     throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
//                 }
//                 break;
//         }
//     }

//     /**
//      * Check stock based on product unit
//      */
//     private function checkStockByUnit($product, float $quantityGrams): void
//     {
//         $unit = $product->unit ?? 'kg';

//         switch ($unit) {
//             case 'piece':
//             case 'pack':
//             case 'bunch':
//                 // For piece-based items, quantity_grams represents number of pieces
//                 $requestedPieces = (int) $quantityGrams;
//                 if ($product->stock < $requestedPieces) {
//                     throw new \Exception("الكمية المطلوبة ($requestedPieces قطعة) غير متوفرة في المخزون. المتوفر: {$product->stock} قطعة");
//                 }
//                 break;

//             case 'kg':
//                 // For kg, stock is in kg, convert requested grams to kg
//                 $requestedKg = $quantityGrams / 1000;
//                 if ($product->stock < $requestedKg) {
//                     throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
//                 }
//                 break;

//             case 'g':
//                 // For grams, stock is in kg, convert to grams
//                 $stockInGrams = $product->stock * 1000;
//                 if ($stockInGrams < $quantityGrams) {
//                     $requestedKg = $quantityGrams / 1000;
//                     throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
//                 }
//                 break;

//             case 'liter':
//                 // For liters, stock is in kg (assuming 1L = 1kg for water)
//                 $stockInLiters = $product->stock;
//                 $requestedLiters = $quantityGrams / 1000;
//                 if ($stockInLiters < $requestedLiters) {
//                     throw new \Exception("الكمية المطلوبة ($requestedLiters لتر) غير متوفرة في المخزون. المتوفر: {$stockInLiters} لتر");
//                 }
//                 break;

//             default:
//                 // Default to kg behavior
//                 $requestedKg = $quantityGrams / 1000;
//                 if ($product->stock < $requestedKg) {
//                     throw new \Exception('الكمية المطلوبة غير متوفرة في المخزون');
//                 }
//                 break;
//         }
//     }

//     /**
//      * Verify cart ownership
//      */
//     private function verifyCartOwnership(Cart $cart, ?User $user): void
//     {
//         $currentSessionId = request()->session()->getId();

//         Log::info('Verifying cart ownership', [
//             'cart_id' => $cart->id,
//             'cart_user_id' => $cart->user_id,
//             'cart_session' => $cart->session_id,
//             'current_session' => $currentSessionId,
//             'user_id' => $user?->id,
//         ]);

//         if ($user && $cart->user_id && $cart->user_id !== $user->id) {
//             throw new \Exception('غير مصرح بالوصول إلى هذه السلة');
//         }

//         if (! $user && $cart->session_id && $cart->session_id !== $currentSessionId) {
//             // Don't throw immediately, try to recover in the calling method
//             Log::warning('Session mismatch detected', [
//                 'cart_session' => $cart->session_id,
//                 'current_session' => $currentSessionId,
//             ]);

//             // We'll let the calling method handle recovery
//             throw new \Exception('غير مصرح بالوصول إلى هذه السلة');
//         }

//         // If cart has no session_id but is a guest cart, update it
//         if (! $user && ! $cart->session_id) {
//             $cart->update(['session_id' => $currentSessionId]);
//             Log::info('Updated cart with session_id', [
//                 'cart_id' => $cart->id,
//                 'new_session' => $currentSessionId,
//             ]);
//         }
//     }

//     /**
//      * Remove item from cart
//      */
//     public function removeItem(?User $user, int $itemId): CartItem
//     {
//         $cart = $this->getOrCreateCart($user);

//         $cartItem = CartItem::where('cart_id', $cart->id)
//             ->where('id', $itemId)
//             ->firstOrFail();

//         $cartItem->delete();

//         Log::info('Removing item - before verification', [
//             'item_id' => $itemId,
//             'cart_id' => $cartItem->cart_id,
//             'cart_session' => $cartItem->cart->session_id,
//             'current_session' => request()->session()->getId(),
//         ]);

//         $cartItem->delete();

//         return $cartItem;
//     }

//     /**
//      * Clear cart
//      */
//     public function clearCart($user)
//     {
//         $cart = $this->getOrCreateCart($user);

//         $cart->items()->delete();

//         return $cart;
//     }
// }





class CartService
{
   public function getCartWithItems($user = null)
    {
        $cart = $this->getOrCreateCart($user);

        // Load items with products
        $cart->load('items.product');

        // Ensure session_id is correct for guest carts
        if (!$user && $cart->session_id !== Session::getId()) {
            Log::warning('Updating cart session_id', [
                'cart_id' => $cart->id,
                'old_session' => $cart->session_id,
                'new_session' => Session::getId()
            ]);
            $cart->update(['session_id' => Session::getId()]);
            session()->put('cart_id', $cart->id);
            session()->save();
        }

        return $cart;
    }

    protected function getOrCreateCart($user = null)
    {
        // Authenticated user
        if ($user) {
            return $this->getOrCreateUserCart($user);
        }

        // Guest
        return $this->getOrCreateGuestCart();
    }

    protected function getOrCreateUserCart($user)
    {
        $cart = Cart::where('user_id', $user->id)->first();

        if ($cart) {
            // Ensure cart has a token
            if (empty($cart->cart_token)) {
                $cart->update(['cart_token' => (string) Str::uuid()]);
                $cart->refresh();
            }

            session()->put('cart_id', $cart->id);
            session()->save();
            return $cart;
        }

        // Try to convert existing guest cart
        $guestCart = $this->getGuestCart();

        if ($guestCart) {
            $guestCart->update([
                'user_id'    => $user->id,
                'session_id' => null,
            ]);

            // Ensure token exists
            if (empty($guestCart->cart_token)) {
                $guestCart->update(['cart_token' => (string) Str::uuid()]);
                $guestCart->refresh();
            }

            session()->put('cart_id', $guestCart->id);
            session()->save();

            return $guestCart;
        }

        // Create new user cart with token
        $cart = Cart::create([
            'user_id'    => $user->id,
            'session_id' => null,
            'cart_token' => (string) Str::uuid(), // ALWAYS generate token
        ]);

        session()->put('cart_id', $cart->id);
        session()->save();

        return $cart;
    }

    /**
     * Find guest cart - priority: cart_token → session_id → cart_id in session → cookie
     */
    protected function getGuestCart()
    {
        // 1. Best way for API / SPA: cart_token
        $token = request()->header('X-Cart-Token')
            ?? request()->input('cart_token')
            ?? request()->cookie('cart_token');

        if ($token) {
            $cart = Cart::where('cart_token', $token)
                ->whereNull('user_id')
                ->first();

            if ($cart) {
                Log::info('Found guest cart by token', ['cart_id' => $cart->id, 'token' => $token]);
                return $cart;
            }
        }

        // 2. By current session ID
        $sessionId = Session::getId();
        $cart = Cart::where('session_id', $sessionId)
            ->whereNull('user_id')
            ->first();

        if ($cart) {
            Log::info('Found guest cart by session_id', ['cart_id' => $cart->id, 'session_id' => $sessionId]);

            // Ensure cart has a token
            if (empty($cart->cart_token)) {
                $cart->update(['cart_token' => (string) Str::uuid()]);
                $cart->refresh();
            }

            return $cart;
        }

        // 3. By cart_id stored in session
        $cartId = session('cart_id');
        if ($cartId) {
            $cart = Cart::where('id', $cartId)
                ->whereNull('user_id')
                ->first();

            if ($cart) {
                Log::info('Found guest cart by session cart_id', ['cart_id' => $cart->id]);

                // Ensure cart has a token
                if (empty($cart->cart_token)) {
                    $cart->update(['cart_token' => (string) Str::uuid()]);
                    $cart->refresh();
                }

                return $cart;
            }
        }

        // 4. By old cart_id cookie (backward compatibility)
        $cartId = request()->cookie('cart_id');
        if ($cartId) {
            $cart = Cart::where('id', $cartId)
                ->whereNull('user_id')
                ->first();

            if ($cart) {
                Log::info('Found guest cart by cookie cart_id', ['cart_id' => $cart->id]);

                // Ensure cart has a token
                if (empty($cart->cart_token)) {
                    $cart->update(['cart_token' => (string) Str::uuid()]);
                    $cart->refresh();
                }

                return $cart;
            }
        }

        Log::info('No guest cart found', ['session_id' => Session::getId()]);
        return null;
    }

    protected function getOrCreateGuestCart()
    {
        $cart = $this->getGuestCart();

        if ($cart) {
            // Keep session & cookie in sync
            session()->put('cart_id', $cart->id);
            session()->save();

            // Ensure token exists and set cookies
            $token = $cart->cart_token ?? (string) Str::uuid();
            if (empty($cart->cart_token)) {
                $cart->update(['cart_token' => $token]);
                $cart->refresh();
            }

            cookie()->queue('cart_token', $token, 60 * 24 * 30);
            cookie()->queue('cart_id', $cart->id, 60 * 24 * 30);

            Log::info('Using existing guest cart', [
                'cart_id' => $cart->id,
                'cart_token' => $token
            ]);

            return $cart;
        }

        // Create new guest cart with token
        $token = (string) Str::uuid();

        $cart = Cart::create([
            'session_id'    => Session::getId(),
            'user_id'       => null,
            'cart_token'    => $token, // ALWAYS generate token
            'ip_address'    => request()->ip(),
            'last_activity' => now(),
        ]);

        Log::info('Created new guest cart', [
            'cart_id'    => $cart->id,
            'cart_token' => $cart->cart_token,
            'session_id' => Session::getId(),
        ]);

        session()->put('cart_id', $cart->id);
        session()->save();

        // Important: send the token to the frontend via cookie AND header
        cookie()->queue('cart_token', $token, 60 * 24 * 30); // 30 days
        cookie()->queue('cart_id', $cart->id, 60 * 24 * 30);

        return $cart;
    }

    /**
     * Merge guest cart into user cart (call this after login)
     */
    public function mergeGuestCartWithUserCart($user)
    {
        if (!$user) {
            throw new \Exception('User must be authenticated to merge cart');
        }

        try {
            DB::beginTransaction();

            $guestCart = $this->getGuestCart();

            if (!$guestCart) {
                Log::info('No guest cart to merge');
                DB::commit();
                return null;
            }

            // Load items
            $guestCart->load('items');

            if ($guestCart->items->isEmpty()) {
                Log::info('Guest cart is empty, deleting');
                $guestCart->delete();
                DB::commit();
                return null;
            }

            $userCart = Cart::firstOrCreate(
                ['user_id' => $user->id],
                [
                    'session_id' => null,
                    'cart_token' => (string) Str::uuid(),
                ]
            );

            Log::info('Merging carts', [
                'guest_cart_id' => $guestCart->id,
                'user_cart_id'  => $userCart->id,
                'items_count'   => $guestCart->items->count(),
            ]);

            foreach ($guestCart->items as $guestItem) {
                $existingItem = CartItem::where('cart_id', $userCart->id)
                    ->where('product_id', $guestItem->product_id)
                    ->first();

                if ($existingItem) {
                    $existingItem->update([
                        'quantity_grams' => $existingItem->quantity_grams + $guestItem->quantity_grams,
                    ]);
                } else {
                    $guestItem->update(['cart_id' => $userCart->id]);
                }
            }

            $guestCart->delete();

            session()->put('cart_id', $userCart->id);
            session()->save();

            cookie()->queue('cart_token', $userCart->cart_token, 60 * 24 * 30);
            cookie()->queue('cart_id', $userCart->id, 60 * 24 * 30);

            DB::commit();

            Log::info('Cart merged successfully', [
                'user_id' => $user->id,
                'cart_id' => $userCart->id,
            ]);

            return $userCart->load('items.product');

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Failed to merge cart', [
                'error'   => $e->getMessage(),
                'user_id' => $user->id,
            ]);
            throw $e;
        }
    }

    /**
     * Add item to cart
     */
    public function addItem(?User $user, int $productId, float $quantityGrams): CartItem
    {
        $product = Product::findOrFail($productId);

        // Validate + stock check first
        $this->validateQuantityByUnit($product, $quantityGrams);
        $this->checkStockByUnit($product, $quantityGrams);

        $cart = $this->getOrCreateCart($user);

        Log::info('Adding item to cart', [
            'cart_id'        => $cart->id,
            'product_id'     => $productId,
            'quantity_grams' => $quantityGrams,
            'user_id'        => $user?->id,
            'session_id'     => session()->getId(),
        ]);

        return DB::transaction(function () use ($cart, $product, $quantityGrams) {
            $existingItem = CartItem::where('cart_id', $cart->id)
                ->where('product_id', $product->id)
                ->first();

            if ($existingItem) {
                $newQuantity = $existingItem->quantity_grams + $quantityGrams;

                // Re-check stock for the new total
                $this->checkStockByUnit($product, $newQuantity);

                $existingItem->update(['quantity_grams' => $newQuantity]);

                return $existingItem->fresh()->load('product');
            }

            $price = $product->sale_price ?? $product->price;

            $cartItem = CartItem::create([
                'cart_id'         => $cart->id,
                'product_id'      => $product->id,
                'quantity_grams'  => $quantityGrams,
                'price_at_add'    => $price,
            ]);

            return $cartItem->load('product');
        });
    }

    /**
     * Update item quantity
     */
    public function updateQuantity($user, $itemId, $quantityGrams)
    {
        $cart = $this->getOrCreateCart($user);

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('id', $itemId)
            ->firstOrFail();

        $product = Product::findOrFail($cartItem->product_id);

        $this->validateQuantityByUnit($product, $quantityGrams);
        $this->checkStockByUnit($product, $quantityGrams);

        $cartItem->update(['quantity_grams' => $quantityGrams]);

        return $cartItem->fresh()->load('product');
    }

    /**
     * Remove item from cart
     */
    public function removeItem(?User $user, int $itemId): CartItem
    {
        $cart = $this->getOrCreateCart($user);

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('id', $itemId)
            ->firstOrFail();

        // Keep a copy before delete (for return)
        $removedItem = $cartItem->load('product');

        $cartItem->delete();

        Log::info('Item removed from cart', [
            'item_id' => $itemId,
            'cart_id' => $cart->id,
        ]);

        return $removedItem;
    }

    /**
     * Clear all items
     */
    public function clearCart($user)
    {
        $cart = $this->getOrCreateCart($user);
        $cart->items()->delete();

        return $cart;
    }

    /**
     * Get cart summary (used by some places)
     */
    public function getCartSummary(Cart $cart): array
    {
        if (!$cart->relationLoaded('items')) {
            $cart->load('items.product');
        }

        $items = $cart->items;

        $subtotal = $items->sum(function ($item) {
            return $item->price_at_add * ($item->quantity_grams / 1000);
        });

        $taxRate = 0.14;
        $tax     = round($subtotal * $taxRate, 2);
        $total   = round($subtotal + $tax, 2);

        return [
            'total_items_kg'  => round($items->sum('quantity_grams') / 1000, 3),
            'unique_products' => $items->count(),
            'subtotal'        => round($subtotal, 2),
            'tax'             => $tax,
            'total'           => $total,
            'shipping'        => 0,
        ];
    }

    // -------------------------------------------------------
    // Validation & Stock helpers
    // -------------------------------------------------------

    private function validateQuantityByUnit($product, float $quantityGrams): void
    {
        $unit = $product->unit ?? 'kg';

        switch ($unit) {
            case 'piece':
            case 'pack':
            case 'bunch':
                if ($quantityGrams < 1) {
                    throw new \Exception('الحد الأدنى للكمية هو 1 قطعة');
                }
                if ($quantityGrams != (int) $quantityGrams) {
                    throw new \Exception('يجب أن تكون الكمية عدداً صحيحاً');
                }
                break;

            case 'kg':
                $quantityKg = $quantityGrams / 1000;
                if ($quantityKg < 0.5) {
                    throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
                }
                if ($quantityKg > 50) {
                    throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
                }
                break;

            case 'g':
                if ($quantityGrams < 100) {
                    throw new \Exception('الحد الأدنى للكمية هو 100 جرام');
                }
                if ($quantityGrams > 50000) {
                    throw new \Exception('الحد الأقصى للكمية هو 50 كجم');
                }
                break;

            case 'liter':
                $quantityLiters = $quantityGrams / 1000;
                if ($quantityLiters < 0.5) {
                    throw new \Exception('الحد الأدنى للكمية هو 0.5 لتر');
                }
                if ($quantityLiters > 50) {
                    throw new \Exception('الحد الأقصى للكمية هو 50 لتر');
                }
                break;

            default:
                $quantityKg = $quantityGrams / 1000;
                if ($quantityKg < 0.5) {
                    throw new \Exception('الحد الأدنى للكمية هو 0.5 كجم');
                }
                break;
        }
    }

    private function checkStockByUnit($product, float $quantityGrams): void
    {
        $unit = $product->unit ?? 'kg';

        switch ($unit) {
            case 'piece':
            case 'pack':
            case 'bunch':
                $requestedPieces = (int) $quantityGrams;
                if ($product->stock < $requestedPieces) {
                    throw new \Exception("الكمية المطلوبة ($requestedPieces قطعة) غير متوفرة في المخزون. المتوفر: {$product->stock} قطعة");
                }
                break;

            case 'kg':
                $requestedKg = $quantityGrams / 1000;
                if ($product->stock < $requestedKg) {
                    throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
                }
                break;

            case 'g':
                $stockInGrams = $product->stock * 1000;
                if ($stockInGrams < $quantityGrams) {
                    $requestedKg = $quantityGrams / 1000;
                    throw new \Exception("الكمية المطلوبة ($requestedKg كجم) غير متوفرة في المخزون. المتوفر: {$product->stock} كجم");
                }
                break;

            case 'liter':
                $requestedLiters = $quantityGrams / 1000;
                if ($product->stock < $requestedLiters) {
                    throw new \Exception("الكمية المطلوبة ($requestedLiters لتر) غير متوفرة في المخزون. المتوفر: {$product->stock} لتر");
                }
                break;

            default:
                $requestedKg = $quantityGrams / 1000;
                if ($product->stock < $requestedKg) {
                    throw new \Exception('الكمية المطلوبة غير متوفرة في المخزون');
                }
                break;
        }
    }
}
