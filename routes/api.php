<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\EmailVerificationController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CheckoutController;
use App\Http\Controllers\Api\StripeWebhookController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\SettingController;
use App\Http\Controllers\Api\ContactController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\WishlistController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::get('/sanctum/csrf-cookie', function () {
    return response()->noContent();
})->withoutMiddleware(['auth:sanctum']);

Route::post('/login', [AuthController::class, 'login'])->name('login');
Route::post('/register', [AuthController::class, 'register'])->name('register');
// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
Route::get('/all_categories', [ProductController::class, 'getAllCategories']);
Route::get('/home', [HomeController::class, 'home']);
Route::get('/shop', [HomeController::class, 'shop']);
Route::get('/about', [HomeController::class, 'about']);
Route::get('/product/{slug}', [ProductController::class, 'product_details']);
Route::get('/products/related', [ProductController::class, 'products_related']);
Route::get('/products/{product}/reviews', [ReviewController::class, 'index']);
Route::get('/{product}/reviews/stats', [ReviewController::class, 'stats']);
Route::get('/category', [HomeController::class, 'getProductsByCategory']);


Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/user', [AuthController::class, 'getUser']);
    Route::apiResource('products', ProductController::class);
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('services', ServiceController::class);

    Route::get('/settings/groups', [SettingController::class, 'getGroups']);
    Route::post('/settings/group/update', [SettingController::class, 'updateGroup']);
    Route::get('/settings', [SettingController::class, 'apiIndex']);
    Route::get('/settings/group/{group}', [SettingController::class, 'getGroup']);
    Route::post('/settings', [SettingController::class, 'store']);
    Route::post('/settings/{id}', [SettingController::class, 'update']);
    Route::put('/settings/{id}', [SettingController::class, 'update']);
    Route::delete('/settings/{id}', [SettingController::class, 'destroy']);
    Route::delete('/settings/group/{group}', [SettingController::class, 'destroyGroup']);


   // Order routes
    Route::get('/orders', [OrderController::class, 'index']);
    Route::get('/orders/recent', [OrderController::class, 'recent']);
    Route::put('/orders/{orderNumber}/status', [OrderController::class, 'updateStatus']);
    Route::get('/orders/{orderNumber}/show', [OrderController::class, 'show']);


    Route::get('/contacts', [ContactController::class, 'index']);
    Route::get('/contacts/stats', [ContactController::class, 'stats']);
    Route::get('/contacts/{id}', [ContactController::class, 'show']);
    Route::put('/contacts/{id}', [ContactController::class, 'update']);
    Route::delete('/contacts/{id}', [ContactController::class, 'destroy']);
    Route::post('/contacts/bulk-delete', [ContactController::class, 'bulkDelete']);

    Route::get('/dashboard', [DashboardController::class, 'stats']);





});
Route::post('/upload/large-file', [SettingController::class, 'uploadLargeFiles']);
Route::post('/contact', [ContactController::class, 'store']);




Route::prefix('cart')->group(function () {
    Route::get('/', [CartController::class, 'index']);
    Route::post('/items', [CartController::class, 'addItem']);
    Route::put('/items/{itemId}', [CartController::class, 'updateQuantity']);
    Route::delete('/items/{itemId}', [CartController::class, 'removeItem']);
    Route::delete('/clear', [CartController::class, 'clear']);
    Route::post('/merge', [CartController::class, 'mergeCart'])->middleware('auth:sanctum');
});


