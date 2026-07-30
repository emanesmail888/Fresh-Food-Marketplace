<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;
use App\Models\Category;
use App\Models\Setting;
use App\Models\Service;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\ProductCollection;
use Illuminate\Support\Facades\Cache;


class HomeController extends Controller
{
    public function home(Request $request): JsonResponse
    {

      $products = Cache::remember('random_products_kg_g', 600, function () {  // Cache for 5 minutes

        return Product::select([
        'id','slug', 'title', 'title_ar', 'price', 'sale_price',
        'image', 'unit', 'stock', 'category_id'
        ])->whereIn('unit', ['kg', 'g'])
        ->with(['category:id,name,name_ar', 'reviews'])
        // ->withAvg('reviews', 'rating')

        ->withCount([
            'reviews as reviews_count',
            'reviews as verified_reviews_count' => function($query) {
                $query->where('is_verified', true);
            }
        ])
        ->inRandomOrder()
        // ->offset($randomOffset)
        ->limit(10)
        ->get()
            ->map(function ($product) {
            // // Calculate average rating
            $product->rating = $product->reviews->avg('rating') ?? 0;
            // // Format rating to one decimal
            $product->formatted_rating = number_format($product->rating, 1);

            return $product;
        });
        });
      $seeds_products = Cache::remember('home_seed_products', now()->addHours(6), function () {
        return Product::select([
            'id','slug','title','title_ar', 'price', 'sale_price',
            'image', 'unit', 'stock', 'category_id'
        ])
        ->whereHas('category', function ($query) {
            $query->where('name', 'seeds')
                  ->orWhere('name_ar', 'بذور');
        })
        ->whereNull('deleted_at')
        ->with(['category:id,name,name_ar'])
        ->latest('id')
        ->limit(10)
        ->get();

      });


      $green_vegetables_products = Cache::remember('home_green_vegetables_products', now()->addHours(6), function () {
        return Product::select([
            'id','slug', 'title','title_ar', 'price', 'sale_price',
            'image', 'unit', 'stock', 'category_id'
        ])
        ->whereHas('category', function ($query) {
            $query->where('name', 'Leafy vegetables')
                  ->orWhere('name_ar', 'الخضروات الورقية');
        })
        ->whereNull('deleted_at')
        ->with(['category:id,name,name_ar'])
        ->latest('id')
        ->limit(6)
        ->get();

      });


        $services = Cache::remember('services', now()->addHours(12), fn () => Service::get(['id', 'title', 'title_ar','description','description_ar','image']));
        $categories =Cache::remember('categories', now()->addHours(12), fn () => Category::get(['id','name', 'name_ar','image']));


        $homeSettings = Cache::remember('home_settings', now()->addHours(12), fn () => Setting::where('group', 'home_setting')->get()->pluck('value', 'name'));
        $footerSettings = Cache::remember('footer_settings', now()->addHours(12), fn () => Setting::where('group', 'footer_settings')->get()->pluck('value', 'name'));


        if ($products->isEmpty()) {
            return response()->json(['message' => 'No products found'], 404);
        }

        return response()->json([
        'products' => $products,
        'seeds_products' => $seeds_products,
        'green_vegetables_products' => $green_vegetables_products,
        'categories' => $categories,
        'home_settings' => $homeSettings,
        'footer_settings' => $footerSettings,
        'services'=>$services
        ]);

    }


     private function getSeedsProducts()
    {
        static $seedCategoryIds = null;

        if ($seedCategoryIds === null) {
            $seedCategoryIds = Category::where('name', 'seeds')
                ->orWhere('name_ar', 'بذور')
                ->pluck('id')
                ->toArray();
        }

        return Product::select([
            'id', 'title', 'title_ar', 'price', 'sale_price',
            'image', 'unit', 'stock', 'category_id'
        ])
        ->whereIn('category_id', $seedCategoryIds)
        ->whereNull('deleted_at')
        ->with(['category:id,name,name_ar'])
        ->latest('id')
        ->limit(10)
        ->get();
    }


    public function shop(Request $request)
    {
        $perPage = $request->input('per_page', 12);
        $search = $request->input('search', '');
        $sortField = $request->input('sort_field', 'created_at');
        $sortDirection = $request->input('sort_direction', 'desc');

        $query = Product::query();

        if ($search) {
            //  $query->whereFullText('title', $search);
            $query->where('title', 'like', "%{$search}%")->orWhere('title_ar', 'like', "%{$search}%");
        }

        if ($sortField === 'price') {
            // Use COALESCE to get the effective price (sale_price if exists, otherwise price)
            $query->orderByRaw("COALESCE(sale_price, price) {$sortDirection}");
        } else {
            $query->orderBy($sortField, $sortDirection);
        }

        $products = $query->paginate($perPage);

        return new ProductCollection($products);
    }


    public function about()
    {

        $aboutSettings = Cache::remember('about_settings', now()->addHours(12), fn () =>
        Setting::where('group', 'about_settings')->get()->pluck('value', 'name'));

            return response()->json([
            'about_settings' => $aboutSettings,
            ]);


    }

    public function getProductsByCategory(Request $request)
    {
        $categoryId = $request->input('category_id');
        $perPage = $request->input('per_page', 20);
        $page = $request->input('page', 1);

        $query = Product::query();

        if ($categoryId) {
            $query->where('category_id', $categoryId);
        }

        $products = $query->paginate($perPage, ['*'], 'page', $page);

        return response()->json($products);
    }


}
