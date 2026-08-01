<template>
    <div class="w-full mx-auto px-4 py-8" :dir="currentDirection">
        <!-- Header -->
        <div class="text-center mb-12">
            <div class="flex items-center justify-center gap-4 mb-4">
                <div class="h-px w-12 bg-linear-to-r from-transparent to-yellow-500"></div>
                <span class="text-yellow-600 font-semibold text-sm uppercase tracking-wider">
                    {{ t("our_seeds_collection") || "Our Seeds Collection" }}
                </span>
                <div class="h-px w-12 bg-linear-to-l from-transparent to-yellow-500"></div>
            </div>

            <h2 class="text-4xl md:text-3xl font-bold text-yellow-800 mb-3">
                {{ t("looking_for_seeds") }}
            </h2>
            <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                {{ t("discover_seeds") || "Explore the range of services we offer to help you grow and maintain your garden." }}
            </p>
        </div>

        <!-- Error State -->
        <div v-if="error" class="text-center py-20">
            <p class="text-red-600 mb-4">{{ error }}</p>
            <button @click="retry" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700">
                {{ t("retry") }}
            </button>
        </div>

        <!-- Empty State -->
        <div v-else-if="!products.length" class="text-center py-20">
            <p class="text-gray-600">{{ t("no_products_found") }}</p>
        </div>

        <!-- Carousel Container -->
        <div v-else class="relative">
            <!-- Navigation Buttons -->
            <button @click="prev"
                class="absolute top-1/2 -translate-y-1/2 z-20 bg-white/95 hover:bg-white shadow-lg hover:shadow-xl rounded-full p-3 transition-all duration-200 hover:scale-110 hidden md:flex items-center justify-center"
                :class="[currentDirection === 'rtl' ? 'right-0 md:-right-4' : 'left-0 md:-left-4']">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                        :d="currentDirection === 'rtl' ? 'M9 5l7 7-7 7' : 'M15 19l-7-7 7-7'" />
                </svg>
            </button>

            <!-- Carousel Track -->
            <div ref="carouselRef" class="overflow-hidden">
                <div class="flex transition-transform duration-500 ease-out" :style="getTransformStyle()">
                    <div v-for="(product, index) in displayItems" :key="`${product.id}-${index}`"
                        class="flex-none px-2 md:px-3" :style="{ width: `${cardWidth}px` }">
                        <div
                            class="bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 overflow-hidden group h-full">
                            <!-- Image Area -->
                            <div
                                class="w-full aspect-square bg-linear-to-br from-green-100 to-emerald-100 relative overflow-hidden">
                                <router-link :to="getProductLink(product)" class="block h-full">
                                    <img v-if="product.image" :src="getProductImage(product.image)" :width="280"
                                        :height="280" :alt="product.title"
                                        class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                                        decoding="async" style="aspect-ratio: 1 / 1;" />
                                    <div v-else class="w-full h-full flex items-center justify-center">
                                        <div
                                            class="text-7xl md:text-8xl transition-transform duration-300 group-hover:scale-110">
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
                                <h3
                                    class="text-sm md:text-base lg:text-lg font-semibold text-gray-800 mb-2 line-clamp-2">
                                    {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title
                                    }}

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
                                        <svg v-else class="w-4 h-4" fill="none" stroke="currentColor"
                                            viewBox="0 0 24 24">
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
                </div>
            </div>

            <!-- Right Navigation Button -->
            <button @click="next"
                class="absolute top-1/2 -translate-y-1/2 z-20 bg-white/95 hover:bg-white shadow-lg hover:shadow-xl rounded-full p-3 transition-all duration-200 hover:scale-110 hidden md:flex items-center justify-center"
                :class="[currentDirection === 'rtl' ? 'left-0 md:-left-4' : 'right-0 md:-right-4']">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                        :d="currentDirection === 'rtl' ? 'M15 19l-7-7 7-7' : 'M9 5l7 7-7 7'" />
                </svg>
            </button>
        </div>

        <!-- Pagination Dots -->
        <div v-if="products.length" class="flex justify-center gap-2 mt-8" :dir="currentDirection">
            <button v-for="(_, idx) in totalSlides" :key="idx" @click="goToSlide(idx)"
                class="h-2.5 rounded-full transition-all duration-300" :class="[
                    getCurrentSlideIndex() === idx
                        ? 'w-8 bg-green-600'
                        : 'w-2.5 bg-gray-300 hover:bg-gray-400'
                ]" />
        </div>

        <!-- Why Constituent Bazar Section -->
        <div class="mt-16  text-center">
            <div class="bg-linear-to-l from-transparent to-taupe-100 rounded-3xl py-12 px-4 ">
                <h3 class="text-2xl md:text-2xl font-bold text-green-800 mb-20">
                    {{ t('why_constituent_bazar') }}
                </h3>
                <div class="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-4 gap-8 max-w-5xl mx-auto">
                    <div v-for="feature in features" :key="feature.key"
                        class="flex flex-col items-center group cursor-pointer">
                        <div
                            class="w-16 h-16 bg-linear-to-l from-transparent to-olive-200 rounded-2xl flex items-center justify-center group-hover:bg-olive-200 transition-colors duration-300">
                            <svg class="w-9 h-9 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    :d="feature.icon" />
                            </svg>
                        </div>
                        <p class="text-green-900 mt-4 font-base font-medium ">
                            {{ t(feature.key) }}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import { useStore } from 'vuex'
