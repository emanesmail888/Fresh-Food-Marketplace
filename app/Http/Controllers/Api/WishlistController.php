<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;
use App\Models\Wishlist;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\ProductResource;


class WishlistController extends Controller
{
    /**
     * Get user's wishlist
     */
    public function index()
    {
        $user = Auth::user();
        $wishlist = $user->wishlistProducts()
            ->with(['category' => function ($query) {
                $query->select('id', 'name', 'name_ar');
            }])
            ->get()
            ->map(function ($product) {
                return [
                    'id' => $product->id,
                    'title' => $product->title,
                    'title_ar' => $product->title_ar,
                    'slug' => $product->slug,
                    'price' => $product->price,
                    'sale_price' => $product->sale_price,
                    'image' => $product->image ,
                    'stock' => $product->stock,
                    'unit' => $product->unit,
                    'rating' => $product->rating,
                    'reviews_count' => $product->reviews_count,
                    'category' => $product->category,
                    'in_wishlist' => true,
                    'rating' => $product->reviews->avg('rating') ?? 0,
                // Format rating to one decimal
                'formatted_rating' => number_format($product->rating, 1)
                ];
            });

        return response()->json([
            'data' => $wishlist,
            'count' => $wishlist->count()
        ]);
    }

    /**
     * Add product to wishlist
     */
    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id'
        ]);

        $user = Auth::user();
        $product = Product::findOrFail($request->product_id);

        // Check if already in wishlist
        if ($user->hasInWishlist($product->id)) {
            return response()->json([
                'message' => 'Product already in wishlist'
            ], 409);
        }

        $wishlist = Wishlist::create([
            'user_id' => $user->id,
            'product_id' => $product->id,
        ]);

        return response()->json([
            'message' => 'Product added to wishlist',
            'data' => $wishlist
        ], 201);
    }


    public function getProductDetails($productId)
{
    $product = Product::with(['category'])
        ->findOrFail($productId);

    return new ProductResource($product);
}

    /**
     * Remove product from wishlist
     */
    public function destroy($productId)
    {
        $user = Auth::user();
        $wishlistItem = Wishlist::where('user_id', $user->id)
            ->where('product_id', $productId)
            ->first();

        if (!$wishlistItem) {
            return response()->json([
                'message' => 'Product not found in wishlist'
            ], 404);
        }

        $wishlistItem->delete();

        return response()->json([
            'message' => 'Product removed from wishlist'
        ]);
    }

    /**
     * Check if product is in wishlist
     */
    public function check($productId)
    {
        $user = Auth::user();
        $inWishlist = $user->hasInWishlist($productId);

        return response()->json([
            'in_wishlist' => $inWishlist
        ]);
    }

    /**
     * Toggle wishlist (add/remove)
     */
    public function toggle(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id'
        ]);

        $user = Auth::user();
        $product = Product::findOrFail($request->product_id);

        if ($user->hasInWishlist($product->id)) {
            // Remove from wishlist
            Wishlist::where('user_id', $user->id)
                ->where('product_id', $product->id)
                ->delete();

            return response()->json([
                'message' => 'Product removed from wishlist',
                'action' => 'removed'
            ]);
        } else {
            // Add to wishlist
            Wishlist::create([
                'user_id' => $user->id,
                'product_id' => $product->id,
            ]);

            return response()->json([
                'message' => 'Product added to wishlist',
                'action' => 'added'
            ], 201);
        }
    }
}
