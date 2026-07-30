<?php
namespace App\Http\Services;

use App\Models\Category;

class CategoryService
{
    public function getCategories($perPage, $search, $sortField, $sortDirection)
    {
        return Category::query()
            ->where('name', 'like', "%{$search}%")
            ->orWhere('name_ar', 'like', "%{$search}%")
            ->orderBy($sortField, $sortDirection)
            ->paginate($perPage);
    }


    public function all()
    {
        return Category::cursor();
    }

    public function find($id)
    {
        return Category::findOrFail($id);
    }


    public function create(array $data)
    {
        return Category::create($data);

    }


    public function update(int $id, array $data)
    {
        $category = $this->find($id);
        $category->update($data);
        return $category->fresh();
    }



    public function delete($id)
    {
        $category = $this->find($id);
        return $category->delete();
    }
}