import { useToast } from 'vue-toastification'
import { useLanguage } from '../composables/useLanguage.js'
import { useRouter } from "vue-router";

let autoplayInterval = null;

const props = defineProps({
    seedsProducts: {
        type: Array,
        default: () => []
    },
    error: {
        type: String,
        default: null
    }
})

const emit = defineEmits(['retry'])

const store = useStore()
const router = useRouter();

const toast = useToast()
const storageBase = import.meta.env.VITE_STORAGE_URL 

const {
    currentLanguage,
    currentDirection,
    t,
    formatPrice
} = useLanguage()

// Reactive states
const carouselRef = ref(null)
const currentIndex = ref(0)
const cardWidth = ref(280)
const cardsPerView = ref(5)
const isInfinite = ref(true)
const addingToCart = ref(new Set())
const localUpdatingItems = ref(new Set())
const wishlistLoading = ref({});

// Use props.seedsProducts instead of seedsProducts directly
const products = computed(() => props.seedsProducts || [])

// Unit configuration for seeds
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

// Get unit configuration
const getUnitConfig = (unit) => {
    return UNIT_CONFIG[unit] || UNIT_CONFIG.piece
}

// Convert quantity to grams
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

// Features
const features = [
    { key: 'premium_quality', icon: 'M5 13l4 4L19 7' },
    { key: 'online_shopping', icon: 'M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z' },

    { key: 'fast_delivery', icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' },
    { key: 'satisfaction', icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' },
]

// Cart related
const cartItems = computed(() => store.getters.cartItems || [])
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false)
const wishlistItems = computed(() => {
    const items = store.getters['wishlist/wishlistItems'];
    return Array.isArray(items) ? items : [];
});
// Check if product is in cart - FIXED: Make it a function
const isInCart = (product) => {
    return cartItems.value.some(item => item.product_id === product.id)
}

// Carousel computed - use products.value instead of seedsProducts
const totalSlides = computed(() => Math.ceil(products.value.length / cardsPerView.value))

const displayItems = computed(() => {
    if (!isInfinite.value || products.value.length === 0) {
        return products.value
    }

    // Create duplicate items for infinite scroll
    const items = [...products.value]
    const totalItems = items.length
    const itemsToAdd = cardsPerView.value * 2 // Add 2 full views

    for (let i = 0; i < itemsToAdd; i++) {
        items.push(items[i % totalItems])
    }

    return items
})

const getTransformStyle = () => {
    const translate = currentIndex.value * cardWidth.value
    return currentDirection.value === 'rtl'
        ? { transform: `translateX(${translate}px)` }
        : { transform: `translateX(-${translate}px)` }
}

const getCurrentSlideIndex = () => {
    const total = totalSlides.value
    if (total === 0) return 0
    const rawIndex = Math.floor(currentIndex.value / cardsPerView.value)
    return rawIndex % total
}

// Navigation - use products.value instead of seedsProducts
const next = () => {
    if (!products.value.length) return

    const totalItems = products.value.length
    const maxIndex = totalItems - cardsPerView.value

    // Check if we're at the end
    if (currentIndex.value >= maxIndex) {
        // Smoothly transition to the cloned items
        const newIndex = currentIndex.value + cardsPerView.value
        currentIndex.value = newIndex

        // After transition, reset to beginning
        setTimeout(() => {
            resetToStart()
        }, 500)
    } else {
        const newIndex = Math.min(currentIndex.value + cardsPerView.value, maxIndex)
        currentIndex.value = newIndex
    }
}

const prev = () => {
    if (!products.value.length) return

    const totalItems = products.value.length
    const totalSlidesCount = totalSlides.value

    if (currentIndex.value <= 0) {
        // Go to the end (clone)
        const newIndex = totalItems - cardsPerView.value + (totalSlidesCount * cardsPerView.value)
        currentIndex.value = newIndex

        setTimeout(() => {
            resetToEnd()
        }, 500)
    } else {
        const newIndex = Math.max(currentIndex.value - cardsPerView.value, 0)
        currentIndex.value = newIndex
    }
}

const resetToStart = () => {
    if (!carouselRef.value) return
    const track = carouselRef.value.querySelector('.flex')
    if (!track) return

    track.style.transition = 'none'
    const resetIndex = 0
    const translate = currentDirection.value === 'rtl'
        ? resetIndex * cardWidth.value
        : -(resetIndex * cardWidth.value)

    track.style.transform = `translateX(${translate}px)`
    currentIndex.value = resetIndex
    // Force reflow
    track.offsetHeight
    track.style.transition = 'transform 0.5s ease-out'
}

const resetToEnd = () => {
    if (!carouselRef.value) return
    const track = carouselRef.value.querySelector('.flex')
    if (!track) return

    track.style.transition = 'none'
    const totalItems = products.value.length
    const maxIndex = totalItems - cardsPerView.value
    const translate = currentDirection.value === 'rtl'
        ? maxIndex * cardWidth.value
        : -(maxIndex * cardWidth.value)

    track.style.transform = `translateX(${translate}px)`
    currentIndex.value = maxIndex
    track.offsetHeight
    track.style.transition = 'transform 0.5s ease-out'
}

const goToSlide = (index) => {
    const targetIndex = index * cardsPerView.value
    currentIndex.value = targetIndex
}

// Autoplay
const startAutoplay = () => {
    if (autoplayInterval) clearInterval(autoplayInterval)
    autoplayInterval = setInterval(() => next(), 4000)
}

// Helper functions
const getCategoryIcon = (categoryId) => {
    return categoryIcons[categoryId] || '🌱'
}

const getProductLink = (product) => {
    if (product.slug) {
        return { name: 'product-details', params: { slug: product.slug } };
    }
    return { name: 'product-details', params: { id: product.id } };
};

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

const isUpdatingQuantity = (productId) => {
    const item = getCartItem({ id: productId })
    if (!item) return false

    const isStoreUpdating = typeof store.getters.isUpdating === 'function'
        ? store.getters.isUpdating(item.id)
        : false

    return isStoreUpdating || localUpdatingItems.value.has(item.id)
}

const updateQuantity = async (itemId, productId, quantityInGrams) => {
    if (!itemId || !productId) {
        console.error('Missing itemId or productId for update')
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

// Navigate to product detail
const navigateToProduct = (product) => {
    router.push({
        path: `/product/${product.slug || product.id}`
    });
};

// Responsive Card Width and Cards Per View
const updateLayout = () => {
    const width = window.innerWidth

    // Update cards per view based on screen size
    if (width < 480) {
        cardsPerView.value = 1
        cardWidth.value = 320
    } else if (width < 640) {
        cardsPerView.value = 2
        cardWidth.value = 300
    } else if (width < 768) {
        cardsPerView.value = 2
        cardWidth.value = 340
    } else if (width < 1024) {
        cardsPerView.value = 3
        cardWidth.value = 310
    } else if (width < 1280) {
        cardsPerView.value = 4
        cardWidth.value = 290
    } else {
        cardsPerView.value = 5
        cardWidth.value = 280
    }
}

const handleResize = () => {
    const oldCardsPerView = cardsPerView.value
    updateLayout()
    if (oldCardsPerView !== cardsPerView.value && isInfinite.value && products.value.length > 0) {
        nextTick(() => {
            currentIndex.value = 0
        })
    }
}

// Retry function
const retry = () => {
    emit('retry')
}

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
watch(currentLanguage, () => {
    if (isInfinite.value && products.value.length > 0) {
        currentIndex.value = 0
    }
})

watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart()
    }
})

watch(() => props.seedsProducts, () => {
    if (isInfinite.value && products.value.length > 0) {
        currentIndex.value = 0
    }
})

// Lifecycle
onMounted(() => {
    fetchCart()
    fetchWishlist();

    updateLayout()
    window.addEventListener('resize', handleResize)

    nextTick(() => {
        if (isInfinite.value && carouselRef.value && products.value.length > 0) {
            const track = carouselRef.value.querySelector('.flex')
            if (track) {
                const translate = currentDirection.value === 'rtl'
                    ? 0
                    : 0
                track.style.transform = `translateX(${translate}px)`
                currentIndex.value = 0
            }
        }
        startAutoplay()
    })
})

onBeforeUnmount(() => {
    if (autoplayInterval) {
        clearInterval(autoplayInterval)
        autoplayInterval = null
    }
    window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.transition-transform {
    transition-timing-function: cubic-bezier(0.32, 0.72, 0, 1);
}

.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.quantity-control {
    display: flex;
}

/* Consistent card heights */
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
