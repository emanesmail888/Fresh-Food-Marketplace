<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use App\Models\Product;
use App\Models\Review;
use App\Http\Requests\ReviewRequest;
use Illuminate\Support\Facades\Storage;
use App\Functions\Upload;

class ReviewController extends Controller
{
    /**
     * Get reviews for a product
     */
    public function index(Product $product, Request $request)
    {
        $perPage = $request->get('per_page', 10);
        $sort = $request->get('sort', 'latest'); // latest, highest, lowest

        $query = $product->reviews()->with('user');

        // Sort
        switch ($sort) {
            case 'highest':
                $query->orderBy('rating', 'desc');
                break;
            case 'lowest':
                $query->orderBy('rating', 'asc');
                break;
            default:
                $query->latest();
                break;
        }

        $reviews = $query->paginate($perPage);

        // Add user's review if authenticated
        $userReview = null;
        if (auth()->check()) {
            $userReview = $product->reviews()
                ->where('user_id', auth()->id())
                ->first();
        }

        return response()->json([
            'reviews' => $reviews,
            'user_review' => $userReview,
            'stats' => [
                'average_rating' => $product->average_rating,
                'total_reviews' => $product->reviews_count,
                'verified_count' => $product->verified_reviews_count,
                'rating_distribution' => $this->getRatingDistribution($product)
            ]
        ]);
    }

    /**
     * Store a new review
     */
    public function store(ReviewRequest $request, Product $product)
    {
        // Check if user already reviewed this product
        $existingReview = Review::where('product_id', $product->id)
            ->where('user_id', auth()->id())
            ->first();

        if ($existingReview) {
            return response()->json([
                'message' => 'You have already reviewed this product'
            ], 422);
        }

        // Check if user purchased this product (optional verification)
        $hasPurchased = $this->userHasPurchasedProduct($product->id);

        $data = $request->validated();
        $data['user_id'] = auth()->id();
        $data['is_verified'] = $hasPurchased;

        // Handle review images
        // if ($request->hasFile('images')) {
        //     $images = [];
        //     foreach ($request->file('images') as $image) {
        //         $path = $image->store('reviews', 'public');
        //         $images[] = $path;
        //     }
        //     $data['images'] = $images;
        // }

        if ($request->hasFile('images')) {
            $imagesPaths = Upload::UploadFiles(
                $request->file('images'),
                'Reviews'
            );
            $data['images'] = json_encode($imagesPaths);
        }

        $review = $product->reviews()->create($data);

        return response()->json([
            'message' => 'Review submitted successfully',
            'review' => $review->load('user')
        ], 201);
    }

    /**
     * Update a review
     */
    public function update(ReviewRequest $request, Review $review)
    {
        // Check if user owns the review
        if ($review->user_id !== auth()->id()) {
            return response()->json([
                'message' => 'You are not authorized to update this review'
            ], 403);
        }

        $data = $request->validated();

        // Handle new images
        // if ($request->hasFile('images')) {
        //     // Delete old images
        //     if ($review->images) {
        //         foreach ($review->images as $oldImage) {
        //             Storage::disk('public')->delete($oldImage);
        //         }
        //     }

        //     $images = [];
        //     foreach ($request->file('images') as $image) {
        //         $path = $image->store('reviews', 'public');
        //         $images[] = $path;
        //     }
        //     $data['images'] = $images;
        // }

        // Handle multiple gallery images replacement
        if ($request->hasFile('images')) {
            // Delete old gallery images if exist
            if ($review->images) {
                $oldImages = json_decode($review->images);
                Upload::deleteImages($oldImages, 'Reviews');
            }
            $newImages = Upload::UploadFiles($request->file('images'), 'Reviews');
            $data['images'] = json_encode($newImages);
        }

        $review->update($data);

        return response()->json([
            'message' => 'Review updated successfully',
            'review' => $review->load('user')
        ]);
    }

    /**
     * Delete a review
     */
    public function destroy(Review $review)
    {
        // Check if user owns the review or is admin
        if ($review->user_id !== auth()->id() && !auth()->user()->is_admin) {
            return response()->json([
                'message' => 'You are not authorized to delete this review'
            ], 403);
        }

        // Delete images

        // if ($review->images) {
        //     foreach ($review->images as $image) {
        //         Storage::disk('public')->delete($image);
        //     }
        // }
        
        if ($review->images) {
            $galleryPaths = json_decode($review->images, true) ?? [];
            if (!empty($galleryPaths)) {
                Upload::deleteImages($galleryPaths, 'Reviews');
            }
        }

        $review->delete();

        return response()->json([
            'message' => 'Review deleted successfully'
        ]);
    }

    /**
     * Check if user purchased the product
     */
    private function userHasPurchasedProduct($productId)
    {
        // Check if user has any completed orders containing this product
        return auth()->user()->orders()
            ->where('status', 'completed')
            ->whereHas('items', function ($query) use ($productId) {
                $query->where('product_id', $productId);
            })
            ->exists();
    }

    /**
     * Get rating distribution
     */
    private function getRatingDistribution($product)
    {
        $distribution = [];
        for ($i = 1; $i <= 5; $i++) {
            $distribution[$i] = $product->reviews()
                ->where('rating', $i)
                ->count();
        }
        return $distribution;
    }

    public function stats(Product $product)
{
    return response()->json([
        'average_rating' => $product->average_rating,
        'total_reviews' => $product->reviews_count,
        'verified_count' => $product->verified_reviews_count,
        'rating_distribution' => $this->getRatingDistribution($product)
    ]);
}
}
