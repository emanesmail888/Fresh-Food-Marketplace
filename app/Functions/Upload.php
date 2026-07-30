<?php

namespace App\Functions;

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Intervention\Image\ImageManager;
use Illuminate\Http\UploadedFile;


// class Upload
// {
//     /**
//      * Upload a file (image or video)
//      *
//      * @param UploadedFile $file
//      * @param string $path
//      * @param string|null $type
//      * @return string|null
//      * @throws \Exception
//      */
//     public static function UploadFile($file, $path, $type = null)
//     {
//         // Validate path
//         if (empty($path)) {
//             throw new \ValueError('Path cannot be empty');
//         }

//         // Validate file
//         if (!$file instanceof UploadedFile) {
//             throw new \Exception('Invalid file object');
//         }

//         if (!$file->isValid()) {
//             throw new \Exception('File is not valid: ' . $file->getError());
//         }

//         \Log::info("UploadFile called with path: " . $path . ", type: " . $type);

//         // For videos, skip image processing
//         if ($type === 'video' || str_starts_with($file->getMimeType(), 'video/')) {
//             return self::uploadVideo($file, $path);
//         }

//         // For images
//         return self::uploadImage($file, $path);
//     }

//     /**
//      * Upload a video file
//      */
//     private static function uploadVideo($file, $path)
//     {
//         try {
//             \Log::info("Uploading video to path: " . $path);

//             // Validate video mime types
//             $allowedMimeTypes = ['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/mpeg', 'video/webm'];
//             if (!in_array($file->getMimeType(), $allowedMimeTypes)) {
//                 throw new \Exception('Invalid video format. Allowed: MP4, MOV, AVI, MPEG, WEBM');
//             }

//             // Generate unique filename
//             $extension = $file->getClientOriginalExtension();
//             $name = time() . '_' . rand(1000, 10000) . '.' . $extension;

//             // FIX: Correct path construction
//             $fullPath = $path . '/' . $name;
//             $fullSystemPath = storage_path('app/public/' . $fullPath);
//             $publicUploadPath = public_path('storage/' . $fullPath);

//             \Log::info("Full path: " . $fullPath);
//             \Log::info("Storage path: " . $fullSystemPath);
//             \Log::info("Public path: " . $publicUploadPath);

//             // Ensure directory exists in storage
//             $directory = storage_path('app/public/' . $path);
//             if (!file_exists($directory)) {
//                 mkdir($directory, 0755, true);
//             }

//             // Ensure directory exists in public
//             $publicDirectory = public_path('storage/' . $path);
//             if (!file_exists($publicDirectory)) {
//                 mkdir($publicDirectory, 0755, true);
//             }

//             // Store using Laravel's storage system
//             $storedPath = Storage::disk('public')->putFileAs($path, $file, $name);

//             if (!$storedPath) {
//                 throw new \Exception('Failed to store file');
//             }

//             \Log::info("File stored at: " . $storedPath);

//             // Return the URL path
//             // return  $storedPath;
//              return '/storage/' . $storedPath;

//         } catch (\Exception $e) {
//             \Log::error("Video upload error: " . $e->getMessage());
//             throw $e;
//         }
//     }

//     /**
//      * Upload an image file
//      */
//     private static function uploadImage($file, $path)
//     {
//         try {
//             \Log::info("Uploading image to path: " . $path);

//             $imageManager = new ImageManager();

//             // Validate file MIME type
//             $allowedMimeTypes = ['image/jpeg', 'image/webp', 'image/png', 'image/gif', 'image/svg+xml'];
//             if (!in_array($file->getMimeType(), $allowedMimeTypes)) {
//                 throw new \Exception('Invalid file type. Allowed: JPEG, PNG, WEBP, GIF, SVG');
//             }

//             $name = time() . '_' . rand(1000, 10000) . '.webp';

//             // Process image
//             $imgFile = $imageManager->make($file->getRealPath())
//                 ->resize(800, null, function ($constraint) {
//                     $constraint->aspectRatio();
//                 })
//                 ->encode('webp', 90);



//             // Ensure directory exists
//             $directory = storage_path('app/public/' . $path);
//             if (!file_exists($directory)) {
//                 mkdir($directory, 0755, true);
//             }

//             // Store the file
//             $fullPath = $path . '/' . $name;
//             Storage::disk('public')->put($fullPath, $imgFile);
//              // Also save to public/uploads for compatibility
//             $publicPath = public_path('uploads/' . $path);
//             if (!File::exists($publicPath)) {
//                 File::makeDirectory($publicPath, 0755, true);
//             }
//             $file->move(public_path('uploads/' . $path), $name);

//             \Log::info("Image stored at: " . $fullPath);

//             // return  $fullPath;
//             return '/storage/' . $fullPath;


//         } catch (\Exception $e) {
//             \Log::error("Image upload error: " . $e->getMessage());
//             throw $e;
//         }
//     }



//         /**
//      * Upload multiple files
//      */
//     public static function UploadFiles($files, $path, $type = 'image')
//     {
//         $filesName = [];
//         foreach ($files as $file) {
//             $filesName[] = self::UploadFile($file, $path, $type);
//         }
//         return $filesName;
//     }



//     /**
//      * Delete an image or video file
//      */
//     public static function deleteImage($path)
//     {
//         if (empty($path)) {
//             return;
//         }

//         try {
//             // Remove /storage/ or /uploads/ prefix if exists
//             $cleanPath = str_replace(['/storage/', '/uploads/'], '', $path);

//             // Delete from storage
//             if (Storage::disk('public')->exists($cleanPath)) {
//                 Storage::disk('public')->delete($cleanPath);
//                 \Log::info("File deleted from storage: " . $cleanPath);
//             }

//         } catch (\Throwable $th) {
//             \Log::error("File deletion error: " . $th->getMessage());
//         }
//     }

//     /**
//      * Delete multiple files
//      */
//     public static function deleteImages($paths = [])
//     {
//         foreach ($paths as $path) {
//             self::deleteImage($path);
//         }
//     }
// }



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
            return '/storage/' . $storedPath;

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

            return '/storage/' . $fullPath;

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
