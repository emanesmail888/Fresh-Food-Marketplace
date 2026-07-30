<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Http\Requests\StoreCategoryRequest;
use App\Http\Requests\UpdateCategoryRequest;
use App\Http\Resources\CategoryResource;
use Illuminate\Http\Request;


use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use App\Http\Services\CategoryService;
use App\Functions\Upload;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class CategoryController extends Controller
{

    protected $categoryService;

    public function __construct(CategoryService $categoryService)
    {
        $this->categoryService = $categoryService;
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

        $categories = $this->categoryService->getCategories($perPage, $search, $sortField, $sortDirection);

        return CategoryResource::collection($categories);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCategoryRequest $request): JsonResponse
    {

        $data = $request->validated();

        DB::beginTransaction();

        try {
            // ─── Handle main image
            if ($request->hasFile('image')) {
                $data['image'] = Upload::UploadFile(
                    $request->file('image'),
                    'Categories'
                );
            }


            // Create category using service (or directly)
            $category = $this->categoryService->create($data);

            DB::commit();

            // Return 201 Created + resource
            return (new CategoryResource($category))
                ->response()
                ->setStatusCode(201);

        } catch (\Exception $e) {
            DB::rollBack();

            // Optional: delete uploaded files on failure
            if (isset($data['image']) && file_exists(storage_path('app/public/' . $data['image']))) {
                Upload::deleteImage($data['image'], 'Categories');
            }

            \Log::error('Category creation failed', [
                'error' => $e->getMessage(),
                'data'  => $data
            ]);

            return response()->json([
                'message' => 'Failed to create category',
                'error'   => $e->getMessage()
            ], 500);
        }

    }

    /**
     * Display the specified resource.
     */
    public function show(Category $category)
    {
        return response()->json([
            'data' => $category
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCategoryRequest $request, Category $category)
    {
        $data = $request->validated();

        // Handle main image replacement
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($category->image) {
                Upload::deleteImage($category->image, 'Categories');
            }
            $data['image'] = Upload::UploadFile($request->file('image'), 'Categories');
        }


        DB::beginTransaction();

        try {
            // Update using mass assignment (safer with fillable)
            $category->update($data);

            DB::commit();

            return new CategoryResource($category->fresh()); // fresh() to get latest state

        } catch (\Exception $e) {
            DB::rollBack();

            \Log::error('Category update failed', ['error' => $e->getMessage(), 'data' => $data]);

            return response()->json([
                'message' => 'Failed to update category',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Category $category): JsonResponse
    {
         DB::beginTransaction();

        try {
            // 1. Delete main image if exists
            if ($category->image) {
                Upload::deleteImage($category->image, 'Categories');
            }

            // 3. Soft delete the category
            $category->delete();

            DB::commit();

            // 204 No Content – standard for successful DELETE
            return response()->json(null, 204);

        } catch (\Exception $e) {
            DB::rollBack();

            \Log::error('Category deletion failed', [
                'category_id' => $category->id,
                'error'      => $e->getMessage()
            ]);

            return response()->json([
                'message' => 'Failed to delete category',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}
