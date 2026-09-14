<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AddItemRequest extends FormRequest
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
            'quantity_grams' => 'required|numeric|min:1|max:50000',
            'product_id' => 'required|exists:products,id'
        ];
    }

    public function messages(): array
    {
        return [
            'product_id.required' => 'معرف المنتج مطلوب',
            'product_id.exists' => 'المنتج غير موجود',
            'quantity_grams.required' => 'الكمية مطلوبة',
            'quantity_grams.min' => 'الكمية يجب أن تكون على الأقل 1',
            'quantity_grams.max' => 'الحد الأقصى للكمية هو 50 كجم'

        ];
    }
}
