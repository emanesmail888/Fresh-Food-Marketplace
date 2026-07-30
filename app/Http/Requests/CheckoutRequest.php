<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CheckoutRequest extends FormRequest
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
            'payment_method' => ['required', Rule::in(['stripe', 'cash_on_delivery'])],
            'shipping_method' => ['required', 'string'],
            'shipping_cost' => ['nullable', 'numeric', 'min:0'],

            'shipping_address' => ['required', 'array'],
            'shipping_address.name' => ['required', 'string', 'max:255'],
            'shipping_address.email' => ['required', 'email', 'max:255'],
            'shipping_address.phone' => ['required', 'string', 'max:20'],
            'shipping_address.address_line1' => ['required', 'string', 'max:255'],
            'shipping_address.address_line2' => ['nullable', 'string', 'max:255'],
            'shipping_address.city' => ['required', 'string', 'max:100'],
            'shipping_address.state' => ['nullable', 'string', 'max:100'],
            'shipping_address.postal_code' => ['nullable', 'string', 'max:20'],
            'shipping_address.country' => ['required', 'string', 'max:100'],

            'billing_address' => ['nullable', 'array'],
            'customer_notes' => ['nullable', 'string', 'max:1000'],
            'shipping_notes' => ['nullable', 'string', 'max:500'],
            'discount_code' => ['nullable', 'string', 'max:50'],
        ];
    }

    public function messages()
    {
        return [
            'payment_method.required' => 'Please select a payment method',
            'payment_method.in' => 'Invalid payment method selected',
            'shipping_method.required' => 'Please select a shipping method',
            'shipping_address.required' => 'Shipping address is required',
            'shipping_address.name.required' => 'Recipient name is required',
            'shipping_address.email.required' => 'Email address is required',
            'shipping_address.email.email' => 'Please enter a valid email address',
            'shipping_address.phone.required' => 'Phone number is required',
            'shipping_address.address_line1.required' => 'Street address is required',
            'shipping_address.city.required' => 'City is required',
        ];
    }
}
