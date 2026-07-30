<?php
// app/Http/Resources/CartResource.php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\CartItemResource;

class CartResource extends JsonResource
{
    public function toArray($request)
    {
        $items = $this->whenLoaded('items');

        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'session_id' => $this->session_id,
            'items' => CartItemResource::collection($items),
            'summary' => $this->calculateSummary($items),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }

   

 private function calculateSummary($items): array
{
    if (!$items || $items->isEmpty()) {
        return [
            'total_items'         => 0,
            'total_items_display' => '0',
            'unique_products'     => 0,
            'subtotal'            => 0,
            'total'               => 0,
            'tax'                 => 0,
            'total_with_tax'      => 0,
        ];
    }

    $totalItems = 0;      // For pieces or weight (in kg)
    $subtotal = 0;

    foreach ($items as $item) {
        $product = $item->product;
        $unit = $product->unit ?? 'kg';

        $pricePerUnit = $this->getPricePerUnit($item, $product, $unit);
        $quantityValue = $this->getQuantityValue($item, $product, $unit);

        // Calculate item total
        $itemTotal = $pricePerUnit * $quantityValue;
        $subtotal += $itemTotal;
        $tax=$this->calculateTax($subtotal);
        $total=$subtotal + $tax;


        // Count total items
        if (in_array($unit, ['piece', 'pack', 'bunch'])) {
            $totalItems += $quantityValue;           // e.g. 5 pieces
        } else {
            $totalItems += $quantityValue;           // kg or liters
        }
    }

    return [
        'total_items'         => round($totalItems, 2),
        'total_items_display' => $this->formatTotalItemsDisplay($items, $totalItems),
        'unique_products'     => $items->count(),
        'subtotal'            => round($subtotal, 2),
        'total'               => round($subtotal, 2),
        'tax'                 => $this->calculateTax($subtotal),
        'total_with_tax'      => round($total, 2),
    ];
}

  protected function calculateTax($subtotal)
    {
        return $subtotal * 0.14;
    }
    /**
     * Format total items display based on units
     */
    private function formatTotalItemsDisplay($items, float $totalItems): string
    {
        // Check if all items are piece-based
        $hasWeightItems = false;
        $hasPieceItems = false;

        foreach ($items as $item) {
            $unit = $item->product->unit ?? 'kg';
            if (in_array($unit, ['piece', 'pack', 'bunch'])) {
                $hasPieceItems = true;
            } else {
                $hasWeightItems = true;
            }
        }

        if ($hasPieceItems && !$hasWeightItems) {
            // All items are piece-based
            return round($totalItems) . ' ' . ($totalItems == 1 ? 'قطعة' : 'قطع');
        } elseif ($hasWeightItems && !$hasPieceItems) {
            // All items are weight-based
            return number_format($totalItems, 2) . ' كجم';
        } else {
            // Mixed items
            return number_format($totalItems, 2) . ' كجم / قطعة';
        }
    }

      private function getPricePerUnit($cartItem, $product, string $unit): float
    {
        $priceAtAdd = (float) $cartItem->price_at_add;

        // For pack/piece items, price_at_add should already be per unit
        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            // If price seems too low (less than 50) but product price is higher, use product price
            if ($priceAtAdd < 50 && $priceAtAdd > 0) {
                $correctPrice = $product->sale_price ?? $product->price;
                if ($correctPrice >= 50) {
                    return $correctPrice;
                }
            }
            return $priceAtAdd;
        }

        // For weight-based items
        if ($unit === 'kg') {
            return $priceAtAdd;
        }

        if ($unit === 'g') {
            return $priceAtAdd / 1000;
        }

        if ($unit === 'liter') {
            return $priceAtAdd;
        }

        return $priceAtAdd;
    }

    /**
     * Get quantity value in product's natural unit
     */
    private function getQuantityValue($cartItem, $product, string $unit): float
    {
        $quantityInGrams = (float) $cartItem->quantity_grams;

        if (in_array($unit, ['pack', 'piece', 'bunch'])) {
            // For pack/piece items, quantity_grams stores the number of units
            return $quantityInGrams;
        }

        if ($unit === 'kg') {
            return $quantityInGrams / 1000;
        }

        if ($unit === 'g') {
            return $quantityInGrams;
        }

        if ($unit === 'liter') {
            return $quantityInGrams / 1000;
        }

        return $quantityInGrams / 1000;
    }
}
