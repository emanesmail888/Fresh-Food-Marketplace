<template>
    <div class="w-full mx-auto px-4 py-8" :dir="currentDirection">
        <!-- Header -->
        <div class="text-center mb-8">
            <h2 class="text-2xl md:text-2xl font-bold text-yellow-800">
                {{ t('looking_for_green_vegetables') }}
            </h2>
            <p class="text-gray-600 mt-3 text-base md:text-lg max-w-2xl mx-auto">
                {{ t('discover_green_vegetables') }}
            </p>
        </div>

        <!-- Loading State -->
        <!-- <div v-if="isLoading" class="flex justify-center items-center py-20">
            <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
            <p class="mr-3 rtl:ml-3 rtl:mr-0 text-gray-600">{{ t("loading") }}</p>
        </div> -->

        <!-- Error State -->
        <div v-if="error" class="text-center py-20">
            <p class="text-red-600 mb-4">{{ error }}</p>
            <button @click="retry" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700">
                {{ t("retry") }}
            </button>
        </div>

        <!-- Empty State -->
        <div v-else-if="!greenVegetablesProducts.length" class="text-center py-20">
            <p class="text-gray-600">{{ t("no_green_vegetables_products_found") }}</p>
        </div>

        <!-- Grid Container - 5 cards -->
        <div v-else class="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-6 lg:grid-cols-6 gap-4 md:gap-6 p-2">
            <div v-for="product in displayedProducts" :key="product.id"
                class="bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 overflow-hidden group">

                <!-- Image Area -->
                <div
                    class="w-full aspect-square bg-linear-to-br from-green-100 to-emerald-100 relative overflow-hidden">
                     <router-link :to="getProductLink(product)" class="block h-full">
                        <img v-if="product.image" :src="getProductImage(product.image)" :width="280" :height="280"
                            :alt="product.title"
                            class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                            loading="lazy" decoding="async" style="aspect-ratio: 1 / 1;" />
                        <div v-else class="w-full h-full flex items-center justify-center">
                            <div class="text-7xl md:text-8xl transition-transform duration-300 group-hover:scale-110">
                                {{ getCategoryIcon(product.category_id) }}
                            </div>
                        </div>
                    </router-link>

                    <!-- Discount Badge -->
                    <div v-if="getDiscount(product.price, product.sale_price)"
                        class="absolute top-3 z-10 bg-red-700 text-white text-sm font-bold px-3 py-1.5 rounded-full shadow-sm"
                        :class="currentLanguage === 'ar' ? 'right-3' : 'left-3'">
                        -{{ getDiscount(product.price, product.sale_price) }}%
                    </div>

                    <!-- Out of Stock Overlay -->
                    <div v-if="!isInStock(product)"
                        class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                        <span class="text-white font-bold text-lg">{{ t("out_of_stock") }}</span>
                    </div>

                    <!-- Wishlist Button -->
                    <button @click="toggleWishlist(product)" :disabled="wishlistLoading[product.id]"
                        class="absolute top-3 z-10 p-2.5 bg-white rounded-full shadow-md hover:shadow-lg transition-all duration-300 hover:scale-110 disabled:opacity-50"
                        :class="currentLanguage === 'ar' ? 'left-3' : 'right-3'">
                        <svg v-if="wishlistLoading[product.id]" class="animate-spin h-5 w-5 text-gray-400"
                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                            </path>
                        </svg>
                        <svg v-else class="w-5 h-5 transition-colors duration-300"
                            :class="isInWishlist(product.id) ? 'text-red-500 fill-current' : 'text-gray-400 hover:text-red-400'"
                            fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                        </svg>
                    </button>
                </div>

                <!-- Content -->
                <div class="p-4 md:p-5 text-center">
                    <h3 class="text-sm md:text-base lg:text-lg font-semibold text-gray-800 mb-2 line-clamp-2">
                        {{ product.title }}
                    </h3>

                    <!-- Unit Info -->
                    <p class="text-xs text-gray-500 mb-2">
                        {{ getUnitLabel(product.unit) }}
                    </p>

                    <!-- Price -->
                    <div class="flex items-center justify-center gap-2 mb-3">
                        <span v-if="product.sale_price" class="text-lg md:text-xl font-bold text-green-700">
                            {{ formatPrice(product.sale_price) }}
                        </span>
                        <span v-if="product.sale_price" class="text-xs text-gray-500 line-through">
                            {{ formatPrice(product.price) }}
                        </span>
                        <span v-else class="text-lg md:text-xl font-bold text-green-700">
                            {{ formatPrice(product.price) }}
                        </span>
                    </div>

                    <!-- Price per unit note -->
                    <p class="text-xs text-gray-500 mb-3">
                        {{ t('price_per') }} {{ getUnitLabel(product.unit) }}
                    </p>

                    <!-- Stock Status -->
                    <p v-if="isLowStock(product)" class="text-xs text-orange-600 mb-3">
                        ⚠️ {{ t("low_stock") }}
                    </p>

                    <!-- Add to Cart Section -->
                    <div class="mt-auto">
                        <div v-if="!isInStock(product)">
                            <button disabled
                                class="w-full bg-gray-300 text-gray-500 font-medium py-2.5 rounded-xl cursor-not-allowed text-sm">
                                {{ t("unavailable") }}
                            </button>
                        </div>

                        <!-- Not in cart - Show Add button -->
                        <button v-else-if="!isInCart(product)" @click="addToCart(product)"
                            :disabled="isAddingToCart(product.id)"
                            class="w-full bg-green-600 hover:bg-green-700 active:bg-green-800 text-white font-medium py-2.5 rounded-xl transition-all duration-200 hover:shadow-lg transform active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2 text-sm">
                            <svg v-if="isAddingToCart(product.id)" class="animate-spin h-4 w-4"
                                xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                    stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor"
                                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                                </path>
                            </svg>
                            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6M17 13l1.5 6M9 21h6M12 21v-8">
                                </path>
                            </svg>
                            <span>{{ t("add_to_cart") }}</span>
                        </button>

                        <!-- In cart - Show quantity controls -->
                        <div v-else
                            class="quantity-control flex items-center border-2 border-green-600 rounded-xl overflow-hidden bg-white">
                            <button @click="decrementQuantity(product)" :disabled="isUpdatingQuantity(product.id) ||
                                !canDecrement(product)
                                "
                                class="px-3 py-1.5 text-lg font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                −
                            </button>

                            <div
                                class="flex-1 text-center py-1.5 bg-green-50/30 font-semibold relative min-w-10 text-sm">
                                <span v-if="isUpdatingQuantity(product.id)"
                                    class="absolute inset-0 flex items-center justify-center bg-white bg-opacity-75">
                                    <div
                                        class="animate-spin rounded-full h-4 w-4 border-2 border-green-500 border-t-transparent">
                                    </div>
                                </span>
                                <span :class="{ 'opacity-0': isUpdatingQuantity(product.id) }">
                                    {{ formatQuantity(product) }}
                                </span>
                            </div>

                            <button @click="incrementQuantity(product)" :disabled="isUpdatingQuantity(product.id) || !canIncrement(product)
                                "
                                class="px-3 py-1.5 text-lg font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                +
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Why Green Vegetables Section -->
        <div class="mt-16 text-center">
            <div class="bg-linear-to-l from-transparent to-olive-100 relative overflow-hidden rounded-3xl p-8 md:p-12"
                >

                <!-- <div
                    class="absolute top-0 right-0 w-64 h-64 rounded-full bg-emerald-200/15 -translate-y-1/2 translate-x-1/3 blur-3xl">
                </div>
                <div
                    class="absolute bottom-0 left-0 w-64 h-64 rounded-full bg-amber-200/15 translate-y-1/2 -translate-x-1/3 blur-3xl">
                </div> -->
                <!-- Content -->
                <div class="relative z-10">
                    <h3 class="text-xl md:text-2xl font-bold mb-8 text-amber-800">
                        {{ t('nature_gift') }}
                    </h3>

                    <p class="text-gray-600 mb-8 text-base md:text-lg max-w-2xl mx-auto">
                        {{ t('discover_health_benefits') }}
                    </p>
                    <!-- Features Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div v-for="feature in features" :key="feature.key"
                            class="bg-linear-to-l from-transparent to-orange-50 backdrop-blur-sm rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 p-6 text-center group hover:-translate-y-2 hover:bg-white/95"
                            style="border: 1px solid rgba(255, 255, 255, 0.5);">
                            <!-- Icon Circle -->
                            <div class="flex justify-center mb-4">
                                <div class="w-16 h-16 rounded-full flex items-center justify-center transition-all duration-300 group-hover:scale-110 group-hover:shadow-lg"
                                    :class="feature.bgColor || 'bg-green-100'">
                                    <svg xmlns="http://www.w3.org/2000/svg"
                                        class="h-8 w-8 transition-all duration-300 group-hover:rotate-6 group-hover:scale-110"
                                        :class="feature.color || 'text-green-600'" fill="none" viewBox="0 0 24 24"
                                        stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" :d="feature.icon" />
                                    </svg>
                                </div>
                            </div>

                            <!-- Title -->
                            <h3
                                class="text-lg font-semibold text-gray-800 mb-2 group-hover:text-taupe-500 transition-colors duration-300">
                                {{ t(feature.key) }}
                            </h3>

                            <!-- Description -->
                            <p class="text-gray-600 text-sm leading-relaxed">
                                {{ t(feature.key + '_description') }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useStore } from 'vuex'
