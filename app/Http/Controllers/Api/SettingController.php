<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Models\Setting;

use App\Functions\Upload;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Log;

use Illuminate\Support\Facades\Storage;


use Illuminate\Support\Facades\Validator;
use Pion\Laravel\ChunkUpload\Handler\HandlerFactory;
use Pion\Laravel\ChunkUpload\Receiver\FileReceiver;

class SettingController extends Controller
{
    // Get all unique groups
    public function getGroups()
    {
        $groups = Setting::select('group')
            ->distinct()
            ->orderBy('group')
            ->get()
            ->pluck('group');

        return response()->json([
            'success' => true,
            'data' => $groups
        ]);
    }


    public function apiIndex()
    {
        $settings = Setting::orderBy('group')->orderBy('name')->get();
        $groupedSettings = $settings->groupBy('group');

        // Transform data for frontend
        $transformed = [];
        foreach ($groupedSettings as $group => $settings) {
            $transformed[$group] = $settings->map(function($setting) {
                // For file types, generate proper URL
                $value = $setting->value;

                // Handle multi_images - decode JSON array
                if ($setting->type === 'multi_images' && $value) {
                    $decoded = json_decode($value, true);

                    if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                        // Process each image path in the array
                        $value = array_map(function($imagePath) {
                            // Clean the path
                            $cleanPath = ltrim($imagePath, '/');
                            $cleanPath = preg_replace('/^storage\//', '', $cleanPath);
                            return asset('storage/' . $cleanPath);
                        }, $decoded);
                    }

                }


                return [
                    'id' => $setting->id,
                    'name' => $setting->name,
                    'value' => $value,
                    'type' => $setting->type,
                    'raw_value' => $setting->value,
                    'metadata' => $setting->metadata
                ];
            });
        }

