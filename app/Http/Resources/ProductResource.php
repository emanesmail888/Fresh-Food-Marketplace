<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'title_ar' => $this->title_ar,
            'slug' => $this->slug,
            'category_id' => $this->category_id,
            'description' => $this->description,
            'description_ar' => $this->description_ar,
            'image' => $this->image,
            'images' => $this->images,
            'price' => $this->price,
            'sale_price' => $this->sale_price,
            'stock' => $this->stock,
            'unit' => $this->unit,
            'new_arrival' => $this->new_arrival,
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),

        ];
    }
}