import { useToast } from 'vue-toastification'
import { useLanguage } from '../composables/useLanguage.js'
import { useRouter } from "vue-router";

const props = defineProps({
    greenVegetablesProducts: {
        type: Array,
        default: () => []
    },
    error: {
        type: String,
        default: null
    }
})

const store = useStore()
const router = useRouter();

const toast = useToast()
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/"

const {
    currentLanguage,
    currentDirection,
    t,
    formatPrice
} = useLanguage()

// Show only first 5 products
const displayedProducts = computed(() => {
    return props.greenVegetablesProducts.slice(0, 6)
})

// Reactive states
const addingToCart = ref(new Set())
const localUpdatingItems = ref(new Set())

const wishlistLoading = ref({});


// Unit configuration for seeds (pieces/packs only)
const UNIT_CONFIG = {
    piece: {
        step: 1,
        min: 1,
        displayUnit: 'piece',
        storageUnit: 'pieces',
        formatValue: (value) => `${Math.round(value)}`,
    },
    pack: {
        step: 1,
        min: 1,
        displayUnit: 'pack',
        storageUnit: 'packs',
        formatValue: (value) => `${Math.round(value)}`,
    },
    kg: {
        step: 0.5,
        min: 0.5,
        displayUnit: 'kg',
        formatValue: (value) => `${value.toFixed(1)}`,
    },
    g: {
        step: 100,
        min: 100,
        displayUnit: 'g',
        formatValue: (value) => `${Math.round(value)}`,
    },
    liter: {
        step: 0.5,
        min: 0.5,
        displayUnit: 'L',
        formatValue: (value) => `${value.toFixed(1)}`,
    },
    bunch: {
        step: 1,
        min: 1,
        displayUnit: 'bunch',
        formatValue: (value) => `${Math.round(value)}`,
    },
}