        return response()->json([
            'success' => true,
            'data' => $transformed
        ]);
    }


    // Get settings for specific group
    public function getGroup($group)
    {
        $settings = Setting::where('group', $group)->orderBy('name')->get();

        $transformed = $settings->map(function($setting) {
            return [
                'id' => $setting->id,
                'name' => $setting->name,
                'value' => $setting->type === 'text' ? $setting->value : $this->getFileUrl($setting->value),
                'type' => $setting->type,
                'raw_value' => $setting->value,
                'metadata' => $setting->metadata
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $transformed
        ]);
    }



    public function store(Request $request)
    {
        \Log::info("Store method called", [
            'group' => $request->group,
            'name' => $request->name,
            'type' => $request->type,
            'has_file' => $request->hasFile('file'),
            'has_files' => $request->hasFile('files')

        ]);

        $validator = Validator::make($request->all(), [
            'group' => 'required|string|max:255',
            'name'  => 'required|string|max:255',
            'type'  => 'required|in:text,image,video,multi_images',
            'value' => 'nullable|string',
            'file'  => 'nullable|file|max:2048000',
            'files' => 'nullable|array',
            'files.*' => 'image|max:20480'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors(),
                'message' => 'Validation failed'
            ], 422);
        }

        // Check duplicate
        $existing = Setting::where('group', $request->group)
                            ->where('name', $request->name)
                            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => "Setting '{$request->name}' already exists in group '{$request->group}'"
            ], 422);
        }

        $value = $request->value;

        // Handle File Upload (Image or Video)
        if ($request->hasFile('file')) {
            try {
                $file = $request->file('file');

                // Set upload path based on type
                if ($request->type === 'image') {
                    $uploadPath = 'settings/images';
                } elseif ($request->type === 'video') {
                    $uploadPath = 'settings/videos';
                } else {
                    throw new \Exception('Invalid file type');
                }

                \Log::info("Uploading to path: " . $uploadPath);

                $uploadedPath = Upload::UploadFile($file, $uploadPath, $request->type);

                if ($uploadedPath) {
                    $value = $uploadedPath;
                    \Log::info("File uploaded successfully: " . $uploadedPath);
                } else {
                    return response()->json([
                        'success' => false,
                        'message' => 'File upload failed - upload returned null'
                    ], 500);
                }
            } catch (\Exception $e) {
                \Log::error("Upload error: " . $e->getMessage());
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 422);
            }
        }



        // Handle multiple files upload (Multi Images)
            if ($request->type === 'multi_images' && $request->hasFile('files')) {
                try {
                    $files = $request->file('files');
                    $uploadPath = '/settings/multi-images';


                    $uploadedPaths = Upload::UploadFiles($files, $uploadPath);


                    if ($uploadedPaths && count($uploadedPaths) > 0) {
                        $value = json_encode($uploadedPaths);
                        Log::info("Multiple images uploaded successfully: " . json_encode($uploadedPaths));
                    } else {
                        return response()->json([
                            'success' => false,
                            'message' => 'File upload failed - no files uploaded'
                        ], 500);
                    }
                } catch (\Exception $e) {
                    Log::error("Multi upload error: " . $e->getMessage());
                    return response()->json([
                        'success' => false,
                        'message' => $e->getMessage()
                    ], 422);
                }
            }



        $setting = Setting::create([
            'group'     => $request->group,
            'name'      => $request->name,
            'type'      => $request->type,
            'value'     => $value,
            'metadata'  => $request->metadata ?? null,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Setting created successfully',
            'data'    => $setting
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $setting = Setting::findOrFail($id);

        $value = $request->value;

        // Handle single file upload (image/video)
        if ($request->hasFile('file')) {
            try {
                // Delete old file
                if (in_array($setting->type, ['image', 'video']) && $setting->value) {
                    Upload::deleteImage($setting->value);
                }

                $uploadPath = $setting->type === 'image' ? 'settings/images' : 'settings/videos';
                $uploadedFile = Upload::UploadFile($request->file('file'), $uploadPath, $setting->type);

                if ($uploadedFile) {
                    $value = $uploadedFile;
                } else {
                    return response()->json([
                        'success' => false,
                        'message' => 'Failed to upload file'
                    ], 500);
                }
            } catch (\Exception $e) {
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 422);
            }
        }


              if ($setting->type === 'multi_images' && $request->hasFile('files')) {
            try {

             // Delete the old images if it exists
            $decoding_images_path=json_decode($setting->value);
            $uploadPath = 'settings/multi-images';

            Upload::deleteImages($decoding_images_path, $uploadPath);

             // Upload the new images
            $imagesPaths = Upload::UploadFiles($request->file('files'), $uploadPath);
            $value  = json_encode($imagesPaths);
            }

             catch (\Exception $e) {
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 422);


            }
            }else{
             // Keep the old image if no new image is uploaded
            $value = $setting->value;

        }

        // Handle multiple files upload for multi_images (adding new images)
        if ($setting->type === 'multi_images' && $request->hasFile('files')) {
            try {
                $files = $request->file('files');
                $uploadPath = 'settings/multi-images';

                $decoding_images_path=json_decode($setting->value);
               $uploadPath = 'settings/multi-images';

               Upload::deleteImages($decoding_images_path, $uploadPath);

             // Upload the new images
                $imagesPaths = Upload::UploadFiles($request->file('files'), $uploadPath);
                $value  = json_encode($imagesPaths);


            } catch (\Exception $e) {
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 422);
            }
        }

        // Handle multi_images value update (for removing images or updating the entire array)
        if ($setting->type === 'multi_images' && $request->value && !$request->hasFile('files') && !$request->hasFile('file')) {
            $decoded = json_decode($request->value, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                // Get old images that are being removed
                $oldImages = json_decode($setting->value, true) ?: [];
                $removedImages = array_diff($oldImages, $decoded);

                // Delete removed images from storage
                foreach ($removedImages as $removedImage) {
                    Upload::deleteImage($removedImage);
                    Log::info("Deleted removed image: " . $removedImage);
                }

                $value = $request->value;
            } else {
                $value = json_encode([$request->value]);
            }
        }

        $setting->update([
            'value' => $value,
            'metadata' => $request->metadata ?? $setting->metadata
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Setting updated successfully',
            'data' => $setting
        ]);
    }




    public function updateGroup(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'group' => 'required|string',
            'settings' => 'required|array'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $updatedSettings = [];

        foreach ($request->settings as $settingName => $settingData) {
            $setting = Setting::where('group', $request->group)
                ->where('name', $settingName)
                ->first();

            if ($setting) {
                $value = $settingData['value'] ?? $setting->value;


                // Handle multi_images cleanup
                if ($setting->type === 'multi_images' && isset($settingData['value'])) {
                    $images = json_decode($settingData['value'], true);
                    if (is_array($images)) {
                        // Clean each image path
                        $cleanedImages = array_map(function($image) {
                            return preg_replace('#^/storage/#', '', $image);
                        }, $images);
                        $value = json_encode($cleanedImages);
                    }
                }

                // Handle single file upload (image/video)
                if (isset($settingData['file']) && $settingData['file'] instanceof \Illuminate\Http\UploadedFile) {
                    // Delete old file
                    if (in_array($setting->type, ['image', 'video']) && $setting->value) {
                        Upload::deleteImage($setting->value);
                    }

                    $uploadPath = $setting->type === 'image' ? 'settings/images' : 'settings/videos';
                    $uploadedFile = Upload::UploadFile($settingData['file'], $uploadPath, $setting->type);

                    if ($uploadedFile) {
                        $value = $uploadedFile;
                    }
                }

                // Handle multi_images
                if ($setting->type === 'multi_images') {
                    $replaceImages = isset($settingData['replace_images']) && $settingData['replace_images'] === 'true';

                    if (isset($settingData['files']) && is_array($settingData['files'])) {
                        $uploadPath = 'settings/multi-images';

                        if ($replaceImages) {
                            // Delete all old images
                            $oldImages = json_decode($setting->value, true) ?: [];
                            foreach ($oldImages as $oldImage) {
                                // Clean path before deleting
                                $cleanOldImage = preg_replace('#^/storage/#', '', $oldImage);
                                Upload::deleteImage($cleanOldImage);
                            }
                            $value = json_encode([]); // Start fresh
                        }

                        // Upload new images
                        $uploadedPaths = [];
                        foreach ($settingData['files'] as $file) {
                            if ($file instanceof \Illuminate\Http\UploadedFile) {
                                $uploadedPath = Upload::UploadFile($file, $uploadPath, 'image');
                                if ($uploadedPath) {
                                    $uploadedPaths[] = $uploadedPath;
                                }
                            }
                        }

                        if ($replaceImages) {
                            $value = json_encode($uploadedPaths);
                        } else {
                            // Append to existing images
                            $existingImages = json_decode($setting->value, true) ?: [];
                            $allImages = array_merge($existingImages, $uploadedPaths);
                            $value = json_encode(array_values($allImages));
                        }
                    }
                    // Handle value update (for removed images)
                    elseif (isset($settingData['value'])) {
                        $newImages = json_decode($settingData['value'], true);
                        $oldImages = json_decode($setting->value, true) ?: [];

                        // Clean paths before comparing
                        $cleanNewImages = array_map(function($img) {
                            return preg_replace('#^/storage/#', '', $img);
                        }, $newImages);

                        $cleanOldImages = array_map(function($img) {
                            return preg_replace('#^/storage/#', '', $img);
                        }, $oldImages);

                        // Find and delete removed images
                        $removedImages = array_diff($cleanOldImages, $cleanNewImages);
                        foreach ($removedImages as $removedImage) {
                            Upload::deleteImage($removedImage);
                        }

                        $value = json_encode($cleanNewImages);
                    }
                }

                $setting->update([
                    'value' => $value,
                    'metadata' => $settingData['metadata'] ?? $setting->metadata
                ]);

                $updatedSettings[] = $setting;
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Group settings updated successfully',
            'data' => $updatedSettings
        ]);
    }

    // Delete setting
    public function destroy($id)
    {
        $setting = Setting::findOrFail($id);

        // Delete file if exists
        if (in_array($setting->type, ['image', 'video']) && $setting->value) {
            Upload::deleteImage($setting->value);
        }

         // Delete all images in multi_images
        if ($setting->type === 'multi_images' && $setting->value) {
            $images = json_decode($setting->value, true) ?: [];
            foreach ($images as $image) {
                Upload::deleteImage($image);
            }
        }

        $setting->delete();

        return response()->json([
            'success' => true,
            'message' => 'Setting deleted successfully'
        ]);
    }

    // Delete entire group
    public function destroyGroup($group)
    {
        $settings = Setting::where('group', $group)->get();

        foreach ($settings as $setting) {
            if (in_array($setting->type, ['image', 'video']) && $setting->value) {
                Upload::deleteImage($setting->value);
            }

             if ($setting->type === 'multi_images' && $setting->value) {
                $images = json_decode($setting->value, true) ?: [];
                foreach ($images as $image) {
                    Upload::deleteImage($image);
                }
            }
        }

        Setting::where('group', $group)->delete();

        return response()->json([
            'success' => true,
            'message' => 'Group deleted successfully'
        ]);
    }

    // Helper method to get file URL
    private function getFileUrl($path)
    {
        if (!$path) {
            return null;
        }

        // If it's already a full URL
        if (filter_var($path, FILTER_VALIDATE_URL)) {
            return $path;
        }

        // Remove /uploads prefix if exists to avoid duplication
        $cleanPath = str_replace('/uploads/', '', $path);

        // Return full URL
        return url('/storage/' . $cleanPath);
    }


    public function uploadLargeFiles(Request $request)
    {
        // Create the file receiver
        $receiver = new FileReceiver('file', $request, HandlerFactory::classFromRequest($request));

        // Check if the file is uploaded
        if ($receiver->isUploaded() === false) {
            return response()->json([
                'success' => false,
                'message' => 'No file uploaded'
            ], 400);
        }

        // Receive the file
        $fileReceived = $receiver->receive(); // This handles chunk assembly automatically

        // Check if the upload is complete
        if ($fileReceived->isFinished()) {
            // Get the final assembled file
            $file = $fileReceived->getFile();

            try {
                // Validate file size (adjust as needed)
                $maxSize = 2 * 1024 * 1024 * 1024; // 2GB
                if ($file->getSize() > $maxSize) {
                    throw new \Exception('File size exceeds maximum allowed size (2GB)');
                }

                // Validate video mime type
                $allowedMimeTypes = ['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/mpeg'];
                if (!in_array($file->getMimeType(), $allowedMimeTypes)) {
                    throw new \Exception('Invalid video format. Please upload MP4, MOV, AVI, or MPEG files.');
                }

                $extension = $file->getClientOriginalExtension();
                $fileName = time() . '_' . uniqid() . '.' . $extension;
                $folder = 'settings/videos';

                // Store the file
                $path = Storage::disk('public')->putFileAs($folder, $file, $fileName);

                // Update setting if ID is provided
                if ($request->has('setting_id')) {
                    $setting = Setting::find($request->setting_id);
                    if ($setting && in_array($setting->type, ['image', 'video'])) {
                        // Delete old file
                        if ($setting->value) {
                            Upload::deleteImage($setting->value);
                        }
                        $setting->update(['value' => '/storage/' . $path]);
                    }
                }

                // Clean up temp file
                if (file_exists($file->getPathname())) {
                    unlink($file->getPathname());
                }

                return response()->json([
                    'success' => true,
                    'completed' => true,
                    'path' => '/storage/' . $path,
                    'filename' => $fileName,
                    'message' => 'File uploaded successfully'
                ]);

            } catch (\Exception $e) {
                \Log::error("Large file upload error: " . $e->getMessage());
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 500);
            }
        }

        // Return progress for chunk upload
        $handler = $fileReceived->handler();
        return response()->json([
            'success' => true,
            'status' => 'uploading',
            'done' => $handler->getPercentageDone(),
            'message' => 'Uploading chunk...'
        ]);
    }

   
}
