<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Http\Resources\ProductResource;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use App\Http\Services\ProductService;
use App\Functions\Upload;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;




class ProductController extends Controller
{

    protected $productService;

    public function __construct(ProductService $productService)
    {
        $this->productService = $productService;
    }
    /**
     * Display a listing of the resource.
     */

    public function index(Request $request)
    {
        $perPage = $request->input('per_page', 10);
        $search = $request->input('search', '');
        $sortField = $request->input('sort_field', 'created_at');
        $sortDirection = $request->input('sort_direction', 'desc');

        $products = $this->productService->getProducts($perPage, $search, $sortField, $sortDirection);

        return ProductResource::collection($products);
    }


    /**
     * Store a newly created resource in storage.
     */

    public function store(StoreProductRequest $request): JsonResponse
    {
        $data = $request->validated();

        DB::beginTransaction();

        try {
            // ─── Handle main image
            if ($request->hasFile('image')) {
                $data['image'] = Upload::UploadFile(
                    $request->file('image'),
                    'Products'
                );
            }

            // ─── Handle multiple gallery images
            if ($request->hasFile('images')) {
                $imagesPaths = Upload::UploadFiles(
                    $request->file('images'),
                    'Products'
                );
                $data['images'] = json_encode($imagesPaths);
            }

            // Create product using service (or directly)
            $product = $this->productService->create($data);

            DB::commit();

            // Return 201 Created + resource
            return (new ProductResource($product))
                ->response()
                ->setStatusCode(201);

        } catch (\Exception $e) {
            DB::rollBack();

            // Optional: delete uploaded files on failure
            if (isset($data['image']) && file_exists(storage_path('app/public/' . $data['image']))) {
                Upload::deleteImage($data['image'], 'Products');
            }
            if (isset($data['images'])) {
                $paths = json_decode($data['images'], true) ?? [];
                if (!empty($paths)) {
                    Upload::deleteImages($paths, 'Products');
                }
            }

            // Log error in production
            \Log::error('Product creation failed', [
                'error' => $e->getMessage(),
                'data'  => $data
            ]);

            return response()->json([
                'message' => 'Failed to create product',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product)
    {
        $product->load(['category']);           // adds category data

        return response()->json([
            'data' => $product
        ]);
    }

    public function product_details($slug)
    {
        $product = Product::with('category')
            ->where('slug', $slug)
            ->firstOrFail();

        return response()->json($product);
    }


public function products_related(Request $request)
{
    $categoryId = $request->query('category_id');
    $productId  = $request->query('product_id');
    $limit = (int) $request->query('limit', 5);

    Log::info('Related products request', [
        'category_id' => $categoryId,
        'product_id' => $productId,
        'limit' => $limit
    ]);

    if (!$categoryId || !$productId) {
        return response()->json(['message' => 'Missing parameters'], 422);
    }

    $related = Product::where('category_id', $categoryId)
        ->where('id', '!=', $productId)
        ->where('stock', '>', 0)
        ->limit($limit)
        ->get();

    return response()->json($related);
}

    /**
     * Update the specified resource in storage.
     */

    public function update(UpdateProductRequest $request, Product $product)
    {
        $data = $request->validated();

        // Handle main image replacement
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($product->image) {
                Upload::deleteImage($product->image, 'Products');
            }
            $data['image'] = Upload::UploadFile($request->file('image'), 'Products');
        }

        // Handle multiple gallery images replacement
        if ($request->hasFile('images')) {
            // Delete old gallery images if exist
            if ($product->images) {
                $oldImages = json_decode($product->images);
                Upload::deleteImages($oldImages, 'Products');
            }
            $newImages = Upload::UploadFiles($request->file('images'), 'Products');
            $data['images'] = json_encode($newImages);
        }

        DB::beginTransaction();

        try {
            // Update using mass assignment (safer with fillable)
            $product->update($data);

            DB::commit();

            return new ProductResource($product->fresh()); // fresh() to get latest state

        } catch (\Exception $e) {
            DB::rollBack();

            // Log the error in real project
            \Log::error('Product update failed', ['error' => $e->getMessage(), 'data' => $data]);

            return response()->json([
                'message' => 'Failed to update product',
                'error' => $e->getMessage()
            ], 500);
        }
    }


    /**
 * Remove the specified product from storage (API).
 */
    public function destroy(Product $product): JsonResponse
    {
        DB::beginTransaction();

        try {
            // 1. Delete main image if exists
            if ($product->image) {
                Upload::deleteImage($product->image, 'Products');
            }

            // 2. Delete gallery images if exist
            if ($product->images) {
                $galleryPaths = json_decode($product->images, true) ?? [];
                if (!empty($galleryPaths)) {
                    Upload::deleteImages($galleryPaths, 'Products');
                }
            }

            // 3. Soft delete the product
            $product->delete();

            DB::commit();

            // 204 No Content – standard for successful DELETE
            return response()->json(null, 204);

        } catch (\Exception $e) {
            DB::rollBack();

            \Log::error('Product deletion failed', [
                'product_id' => $product->id,
                'error'      => $e->getMessage()
            ]);

            return response()->json([
                'message' => 'Failed to delete product',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    public function getAllCategories()
    {
        $categories =  $this->productService->getCategories();
        return response()->json([
            'data' => $categories
        ]);
    }

}