// Get unit configuration based on product unit
const getUnitConfig = (unit) => {
    return UNIT_CONFIG[unit] || UNIT_CONFIG.piece
}

// Convert quantity from product unit to grams for backend
const convertToGrams = (product, quantity) => {
    const unit = product.unit || 'piece'

    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return Math.round(quantity)
    }

    if (unit === 'kg') {
        return Math.round(quantity * 1000)
    }

    if (unit === 'liter') {
        return Math.round(quantity * 1000)
    }

    return Math.round(quantity)
}

// Category Icons Mapping
const categoryIcons = {
    1: '🥬', // Vegetables
    2: '🌸', // Flowers
    3: '🍎', // Fruits
    4: '🌿', // Herbs
    5: '🌱', // Microgreens
    6: '🧅'  // Bulbs
}


const features = [
    {
        key: 'healthy_benefit',
        icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
        color: 'text-amber-600',
        bgColor: 'bg-amber-100',
        hoverBg: 'hover:bg-amber-50'
    },
    {
        key: 'heart_benefit',
        icon: 'M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z',
        color: 'text-rose-500',
        bgColor: 'bg-rose-100',
        hoverBg: 'hover:bg-rose-50'
    },
    {
        key: 'why_green_vegetables',
        icon: 'M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253',
        color: 'text-lime-700',
        bgColor: 'bg-lime-100',
        hoverBg: 'hover:bg-lime-50'
    },
    {
        key: 'immunity_benefit',
        icon: 'M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z',
        color: 'text-red-400',
        bgColor: 'bg-red-100',
        hoverBg: 'hover:bg-red-50'
    }
];
// Cart related
const cartItems = computed(() => store.getters.cartItems || [])
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false)

const wishlistItems = computed(() => {
    const items = store.getters['wishlist/wishlistItems'];
    return Array.isArray(items) ? items : [];
});

// Check if product is in cart
const isInCart = (product) => {
    return cartItems.value.some(item => item.product_id === product.id)
}

