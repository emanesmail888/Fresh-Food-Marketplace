<?php
namespace App\Http\Services;

use App\Models\Service;
use Illuminate\Support\Facades\Cache;

class ServicesService
{
   public function getServices($perPage, $search, $sortField, $sortDirection)
    {
        $cacheKey = "services_{$perPage}_{$search}_{$sortField}_{$sortDirection}";

        return Cache::remember($cacheKey, now()->addHours(12), function() use ($perPage, $search, $sortField, $sortDirection) {
            return Service::query()
                ->where('title', 'like', "%{$search}%")
                ->orWhere('title_ar', 'like', "%{$search}%")
                ->orderBy($sortField, $sortDirection)
                ->paginate($perPage);
        });
    }

     
    public function all()
    {
        return Service::cursor();
    }

    public function find($id)
    {
        return Service::findOrFail($id);
    }


    public function create(array $data)
    {
        return Service::create($data);

    }


    public function update(int $id, array $data)
    {
        $service = $this->find($id);
        $service->update($data);
        return $service->fresh();
    }



    public function delete($id)
    {
        $service = $this->find($id);
        return $service->delete();
    }
}
