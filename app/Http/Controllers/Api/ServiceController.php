<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Service;
use App\Http\Requests\StoreServiceRequest;
use App\Http\Requests\UpdateServiceRequest;
use App\Http\Resources\ServiceResource;
use Illuminate\Http\Request;


use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use App\Http\Services\ServicesService;
use App\Functions\Upload;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class ServiceController extends Controller
{

    protected $serviceService;

    public function __construct(ServicesService $serviceService)
    {
        $this->serviceService = $serviceService;
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

        $services = $this->serviceService->getServices($perPage, $search, $sortField, $sortDirection);


        return ServiceResource::collection($services);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreServiceRequest $request): JsonResponse
    {

        $data = $request->validated();

        DB::beginTransaction();

        try {
            // ─── Handle main image
            if ($request->hasFile('image')) {
                $data['image'] = Upload::UploadFile(
                    $request->file('image'),
                    'Services'
                );
            }


            // Create category using service (or directly)
            $service = $this->serviceService->create($data);

            DB::commit();

            // Return 201 Created + resource
            return (new ServiceResource($service))
                ->response()
                ->setStatusCode(201);

        } catch (\Exception $e) {
            DB::rollBack();

            // Optional: delete uploaded files on failure
            if (isset($data['image']) && file_exists(storage_path('app/public/' . $data['image']))) {
                Upload::deleteImage($data['image'], 'Services');
            }

            \Log::error('Service creation failed', [
                'error' => $e->getMessage(),
                'data'  => $data
            ]);

            return response()->json([
                'message' => 'Failed to create service',
                'error'   => $e->getMessage()
            ], 500);
        }

    }

    /**
     * Display the specified resource.
     */
    public function show(Service $service)
    {
        return response()->json([
            'data' => $service
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateServiceRequest $request, Service $service)
    {
        $data = $request->validated();

        // Handle main image replacement
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($service->image) {
                Upload::deleteImage($service->image, 'Services');
            }
            $data['image'] = Upload::UploadFile($request->file('image'), 'Services');
        }


        DB::beginTransaction();

        try {
            // Update using mass assignment (safer with fillable)
            $service->update($data);

            DB::commit();

            return new ServiceResource($service->fresh()); // fresh() to get latest state

        } catch (\Exception $e) {
            DB::rollBack();

            \Log::error('Service update failed', ['error' => $e->getMessage(), 'data' => $data]);

            return response()->json([
                'message' => 'Failed to update service',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Service $service): JsonResponse
    {
         DB::beginTransaction();

        try {
            // 1. Delete main image if exists
            if ($service->image) {
                Upload::deleteImage($service->image, 'Services');
            }

            // 3. Soft delete the service
            $service->delete();

            DB::commit();

            // 204 No Content – standard for successful DELETE
            return response()->json(null, 204);

        } catch (\Exception $e) {
            DB::rollBack();

            \Log::error('Service deletion failed', [
                'service_id' => $service->id,
                'error'      => $e->getMessage()
            ]);

            return response()->json([
                'message' => 'Failed to delete service',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}