// Check if updating quantity
const isUpdatingQuantity = (productId) => {
    const item = getCartItem({ id: productId })
    if (!item) return false

    const isStoreUpdating = typeof store.getters.isUpdating === 'function'
        ? store.getters.isUpdating(item.id)
        : false

    return isStoreUpdating || localUpdatingItems.value.has(item.id)
}

// Helper functions
const getCategoryIcon = (categoryId) => {
    return categoryIcons[categoryId] || '🌱'
}

const getUnitLabel = (unit) => {
    const labels = {
        kg: currentLanguage.value === 'ar' ? 'كجم' : 'kg',
        g: currentLanguage.value === 'ar' ? 'جم' : 'g',
        piece: currentLanguage.value === 'ar' ? 'قطعة' : 'piece',
        liter: currentLanguage.value === 'ar' ? 'لتر' : 'liter',
        pack: currentLanguage.value === 'ar' ? 'حزمة' : 'pack',
        bunch: currentLanguage.value === 'ar' ? 'حزمة' : 'bunch'
    }
    return labels[unit] || labels.piece
}

const getProductImage = (imagePath) => {
    if (!imagePath) return "/images/placeholder.jpg";
    if (imagePath.startsWith("http")) return imagePath;
    return `${storageBase}/${imagePath}`;
}

const getProductLink = (product) => {
    if (product.slug) {
        return { name: 'product-details', params: { slug: product.slug } };
    }
    return { name: 'product-details', params: { id: product.id } };
};

const getDiscount = (price, salePrice) => {
    if (!price || !salePrice || salePrice >= price) return 0
    return Math.round(((price - salePrice) / price) * 100)
}

// Stock checks
const isInStock = (product) => {
    return (product.stock || 0) > 0
}

const isLowStock = (product) => {
    return product.stock > 0 && product.stock <= 2
}

const getMaxStockInUnit = (product) => {
    const unit = product.unit || 'piece'
    const maxStock = product.stock || 50

    if (unit === 'kg') {
        return maxStock
    }

    if (unit === 'g') {
        return maxStock * 1000
    }

    return maxStock
}

const canIncrement = (product) => {
    const currentVal = getCurrentQuantityInUnit(product)
    const maxVal = getMaxStockInUnit(product)
    const step = getStepValue(product)

    return currentVal + step <= maxVal
}

const canDecrement = (product) => {
    const currentVal = getCurrentQuantityInUnit(product)
    const minVal = getMinValue(product)
    const step = getStepValue(product)

    return currentVal - step >= minVal
}

const getStepValue = (product) => {
    const unit = product.unit || 'piece'
    const config = getUnitConfig(unit)
    return config.step
}

const getMinValue = (product) => {
    const unit = product.unit || 'piece'
    const config = getUnitConfig(unit)
    return config.min
}

const isAddingToCart = (productId) => {
    return addingToCart.value.has(productId)
}

const getCartItem = (product) => {
    return store.getters.getCartItemByProductId(product.id)
}

const getCurrentQuantityInUnit = (product) => {
    const cartItem = getCartItem(product)
    if (!cartItem) return 0

    if (cartItem.quantity_value !== undefined) {
        return cartItem.quantity_value
    }

    const unit = product.unit || 'piece'
    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return cartItem.quantity_grams
    }

    if (unit === 'kg') {
        return cartItem.quantity_grams / 1000
    }

    return cartItem.quantity_grams
}

const formatQuantity = (product) => {
    const cartItem = getCartItem(product)
    if (!cartItem) return '0'

    if (cartItem.quantity_display) {
        return cartItem.quantity_display
    }

    const unit = product.unit || 'piece'
    const config = getUnitConfig(unit)
    const value = getCurrentQuantityInUnit(product)
    return config.formatValue(value)
}

const updateQuantity = async (itemId, productId, quantityInGrams) => {
    if (!itemId) {
        console.error('No item ID provided for update')
        showToast('حدث خطأ: معرف المنتج غير موجود', 'error')
        return
    }

    if (!productId) {
        console.error('No product ID provided for update')
        showToast('حدث خطأ: معرف المنتج غير موجود', 'error')
        return
    }

    localUpdatingItems.value.add(itemId)

    try {
        await store.dispatch('updateQuantity', {
            itemId: itemId,
            quantityGrams: Math.round(quantityInGrams)
        })

        await fetchCart()
    } catch (error) {
        console.error('Update quantity error:', error)
        const errorMessage = error.response?.data?.message || error.message || t('update_error')
        showToast(errorMessage, 'error')
        throw error
    } finally {
        localUpdatingItems.value.delete(itemId)
    }
}

