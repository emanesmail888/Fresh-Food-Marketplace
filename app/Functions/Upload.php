<?php

namespace App\Functions;

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Intervention\Image\ImageManager;
use Illuminate\Http\UploadedFile;



class Upload
{
    /**
     * Upload a file (image or video)
     */
    public static function UploadFile($file, $path, $type = null)
    {
        if (empty($path)) {
            throw new \ValueError('Path cannot be empty');
        }

        if (!$file instanceof UploadedFile || !$file->isValid()) {
            throw new \Exception('Invalid file');
        }

        \Log::info("UploadFile called with path: {$path}, type: {$type}");

        if ($type === 'video' || str_starts_with($file->getMimeType(), 'video/')) {
            return self::uploadVideo($file, $path);
        }

        return self::uploadImage($file, $path);
    }

    /**
     * Upload Video
     */
    private static function uploadVideo($file, $path)
    {
        try {
            $extension = $file->getClientOriginalExtension();
            $name = time() . '_' . rand(1000, 9999) . '.' . $extension;
            $fullPath = $path . '/' . $name;

            $storedPath = Storage::disk('public')->putFileAs($path, $file, $name);

            if (!$storedPath) {
                throw new \Exception('Failed to store video');
            }

            \Log::info("Video uploaded: {$storedPath}");
            return 'storage/' . $storedPath;

        } catch (\Exception $e) {
            \Log::error("Video upload error: " . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Upload & Compress Image
     */
    private static function uploadImage($file, $path)
    {
        try {
            \Log::info("Compressing image to path: " . $path);

            $name = time() . '_' . rand(1000, 9999) . '.webp';
            $fullPath = $path . '/' . $name;

            // Create Intervention Image instance
            $image = Image::make($file->getRealPath());

            // Resize (max width 800px, maintain aspect ratio)
            $image->resize(800, null, function ($constraint) {
                $constraint->aspectRatio();
                $constraint->upsize(); // Prevent upscaling small images
            });

            // Convert to WebP with good compression
            $encodedImage = $image->encode('webp', 65); // 82 is good balance (lower = smaller size)

            // Ensure directory exists
            $directory = storage_path('app/public/' . $path);
            if (!File::exists($directory)) {
                File::makeDirectory($directory, 0755, true);
            }

            // Save compressed WebP using Laravel Storage
            Storage::disk('public')->put($fullPath, $encodedImage);

            \Log::info("Image compressed and saved: {$fullPath}");

            // Optional: Also save original for backup (if needed)
            // $file->storeAs($path, 'original_' . $name, 'public');

            return 'storage/' . $fullPath;

        } catch (\Exception $e) {
            \Log::error("Image upload/compression error: " . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Upload Multiple Files
     */
    public static function UploadFiles($files, $path, $type = 'image')
    {
        $filesName = [];
        foreach ($files as $file) {
            $filesName[] = self::UploadFile($file, $path, $type);
        }
        return $filesName;
    }

    /**
     * Delete File
     */
    public static function deleteImage($path)
    {
        if (empty($path)) return;

        try {
            $cleanPath = str_replace(['/storage/', '/uploads/'], '', $path);

            if (Storage::disk('public')->exists($cleanPath)) {
                Storage::disk('public')->delete($cleanPath);
                \Log::info("Deleted: " . $cleanPath);
            }
        } catch (\Throwable $th) {
            \Log::error("Delete error: " . $th->getMessage());
        }
    }

    public static function deleteImages($paths = [])
    {
        foreach ($paths as $path) {
            self::deleteImage($path);
        }
    }
}
