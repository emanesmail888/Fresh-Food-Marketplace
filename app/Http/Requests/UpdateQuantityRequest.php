<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateQuantityRequest extends FormRequest
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
            'quantity_grams' => 'required|numeric|min:1|max:50000' // min 100g, max 50kg
        ];
    }

     public function messages(): array
    {
        return [
            'quantity_grams.required' => 'الكمية مطلوبة',
            'quantity_grams.numeric' => 'الكمية يجب أن تكون رقماً',
            'quantity_grams.min' => 'الكمية يجب أن تكون على الأقل 100 جرام',
            'quantity_grams.max' => 'الكمية يجب أن لا تتجاوز 50 كيلو جرام'
        ];
    }
}
