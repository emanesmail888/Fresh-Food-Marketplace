<template>
    <home-layout>
        <div :dir="currentDirection">
            <!-- Breadcrumb Section -->
            <section class="py-5">
                <div class="container mx-auto px-4">
                    <div class="text-center">
                        <h1 class="text-3xl font-bold text-gray-800">
                            {{ t("shopping_cart") }}
                        </h1>
                        <h4 class="text-sm mt-3 text-gray-600">
                            <router-link to="/" class="text-gray-600 hover:text-green-600 transition-colors">{{
                                t("home") }}</router-link>
                            <span class="text-gray-400 mx-1 text-xs align-middle" aria-hidden="true">›</span>
                            <span class="text-gray-800">{{ t("shopping_cart") }}</span>
                        </h4>
                    </div>
                </div>
            </section>

            <!-- Cart Section -->
            <section class="py-8 bg-gray-50" aria-label="Shopping cart content">
                <div class="container mx-auto px-4">
                    <!-- Loading State -->
                    <div v-if="isLoading" class="text-center py-16" role="status" aria-live="polite">
                        <div
                            class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-green-600 border-t-transparent">
                        </div>
                        <p class="text-xl text-gray-600 mt-4">{{ t("loading") }}</p>
                    </div>

                    <!-- Error State -->
                    <div v-else-if="cartError" class="text-center py-16" role="alert">
                        <p class="text-xl text-red-600 mb-6">{{ cartError }}</p>
                        <button @click="retryFetchCart"
                            class="bg-green-600 hover:bg-green-700 text-white px-8 py-4 rounded-lg transition-colors">
                            {{ t("retry") }}
                        </button>
                    </div>

                    <!-- Empty Cart State -->
                    <div v-else-if="!cartItems.length" class="text-center py-16">
                        <p class="text-xl text-gray-600 mb-6">{{ t("empty_cart") }}</p>
                        <router-link to="/products"
                            class="bg-green-600 hover:bg-green-700 text-white px-8 py-4 rounded-lg transition-colors inline-block">
                            {{ t("go_shopping") }}
                        </router-link>
                    </div>

                    <!-- Cart Items -->
                    <div v-else class="overflow-x-auto">
                        <table class="w-full border-collapse">
                            <thead>
                                <tr class="border-b border-gray-200">
                                    <th scope="col" class="font-bold py-4 text-left rtl:text-right text-gray-700">
                                        {{ t("Product") }}
                                    </th>
                                    <th scope="col" class="font-bold py-4 text-left rtl:text-right text-gray-700">
                                        {{ t("quantity") }}
                                    </th>
                                    <th scope="col" class="font-bold py-4 text-left rtl:text-right text-gray-700">
                                        {{ t("price") }}
                                    </th>
                                    <th scope="col" class="font-bold py-4 text-left rtl:text-right text-gray-700">
                                        {{ t("total") }}
                                    </th>
                                    <th scope="col" class="font-bold py-4 text-left rtl:text-right text-gray-700"
                                        aria-label="Actions"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in cartItems" :key="item.id"
                                    class="border-b border-gray-200 hover:bg-gray-50/50 transition-colors">
                                    <!-- Product Column -->
                                    <td class="py-4">
                                        <div class="flex items-start gap-4">
                                            <!-- Product Image -->
                                            <router-link :to="`/product/${item.product?.id}`" class="shrink-0">
                                                <img v-if="item.product?.image"
                                                    :src="`${storageBase}/${item.product.image}`"
                                                    :alt="item.product.title"
                                                    class="w-20 h-20 object-cover rounded-lg hover:opacity-90 transition-opacity"
                                                    loading="lazy" width="80" height="80" />
                                                <div v-else
                                                    class="w-20 h-20 bg-gray-100 rounded-lg flex items-center justify-center text-gray-400 text-xs">
                                                    {{ t("no_image") }}
                                                </div>
                                            </router-link>

                                            <!-- Product Info -->
                                            <div>
                                                <h5 class="text-sm font-semibold">
                                                    <router-link :to="getProductLink(item.product)"
                                                        class="text-gray-800 hover:text-green-600 transition-colors">
                                                        {{ currentLanguage === 'ar' && item.product?.title_ar ?
                                                            item.product?.title_ar : item.product?.title || t("Product") }}

                                                    </router-link>

                                                </h5>
                                                <!-- Unit Type Badge -->
                                                <p class="text-xs text-gray-500 mt-1">
                                                    {{ getUnitLabel(item.product?.unit) }}
                                                </p>
                                                <!-- Stock Status -->
                                                <p v-if="item.product?.stock" class="text-xs mt-1" :class="isLowStock(item.product)
                                                        ? 'text-orange-500'
                                                        : 'text-green-600'
                                                    ">
                                                    {{
                                                        isLowStock(item.product)
                                                            ? t("low_stock")
                                                    : t("in_stock")
                                                    }}
                                                </p>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Quantity Column -->
                                    <td class="py-4 align-middle">
                                        <div
                                            class="quantity-control flex w-36 items-center border-2 border-green-600 rounded-lg overflow-hidden bg-white">
                                            <button @click="decrementQuantity(item)" :disabled="isUpdatingQuantity(item.id) || !canDecrement(item)
                                                " class="px-3 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                                :aria-label="`${t('decrease_quantity')} ${item.product?.title
                                                    }`">
                                                −
                                            </button>

                                            <div class="flex-1 text-center py-2 bg-green-50/30 font-semibold relative">
                                                <span v-if="isUpdatingQuantity(item.id)"
                                                    class="absolute inset-0 flex items-center justify-center bg-white bg-opacity-75">
                                                    <div
                                                        class="animate-spin rounded-full h-4 w-4 border-2 border-green-500 border-t-transparent">
                                                    </div>
                                                </span>
                                                <span :class="{
                                                    'opacity-0': isUpdatingQuantity(item.id),
                                                }">
                                                    {{ getQuantityDisplay(item) }}
                                                </span>
                                            </div>

                                            <button @click="incrementQuantity(item)" :disabled="isUpdatingQuantity(item.id) || !canIncrement(item)
                                                " class="px-3 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                                :aria-label="`${t('increase_quantity')} ${item.product?.title
                                                    }`">
                                                +
                                            </button>
                                        </div>
                                    </td>

                                    <!-- Price Column (Price per unit) -->
                                    <td class="py-4 align-middle">
                                        <h6 class="text-gray-600 font-medium">
                                            {{ formatPrice(getPricePerUnit(item)) }}
                                        </h6>
                                        <p class="text-xs text-gray-400 mt-1">
                                            {{ t('per') }} {{ getUnitLabel(item.product?.unit) }}
                                        </p>
                                    </td>

                                    <!-- Total Column (Total for this line item) -->
                                    <td class="py-4 align-middle">
                                        <h6 class="font-bold text-gray-800">
                                            {{ formatPrice(getItemTotal(item)) }}
                                        </h6>
                                    </td>

                                    <!-- Remove Column -->
                                    <td class="py-4 align-middle">
                                        <button @click="removeItem(item.id)" :disabled="isRemovingItem(item.id)"
                                            class="inline-flex items-center justify-center w-8 h-8 bg-white rounded-full text-gray-400 hover:text-green-600 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                            :aria-label="`${t('remove')} ${item.product?.title}`">
                                            <span v-if="isRemovingItem(item.id)" class="text-sm">⌛</span>
                                            <span v-else class="text-lg" aria-hidden="true">×</span>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Cart Summary -->
                    <div v-if="cartItems.length" class="flex flex-wrap mt-6">
                        <div class="w-full md:w-1/2"></div>
                        <div class="w-full md:w-1/2">
                            <div class="bg-white p-6 rounded-lg shadow-sm">
                                <h6 class="font-bold text-gray-700 flex justify-between items-center">
                                    {{ t("subtotal") }}:
                                    <span class="font-normal text-sm text-gray-500">{{
                                        formatPrice(calculatedSubtotal)
                                        }}</span>
                                </h6>

                                <h6 class="font-bold text-gray-700 flex justify-between items-center mt-3">
                                    {{ t("VAT") }} (14%):
                                    <span class="font-normal text-sm text-gray-500">{{
                                        formatPrice(calculatedTax)
                                        }}</span>
                                </h6>

                                <h4 class="flex justify-between items-center mt-3 text-xl font-bold text-gray-800">
                                    {{ t("total") }}:
                                    <span>{{ formatPrice(calculatedTotal) }}</span>
                                </h4>

                                <hr class="my-4 border-gray-200" />

                                <div class="flex flex-wrap items-center justify-between ">
                                    <div class="w-full md:w-1/2">
                                        <h6 class="font-bold mt-3">
                                            <router-link to="/shop"
                                                class="text-green-600 hover:text-green-700 hover:underline transition-colors">
                                                <span v-if="currentLanguage === 'ar'">→</span>
                                                <span v-else>←</span>
                                                {{ t("continue_shopping") }}
                                            </router-link>
                                        </h6>
                                    </div>
                                    <div class="w-full md:w-1/2 text-right">
                                        <h6 class="mb-0 ">
                                            <router-link to="/checkout"
                                                class="inline-block bg-green-600 hover:bg-green-700 text-white px-6 py-3  rounded-md transition-colors font-medium"
                                                :class="{
                                                    'opacity-50 cursor-not-allowed': isCartEmpty,
                                                }" :disabled="isCartEmpty">
                                                {{ t("checkout") }}
                                                <span class="mr-2 rtl:ml-2 rtl:mr-0" aria-hidden="true">
                                                    <span v-if="currentLanguage === 'ar'">←</span>
                                                    <span v-else>→</span>
                                                </span>
                                            </router-link>
                                        </h6>
                                    </div>
                                </div>

                                <hr class="mt-4 border-gray-200" />
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </home-layout>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useToast } from "vue-toastification";
import { useStore } from 'vuex';
import HomeLayout from "../components/HomeLayout.vue";
import { useLanguage } from '../composables/useLanguage';

// Use store
const store = useStore();

// Use language composable
const {
    currentLanguage,
    currentDirection,
    t,
    formatPrice,
    formatWeight
} = useLanguage();
const language = useLanguage();

// Toast instance
const toast = useToast();
const storageBase = import.meta.env.VITE_STORAGE_URL;

// Local state for optimistic updates
const updatingItems = ref(new Set());
const removingItems = ref(new Set());

// Unit configuration with proper step sizes
const unitLabels = {
    kg: {
        en: "kg",
        ar: "كجم",
        isWeight: true,
        step: 0.5,
        min: 0.5,
        max: 50,
        convertToGrams: (val) => val * 1000,
        convertFromGrams: (grams) => grams / 1000
    },
    g: {
        en: "g",
        ar: "جم",
        isWeight: true,
        step: 100,
        min: 100,
        max: 50000,
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    piece: {
        en: "piece",
        ar: "قطعة",
        isWeight: false,
        step: 1,
        min: 1,
        max: null,
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    liter: {
        en: "liter",
        ar: "لتر",
        isWeight: false,
        step: 0.5,
        min: 0.5,
        max: 50,
        convertToGrams: (val) => val * 1000,
        convertFromGrams: (grams) => grams / 1000
    },
    pack: {
        en: "pack",
        ar: "حزمة",
        isWeight: false,
        step: 1,
        min: 1,
        max: null,
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    bunch: {
        en: "bunch",
        ar: "حزمة",
        isWeight: false,
        step: 1,
        min: 1,
        max: null,
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    }
};

// Helper functions for units
const getUnitConfig = (unit) => {
    return unitLabels[unit] || unitLabels.kg;
};

const getUnitLabel = (unit) => {
    const config = getUnitConfig(unit);
    return language.currentLanguage.value === "ar" ? config.ar : config.en;
};

const getQuantityDisplay = (item) => {
    const config = getUnitConfig(item.product?.unit);
    const quantityInGrams = item.quantity_grams;

    // if (item.quantity_display) {
    //     return item.quantity_display;
    // }

    if (config.isWeight) {
        if (item.product?.unit === 'kg') {
            const kgValue = config.convertFromGrams(quantityInGrams);
            return `${kgValue.toFixed(2)} ${getUnitLabel(item.product?.unit)}`;
        } else if (item.product?.unit === 'g') {
            return `${Math.round(quantityInGrams)} ${getUnitLabel(item.product?.unit)}`;
        } else {
            return formatWeight(quantityInGrams);
        }
    } else {
        const unitValue = Math.round(quantityInGrams);
        return `${unitValue} ${getUnitLabel(item.product?.unit)}${unitValue !== 1 ? 's' : ''}`;
    }
};

// CRITICAL FIX: Get price per unit (piece/pack/kg)
const getPricePerUnit = (item) => {
    // Use price_per_unit from API if available
    if (item.price_per_unit && item.price_per_unit > 0) {
        return item.price_per_unit;
    }

    const unit = item.product?.unit;
    const productPrice = item.product?.sale_price || item.product?.price || 0;

    // For pack/piece items, the product price is already per unit
    if (unit === 'pack' || unit === 'piece' || unit === 'bunch') {
        return productPrice;
    }

    // For kg items, price is per kg
    if (unit === 'kg') {
        return productPrice;
    }

    // For gram items, convert from kg to gram
    if (unit === 'g') {
        return productPrice / 1000;
    }

    return productPrice;
};

// CRITICAL FIX: Get total for a single cart item
const getItemTotal = (item) => {
    // Use total_price from API if available and correct
    if (item.total_price && item.total_price > 0) {
        // Double-check if total_price seems reasonable
        const pricePerUnit = getPricePerUnit(item);
        const quantity = getQuantityValue(item);
        const calculatedTotal = pricePerUnit * quantity;

        // If there's a significant difference, use calculated value
        if (Math.abs(calculatedTotal - item.total_price) > 0.01) {
            console.warn('Total price mismatch:', {
                item_id: item.id,
                api_total: item.total_price,
                calculated: calculatedTotal,
                price_per_unit: pricePerUnit,
                quantity: quantity
            });
            return calculatedTotal;
        }
        return item.total_price;
    }

    // Calculate manually
    const pricePerUnit = getPricePerUnit(item);
    const quantity = getQuantityValue(item);
    return pricePerUnit * quantity;
};

// Get quantity value in product's natural unit
const getQuantityValue = (item) => {
    const unit = item.product?.unit;
    const quantityInGrams = item.quantity_grams;

    if (unit === 'pack' || unit === 'piece' || unit === 'bunch') {
        // quantity_grams stores the number of units
        return quantityInGrams;
    }

    if (unit === 'kg') {
        return quantityInGrams / 1000;
    }

    if (unit === 'g') {
        return quantityInGrams;
    }

    if (unit === 'liter') {
        return quantityInGrams / 1000;
    }

    return quantityInGrams;
};

// Get current quantity in product's unit
const getCurrentQuantityInUnit = (item) => {
    return getQuantityValue(item);
};

const canIncrement = (item) => {
    const config = getUnitConfig(item.product?.unit);
    const currentQty = getCurrentQuantityInUnit(item);
    const maxStock = getMaxStockInUnit(item.product);
    const step = config.step;

    if (maxStock === null) return true;
    return currentQty + step <= maxStock;
};

const canDecrement = (item) => {
    const config = getUnitConfig(item.product?.unit);
    const currentQty = getCurrentQuantityInUnit(item);
    const minQty = config.min;
    const step = config.step;

    return currentQty - step >= minQty;
};

const getProductLink = (product) => {
    if (product.slug) {
        return { name: 'product-details', params: { slug: product.slug } };
    }
    return { name: 'product-details', params: { id: product.id } };
};

const getMaxStockInUnit = (product) => {
    const config = getUnitConfig(product?.unit);
    const stock = product?.stock || 0;

    if (!stock) return 0;

    if (config.isWeight) {
        if (product?.unit === 'kg') {
            return stock;
        } else if (product?.unit === 'g') {
            return stock * 1000;
        } else {
            return stock;
        }
    } else {
        return stock;
    }
};

const convertToGrams = (product, quantityInUnit) => {
    const config = getUnitConfig(product?.unit);
    return config.convertToGrams(quantityInUnit);
};

// Computed properties for cart totals
const cartItems = computed(() => store.getters.cartItems || []);
const cartCount = computed(() => store.getters.cartCount);
const isLoading = computed(() => store.getters.isLoading);
const cartError = computed(() => store.getters.cartError);
const isAuthenticated = computed(() => store.getters['isAuthenticated'] || false);
const hasCartItems = computed(() => cartItems.value.length > 0);
const isCartEmpty = computed(() => !hasCartItems.value);

// CRITICAL FIX: Calculate subtotal directly from items
const calculatedSubtotal = computed(() => {
    let subtotal = 0;
    for (const item of cartItems.value) {
        subtotal += getItemTotal(item);
    }
    console.log('Calculated subtotal:', subtotal);
    return subtotal;
});

// Calculate tax (14% VAT)
const calculatedTax = computed(() => {
    return calculatedSubtotal.value * 0.14;
});

// Calculate total (subtotal + tax)
const calculatedTotal = computed(() => {
    return calculatedSubtotal.value + calculatedTax.value;
});

// Watch for auth changes to refresh cart
watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart();
    }
});

// Watch for errors
watch(cartError, (error) => {
    if (error) {
        toast.error(error);
    }
});

// Lifecycle
onMounted(() => {
    fetchCartIfNeeded();
});

// Methods
const fetchCartIfNeeded = async () => {
    if (!isLoading.value && !cartItems.value.length) {
        try {
            await store.dispatch('fetchCart');
        } catch (err) {
            console.error('Failed to fetch cart:', err);
        }
    }
};

const fetchCart = async () => {
    try {
        await store.dispatch('fetchCart');
    } catch (err) {
        console.error('Failed to fetch cart:', err);
    }
};

const retryFetchCart = () => {
    store.dispatch('fetchCart').catch(err => {
        console.error('Retry failed:', err);
    });
};

// Stock checks
const isLowStock = (product) => {
    return product?.stock > 0 && product.stock <= 2;
};

// Cart operations
const isUpdatingQuantity = (itemId) => {
    return store.getters.isUpdating(itemId) || updatingItems.value.has(itemId);
};

const isRemovingItem = (itemId) => {
    return removingItems.value.has(itemId);
};

const incrementQuantity = async (item) => {
    if (!item) return;

    const config = getUnitConfig(item.product?.unit);
    const currentQty = getCurrentQuantityInUnit(item);
    const maxStock = getMaxStockInUnit(item.product);

    let newQtyInUnit;
    let newQuantityInGrams;

    if (config.isWeight) {
        newQtyInUnit = Math.min(currentQty + config.step, maxStock);
        newQuantityInGrams = convertToGrams(item.product, newQtyInUnit);
    } else {
        newQtyInUnit = Math.min(currentQty + config.step, maxStock || currentQty + config.step);
        newQuantityInGrams = newQtyInUnit;
    }

    if (newQtyInUnit === currentQty) {
        showToast(t('max_quantity_reached'), 'warning');
        return;
    }

    await updateQuantity(item.id, Math.round(newQuantityInGrams));
};

const decrementQuantity = async (item) => {
    if (!item) return;

    const config = getUnitConfig(item.product?.unit);
    const currentQty = getCurrentQuantityInUnit(item);
    const minQty = config.min;

    let newQtyInUnit;
    let newQuantityInGrams;

    if (config.isWeight) {
        newQtyInUnit = Math.max(currentQty - config.step, minQty);
        newQuantityInGrams = convertToGrams(item.product, newQtyInUnit);
    } else {
        newQtyInUnit = Math.max(currentQty - config.step, minQty);
        newQuantityInGrams = newQtyInUnit;
    }

    if (newQtyInUnit === currentQty) {
        showToast(t('min_quantity_reached'), 'warning');
        return;
    }

    await updateQuantity(item.id, Math.round(newQuantityInGrams));
};

const updateQuantity = async (itemId, quantityGrams) => {
    updatingItems.value.add(itemId);

    try {
        await store.dispatch('updateQuantity', {
            itemId,
            quantityGrams
        });
        showToast(t('quantity_updated'), 'success');
    } catch (error) {
        console.error('Failed to update quantity:', error);
        showToast(error.response?.data?.message || error.message || t('update_error'), 'error');
    } finally {
        updatingItems.value.delete(itemId);
    }
};

const removeItem = async (itemId) => {
    if (!confirm(t('confirm_remove'))) return;

    removingItems.value.add(itemId);

    try {
        await store.dispatch('removeItem', itemId);
        showToast(t('item_removed'), 'success');
    } catch (error) {
        console.error('Failed to remove item:', error);
        showToast(error.response?.data?.message || t('remove_error'), 'error');
    } finally {
        removingItems.value.delete(itemId);
    }
};

// Toast helper
const showToast = (message, type = 'success') => {
    if (toast) {
        toast[type](message, {
            timeout: 3000,
            position: currentLanguage.value === 'ar' ? 'top-left' : 'top-right'
        });
    } else {
        alert(message);
    }
};

// Expose for debugging
defineExpose({
    cartItems,
    calculatedSubtotal,
    calculatedTax,
    calculatedTotal,
    fetchCart,
    updatingItems,
    removingItems
});
</script>

<style scoped>
/* RTL specific adjustments */
.quantity-control {
    display: flex;
}

[dir="rtl"] .mr-2 {
    margin-left: 0.5rem;
    margin-right: 0;
}

[dir="rtl"] .ml-2 {
    margin-right: 0.5rem;
    margin-left: 0;
}

/* Loading spinner animation */
@keyframes spin {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

.animate-spin {
    animation: spin 1s linear infinite;
}
</style>
