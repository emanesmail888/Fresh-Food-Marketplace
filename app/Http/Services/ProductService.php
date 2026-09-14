<?php
namespace App\Http\Services;

use App\Models\Product;
use App\Models\Category;
use Illuminate\Support\Str;


class ProductService
{
    public function getProducts($perPage, $search, $sortField, $sortDirection)
    {
        return Product::query()
            ->where('title', 'like', "%{$search}%")
            ->orderBy($sortField, $sortDirection)
            ->paginate($perPage);
    }

    public function getCategories()
    {
        return Category::select('id', 'name','name_ar','image')
            ->orderBy('name')
            ->get();
    }



    public function all()
    {
        return Product::cursor();
    }

    public function find($id)
    {
        return Product::findOrFail($id);
    }


    public function create(array $data)
    {

        // Ensure slug is URL-friendly
        if (isset($data['slug'])) {
            $data['slug'] = Str::slug($data['slug']);
        } else {
            $data['slug'] = Str::slug($data['title']);
        }

        return Product::create($data);

    }


    public function update(int $id, array $data)
    {


        $product = $this->find($id);

         // Ensure slug is URL-friendly if provided
        if (isset($data['slug'])) {
            $data['slug'] = Str::slug($data['slug']);
        }

        // If title is updated but slug is not, update slug from title
        if (isset($data['title']) && !isset($data['slug'])) {
            $data['slug'] = Str::slug($data['title']);
        }
        $product->update($data);
        return $product->fresh();
    }



    public function delete($id)
    {
        $product = $this->find($id);
        return $product->delete();
    }
}