const incrementQuantity = async (product) => {
    const cartItem = getCartItem(product)
    if (!cartItem) {
        showToast('المنتج غير موجود في السلة', 'error')
        return
    }

    const step = getStepValue(product)
    const currentVal = getCurrentQuantityInUnit(product)
    const maxVal = getMaxStockInUnit(product)

    if (currentVal >= maxVal) {
        showToast(t('max_quantity_reached'), 'warning')
        return
    }

    const newVal = Math.min(currentVal + step, maxVal)
    if (newVal === currentVal) return

    const newQuantityInGrams = convertToGrams(product, newVal)
    await updateQuantity(cartItem.id, product.id, newQuantityInGrams)
}

const decrementQuantity = async (product) => {
    const cartItem = getCartItem(product)
    if (!cartItem) {
        showToast('المنتج غير موجود في السلة', 'error')
        return
    }

    const step = getStepValue(product)
    const currentVal = getCurrentQuantityInUnit(product)
    const minVal = getMinValue(product)

    if (currentVal <= minVal) {
        showToast(t('min_quantity_reached'), 'warning')
        return
    }

    const newVal = Math.max(currentVal - step, minVal)
    if (newVal === currentVal) return

    const newQuantityInGrams = convertToGrams(product, newVal)
    await updateQuantity(cartItem.id, product.id, newQuantityInGrams)
}

// Add to Cart
const addToCart = async (product) => {
    if (!isInStock(product)) {
        showToast(t('out_of_stock'), 'error')
        return
    }

    addingToCart.value.add(product.id)

    try {
        const unit = product.unit || 'piece'
        const config = getUnitConfig(unit)
        const quantity = config.min
        const quantityInGrams = convertToGrams(product, quantity)

        await store.dispatch('addItem', {
            productId: product.id,
            quantityGrams: quantityInGrams
        })

        showToast(`${product.title} ${t('added_to_cart')}`, 'success')
        await fetchCart()
    } catch (error) {
        console.error('Add to cart error:', error)
        showToast(error.response?.data?.message || error.message || t('add_to_cart_error'), 'error')
    } finally {
        addingToCart.value.delete(product.id)
    }
}

const fetchCart = async () => {
    try {
        await store.dispatch('fetchCart')
    } catch (error) {
        console.error('Failed to fetch cart:', error)
    }
}

// Wishlist methods


const fetchWishlist = async () => {
    if (isAuthenticated.value) {
        try {
            await store.dispatch('wishlist/fetchWishlist');
        } catch (error) {
            console.error('Failed to fetch wishlist:', error);
        }
    }
};

const isInWishlist = (productId) => {
    // Ensure wishlistItems.value is an array before using .some()
    if (!Array.isArray(wishlistItems.value)) {
        console.warn('wishlistItems is not an array:', wishlistItems.value);
        return false;
    }
    return wishlistItems.value.some(item => {
        // Handle both nested and flat structures
        const itemId = item.product_id || item.id;
        return itemId === productId;
    });
};

const toggleWishlist = async (product) => {
    if (!isAuthenticated.value) {
        toast.warning(t("login_to_wishlist") || "Please login to add items to wishlist");
        return;
    }

    wishlistLoading.value[product.id] = true;

    try {
        await store.dispatch('wishlist/toggleWishlist', product.id);

        if (isInWishlist(product.id)) {
            toast.success(t("added_to_wishlist") || "Added to wishlist");
        } else {
            toast.success(t("removed_from_wishlist") || "Removed from wishlist");
        }
    } catch (error) {
        console.error('Wishlist error:', error);
        toast.error(t("wishlist_error") || "Failed to update wishlist");
    } finally {
        wishlistLoading.value[product.id] = false;
    }
};

// Toast helper
const showToast = (message, type = 'success') => {
    if (toast) {
        toast[type](message, {
            timeout: 3000,
            position: currentLanguage.value === 'ar' ? 'top-left' : 'top-right'
        })
    }
}

// Watchers
watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart()
    }
})

// Lifecycle
onMounted(() => {
    fetchCart();
    fetchWishlist();

})
</script>

<style scoped>
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.quantity-control {
    display: flex;
}

/* Ensure cards are consistent height */
.grid>div {
    display: flex;
    flex-direction: column;
}

.grid>div>div:last-child {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.grid>div>div:last-child>div:last-child {
    margin-top: auto;
}
</style>
