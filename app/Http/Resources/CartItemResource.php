<?php
// app/Http/Resources/CartItemResource.php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Log;



class CartItemResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $product = $this->product;
        $unit = $product->unit ?? 'kg';

        // Get quantity based on product unit
        $quantityData = $this->getQuantityByUnit($unit);

        // Get price per unit (not per kg for pack items)
        $pricePerUnit = $this->getPricePerUnit($unit);

        // Calculate total price correctly based on unit type
        $totalPrice = $this->calculateTotalPrice($unit, $pricePerUnit);

        return [
            'id' => $this->id,
            'product_id' => $this->product_id,
            'quantity_grams' => (float) $this->quantity_grams,
            'quantity_kg' => round($this->quantity_grams / 1000, 3),
            'quantity_display' => $quantityData['display'],
            'quantity_value' => $quantityData['value'],
            'unit' => $unit,
            'unit_label' => $this->getUnitLabel($unit),
            'price_per_unit' => $pricePerUnit, // Price per piece/pack/kg
            'price_at_add' => (float) $this->price_at_add,
            'total_price' => $totalPrice,
            'product' => [
                'id' => $product->id,
                'title' => $product->title,
                'title_ar' => $product->title_ar,
                'slug' => $product->slug,
                'image' => $product->image,
                'stock' => $product->stock ?? 0,
                'stock_display' => $this->getStockDisplay($product),
                'unit' => $unit,
                'unit_label' => $this->getUnitLabel($unit),
                'price' => $product->sale_price ?? $product->price,
                'original_price' => $product->price,
                'sale_price' => $product->sale_price,
                'grams_per_unit' => $product->grams_per_unit ?? $this->getDefaultGramsPerUnit($unit)
            ],
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at
        ];
    }

    /**
     * Get quantity based on product unit
     */
    private function getQuantityByUnit(string $unit): array
    {
        $quantityInGrams = (float) $this->quantity_grams;

        switch ($unit) {
            case 'piece':
            case 'pack':
            case 'bunch':
                // For piece-based items, quantity_grams represents number of pieces
                $value = (int) $quantityInGrams;
                return [
                    'display' => $value . ' ' . $this->getUnitLabel($unit),
                    'value' => $value
                ];

            case 'kg':
                $value = $quantityInGrams / 1000;
                return [
                    'display' => number_format($value, 2) . ' ' . $this->getUnitLabel($unit),
                    'value' => $value
                ];

            case 'g':
                $value = (int) $quantityInGrams;
                return [
                    'display' => number_format($value) . ' ' . $this->getUnitLabel($unit),
                    'value' => $value
                ];

            case 'liter':
                $value = $quantityInGrams / 1000;
                return [
                    'display' => number_format($value, 2) . ' ' . $this->getUnitLabel($unit),
                    'value' => $value
                ];

            default:
                $value = $quantityInGrams / 1000;
                return [
                    'display' => number_format($value, 2) . ' kg',
                    'value' => $value
                ];
        }
    }

private function getPricePerUnit(string $unit): float
{
    $product = $this->product;
    $priceAtAdd = (float) $this->price_at_add;

    // CRITICAL FIX: For pack/piece items, price should NOT be converted
    if (in_array($unit, ['piece', 'pack', 'bunch'])) {
        // If price seems unusually low (like 23 instead of 230),
        // check if it's stored as per kg
        // $gramsPerUnit = $product->grams_per_unit ?? $this->getDefaultGramsPerUnit($unit);

        return $priceAtAdd;
    }

    switch ($unit) {
        case 'kg':
            return $priceAtAdd;
        case 'g':
            return $priceAtAdd / 1000;
        case 'liter':
            return $priceAtAdd;
        default:
            return $priceAtAdd;
    }
}

    /**
     * Calculate total price based on product unit
     */
    private function calculateTotalPrice(string $unit, float $pricePerUnit): float
    {
        $quantityData = $this->getQuantityByUnit($unit);
        $quantity = $quantityData['value'];

        switch ($unit) {
            case 'piece':
            case 'pack':
            case 'bunch':
                // Total = price per piece * number of pieces
                return round($pricePerUnit * $quantity, 2);

            case 'kg':
                // Total = price per kg * kg quantity
                return round($pricePerUnit * $quantity, 2);

            case 'g':
                // Total = price per g * grams
                $pricePerGram = $pricePerUnit;
                return round($pricePerGram * $quantity, 2);

            case 'liter':
                // Total = price per liter * liters
                return round($pricePerUnit * $quantity, 2);

            default:
                return round($pricePerUnit * $quantity, 2);
        }
    }

    /**
     * Get stock display based on product unit
     */
    private function getStockDisplay($product): string
    {
        $unit = $product->unit ?? 'kg';
        $stock = (float) ($product->stock ?? 0);

        switch ($unit) {
            case 'piece':
            case 'pack':
            case 'bunch':
                return number_format($stock) . ' ' . $this->getUnitLabel($unit);

            case 'kg':
                return number_format($stock, 2) . ' ' . $this->getUnitLabel($unit);

            case 'g':
                return number_format($stock * 1000) . ' ' . $this->getUnitLabel($unit);

            case 'liter':
                return number_format($stock, 2) . ' ' . $this->getUnitLabel($unit);

            default:
                return number_format($stock, 2) . ' kg';
        }
    }

    /**
     * Get unit label in multiple languages
     */
    private function getUnitLabel(string $unit): string
    {
        $labels = [
            'kg' => 'kg',
            'g' => 'g',
            'piece' => 'piece',
            'liter' => 'liter',
            'pack' => 'pack',
            'bunch' => 'bunch'
        ];

        return $labels[$unit] ?? $unit;
    }

    /**
     * Get default grams per unit for non-weight units
     */
    private function getDefaultGramsPerUnit(string $unit): float
    {
        $defaults = [
            'piece' => 250,
            'pack' => 100,  // 1 pack = 100g (adjust as needed)
            'bunch' => 200,
            'liter' => 1000
        ];

        return $defaults[$unit] ?? 1000;
    }
}
