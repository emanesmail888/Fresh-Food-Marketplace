<?php
namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ProductCollection extends ResourceCollection
{
    public function toArray(Request $request): array
    {
       
        return [
            'data' => ProductResource::collection($this->collection),
            'current_page' => (int) $this->currentPage(),
            'last_page' => (int) $this->lastPage(),
            'per_page' => (int) $this->perPage(),
            'total' => (int) $this->total(),
            'from' => (int) $this->firstItem(),
            'to' => (int) $this->lastItem(),
        ];
    }
}