Route::middleware('auth:sanctum')->group(function () {

    Route::get('/email/verification-status', [EmailVerificationController::class, 'status']);
        Route::post('/logout', [AuthController::class, 'logout']);


    // Resend with rate limiting
    Route::post('/email/resend-verification', [EmailVerificationController::class, 'resend'])
        ->middleware('throttle:3,1');   // 3 attempts per minute


    Route::get('/checkout/summary', [CheckoutController::class, 'summary']);
    Route::post('/checkout/process', [CheckoutController::class, 'process']);
    Route::get('/checkout/verify-session/{sessionId}', [CheckoutController::class, 'verifySession']);
    Route::post('/checkout/apply-discount', [CheckoutController::class, 'applyDiscount']);


     // User profile
    Route::get('/user/profile', [UserController::class, 'profile']);
    Route::put('/user/profile', [UserController::class, 'updateProfile']);

    // User orders
    Route::get('/user/orders', [UserController::class, 'orders']);

    // User reviews
    Route::get('/user/reviews', [UserController::class, 'reviews']);



    // User address
    Route::get('/user/address', [UserController::class, 'address']);
    Route::put('/user/address', [UserController::class, 'updateAddress']);

    // Change password
    Route::post('/user/change-password', [UserController::class, 'changePassword']);
    Route::get('/orders/{orderNumber}', [OrderController::class, 'show']);
    Route::post('/orders/{orderNumber}/cancel', [OrderController::class, 'cancel']);
    Route::get('/orders/{orderNumber}/refund-status', [OrderController::class, 'refundStatus']);
    //  Route::post('/orders/{orderNumber}/refund', [OrderController::class, 'refund']);
    // Route::get('/orders/{orderNumber}/refund-status', [OrderController::class, 'refundStatus']);

    Route::post('/orders/{orderNumber}/reorder', [OrderController::class, 'reorder']);
    Route::get('/orders/{orderNumber}/track', [OrderController::class, 'track']);


    Route::post('/products/{product}/reviews', [ReviewController::class, 'store']);
    Route::put('/products/reviews/{review}', [ReviewController::class, 'update']);
    Route::delete('/products/reviews/{review}', [ReviewController::class, 'destroy']);


    // Wishlist routes
    Route::get('/wishlist', [WishlistController::class, 'index']);
    Route::post('/wishlist', [WishlistController::class, 'store']);
    Route::post('/wishlist/toggle', [WishlistController::class, 'toggle']);
    Route::delete('/wishlist/{productId}', [WishlistController::class, 'destroy']);
    Route::get('/wishlist/check/{productId}', [WishlistController::class, 'check']);
    Route::get('/wishlist/product/{productId}', [WishlistController::class, 'getProductDetails']);














//     Route::middleware('auth:sanctum')->group(function () {
//     // Profile routes
//     Route::prefix('user')->group(function () {
//         // Profile
//         Route::get('/profile', [UserController::class, 'profile']);
//         Route::put('/profile', [UserController::class, 'updateProfile']);
//         Route::post('/avatar', [UserController::class, 'uploadAvatar']);

//         // Password
//         Route::post('/change-password', [UserController::class, 'changePassword']);

//         // Orders
//         Route::get('/orders', [UserController::class, 'orders']);
//         Route::get('/orders/{id}', [UserController::class, 'orderDetails']);
//         Route::post('/orders/{id}/cancel', [UserController::class, 'cancelOrder']);
//         Route::get('/orders/{id}/track', [UserController::class, 'trackOrder']);

//         // Reviews
//         Route::get('/reviews', [UserController::class, 'reviews']);

//         // Wishlist
//         Route::get('/wishlist', [UserController::class, 'wishlist']);
//         Route::post('/wishlist', [UserController::class, 'addToWishlist']);
//         Route::delete('/wishlist/{id}', [UserController::class, 'removeFromWishlist']);

//         // Address
//         Route::get('/address', [UserController::class, 'address']);
//         Route::put('/address', [UserController::class, 'updateAddress']);

//         // Statistics
//         Route::get('/stats', [UserController::class, 'stats']);

//         // Notifications
//         Route::get('/notifications', [UserController::class, 'notifications']);
//         Route::put('/notifications/{id}/read', [UserController::class, 'markNotificationRead']);
//         Route::put('/notifications/mark-all-read', [UserController::class, 'markAllNotificationsRead']);

//         // Activity Log
//         Route::get('/activity', [UserController::class, 'activityLog']);

//         // Deactivate account
//         Route::post('/deactivate', [UserController::class, 'deactivate']);
//     });
// });

// // Reactivate account (without auth)
// Route::post('/user/reactivate', [UserController::class, 'reactivate']);


});



// Stripe webhook (no auth)
Route::post('/stripe/webhook', [CheckoutController::class, 'handleWebhook']);


Route::get('/email/verify/{id}/{hash}', [EmailVerificationController::class, 'verify'])
    ->middleware(['signed'])           // important: prevents tampering
    ->name('verification.verify');

//     Route::middleware(['auth:sanctum', 'verified'])->group(function () {
//     Route::get('/user/profile', function (Request $request) {
//         return $request->user();
//     });

//     // Your real protected API endpoints...
//   });
