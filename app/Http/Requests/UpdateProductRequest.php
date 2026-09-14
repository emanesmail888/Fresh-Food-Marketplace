<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProductRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'title' => 'required|string',
            'title_ar' => 'required|string|max:2000',
            'slug' => 'nullable|string',
            'description' => 'nullable|string',
            'description_ar' => 'nullable|string',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg,webp|max:2048',
            'images' => 'required|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif,svg,webp|max:20000',
            'price' =>'required',
            'sale_price' => 'nullable',
            'stock' => 'required',
            'new_arrival' => 'required|boolean',
            'unit' => 'required|in:kg,g,piece,liter,pack,bunch',
            'category_id' => 'required|exists:categories,id',
        ];
    }
}
