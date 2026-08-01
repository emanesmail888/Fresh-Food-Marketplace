<template>
    <div class="w-full mx-auto px-4 py-8" :dir="currentDirection">
        <!-- Header -->
        <div class="text-center mb-8">
            <h2 class="text-3xl md:text-4xl font-bold text-gray-800">
                {{ t('looking_for_seeds') }}
            </h2>
            <p class="text-gray-600 mt-3 text-base md:text-lg max-w-2xl mx-auto">
                {{ t('discover_seeds') }}
            </p>
        </div>

        <!-- Loading State -->
        <!-- <div v-if="isLoading" class="flex justify-center items-center py-20">
            <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
            <p class="mr-3 rtl:ml-3 rtl:mr-0 text-gray-600">{{ t("loading") }}</p>
        </div> -->

         <!-- <div v-if="isHomeLoading" class="flex justify-center items-center py-20">
                <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
            </div> -->

        <!-- Error State -->
        <div v-if="error" class="text-center py-20">
            <p class="text-red-600 mb-4">{{ error }}</p>
            <button @click="retry" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700">
                {{ t("retry") }}
            </button>

        </div>

        <!-- Empty State -->
        <div v-else-if="!seedsProducts.length" class="text-center py-20">
            <p class="text-gray-600">{{ t("no_products_found") }}</p>
        </div>

        <!-- Carousel Container -->
        <div v-else class="relative">
            <!-- Navigation Buttons -->
            <button @click="prev"
                class="absolute top-1/2 -translate-y-1/2 z-20 bg-white/95 hover:bg-white shadow-lg hover:shadow-xl rounded-full p-3 transition-all duration-200 hover:scale-110 hidden md:flex items-center justify-center"
                :class="[currentDirection === 'rtl' ? 'right-4' : 'left-4']">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                        :d="currentDirection === 'rtl' ? 'M9 5l7 7-7 7' : 'M15 19l-7-7 7-7'" />
                </svg>
            </button>

            <!-- Carousel Track -->
            <div ref="carouselRef" class="overflow-hidden">
                <div class="flex transition-transform duration-500 ease-out" :style="getTransformStyle()">
                    <div v-for="(product, index) in displayItems" :key="`${product.id}-${index}`" class="flex-none px-2 md:px-3"

                        :style="{ width: `${cardWidth}px` }">
                        <div
                            class="bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 overflow-hidden group h-full">
                            <!-- Image Area -->
                            <div class="w-full aspect-square bg-gradient-to-br from-green-100 to-emerald-100 relative overflow-hidden">
                            <img
                                v-if="product.image"
                                :src="getProductImage(product.image)"
                                :width="280"
                                :height="280"
                                :alt="product.title"
                                class="w-full h-full object-cover  transition-transform duration-500 group-hover:scale-110"
                                loading="lazy"
                                decoding="async"
                                style="aspect-ratio: 1 / 1;"
                            />

                                <!-- <img v-if="product.image" :src="getProductImage(product.image)" :alt="product.title"
                                    class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" /> -->
                                <div v-else class="w-full h-full flex items-center justify-center">
                                    <div
                                        class="text-7xl md:text-8xl transition-transform duration-300 group-hover:scale-110">
                                        {{ getCategoryIcon(product.category_id) }}
                                    </div>
                                </div>

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
                            </div>

                            <!-- Content -->
                            <div class="p-5 text-center">
                                <h3 class="text-lg md:text-xl font-semibold text-gray-800 mb-2 line-clamp-2">
                                {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}

                                </h3>

                                <!-- Unit Info -->
                                <p class="text-sm text-gray-500 mb-2">
                                    {{ getUnitLabel(product.unit) }}
                                </p>

                                <!-- Price -->
                                <div class="flex items-center justify-center gap-3 mb-4">
                                    <span v-if="product.sale_price" class="text-xl font-bold text-green-700">
                                        {{ formatPrice(product.sale_price) }}
                                    </span>
                                    <span v-if="product.sale_price" class="text-sm text-gray-500 line-through">
                                        {{ formatPrice(product.price) }}
                                    </span>
                                    <span v-else class="text-xl font-bold text-green-700">
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

                                <!-- Add to Cart Section - Unit-aware -->
                                <div class="mt-auto">
                                    <div v-if="!isInStock(product)">
                                        <button disabled
                                            class="w-full bg-gray-300 text-gray-500 font-medium py-3 rounded-xl cursor-not-allowed">
                                            {{ t("unavailable") }}
                                        </button>
                                    </div>

                                    <!-- Not in cart - Show Add button -->
                                    <button v-else-if="!isInCart(product)" @click="addToCart(product)"
                                        :disabled="isAddingToCart(product.id)"
                                        class="w-full bg-green-600 hover:bg-green-700 active:bg-green-800 text-white font-medium py-3 rounded-xl transition-all duration-200 hover:shadow-lg transform active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2">
                                        <svg v-if="isAddingToCart(product.id)" class="animate-spin h-5 w-5"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                                stroke-width="4"></circle>
                                            <path class="opacity-75" fill="currentColor"
                                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                                            </path>
                                        </svg>
                                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor"
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
                                            " class="px-4 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                            −
                                        </button>

                                        <div class="flex-1 text-center py-2 bg-green-50/30 font-semibold relative">
                                            <span v-if="isUpdatingQuantity(product.id)"
                                                class="absolute inset-0 flex items-center justify-center bg-white bg-opacity-75">
                                                <div
                                                    class="animate-spin rounded-full h-5 w-5 border-2 border-green-500 border-t-transparent">
                                                </div>
                                            </span>
                                            <span :class="{ 'opacity-0': isUpdatingQuantity(product.id) }">
                                                {{ formatQuantity(product) }}
                                            </span>
                                        </div>

                                        <button @click="incrementQuantity(product)" :disabled="isUpdatingQuantity(product.id) || !canIncrement(product)
                                            " class="px-4 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
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
                :class="[currentDirection === 'rtl' ? 'left-4' : 'right-4']">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                        :d="currentDirection === 'rtl' ? 'M15 19l-7-7 7-7' : 'M9 5l7 7-7 7'" />
                </svg>
            </button>
        </div>

        <!-- Pagination Dots -->
        <div v-if="seedsProducts.length" class="flex justify-center gap-2 mt-8" :dir="currentDirection">
            <button v-for="(_, idx) in seedsProducts" :key="idx" @click="goToSlide(idx)"
                class="h-2.5 rounded-full transition-all duration-300" :class="[
                    getCurrentSlideIndex() === idx
                        ? 'w-8 bg-green-600'
                        : 'w-2.5 bg-gray-300 hover:bg-gray-400'
                ]" />
        </div>

        <!-- Why Constituent Bazar Section -->
        <div class="mt-16 text-center">
            <div class="bg-linear-to-l from-transparent to-yellow-500 rounded-3xl p-8 md:p-12">
                <h3 class="text-2xl md:text-3xl font-bold text-green-800 mb-8">
                    {{ t('why_constituent_bazar') }}
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
                    <div v-for="feature in features" :key="feature.key"
                        class="flex flex-col items-center group cursor-pointer">
                        <div
                            class="w-14 h-14 bg-green-100 rounded-2xl flex items-center justify-center group-hover:bg-green-200 transition-colors duration-300">
                            <svg class="w-7 h-7 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    :d="feature.icon" />
                            </svg>
                        </div>
                        <p class="text-gray-700 mt-4 text-base font-medium">
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
const seedsProducts = computed(() => props.seedsProducts)
const store = useStore()
const toast = useToast()
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/"



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
const isInfinite = ref(true)
const addingToCart = ref(new Set())
const localUpdatingItems = ref(new Set())

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

// Get display value from grams based on product unit
const getDisplayValueFromGrams = (product, grams) => {
    const unit = product.unit || 'piece'
    const config = getUnitConfig(unit)

    // For piece/pack units, treat grams as quantity directly
    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return config.formatValue(grams)
    }

    // For weight/volume units, convert grams to the unit
    if (unit === 'kg') {
        return config.formatValue(grams / 1000)
    }
    if (unit === 'g') {
        return config.formatValue(grams)
    }
    if (unit === 'liter') {
        return config.formatValue(grams / 1000)
    }

    return config.formatValue(grams)
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

// Features
const features = [
    { key: 'premium_quality', icon: 'M5 13l4 4L19 7' },
    { key: 'fast_delivery', icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' },
    { key: 'satisfaction', icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' }
]

// Computed from Store
// const seedsProducts = computed(() => store.state.homeSeedsProducts || [])
// const isLoading = computed(() => store.state.homeSeedsLoading || false)
// const error = computed(() => store.state.homeSeedsError || null)
const isHomeLoading = computed(() => store.state.isHomeLoading);
const homeError = computed(() => store.state.homeError || null)

// Cart related
const cartItems = computed(() => store.getters.cartItems || [])
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false)

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

// const getProductImage = (imagePath) => {
//     if (!imagePath) return null
//     if (imagePath.startsWith('http')) return imagePath
//     return `${storageBase}/${imagePath}`
// }

const getProductImage = (imagePath) => {
    if (!imagePath) return "/images/placeholder.jpg";
    if (imagePath.startsWith("http")) return imagePath;
    return `${storageBase}/${imagePath}`;
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

    // For piece, pack, bunch - stock is already in units
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

// Carousel computed
const totalSlides = computed(() => seedsProducts.value.length)

const displayItems = computed(() =>
    isInfinite.value && seedsProducts.value.length > 0
        ? [...seedsProducts.value, ...seedsProducts.value, ...seedsProducts.value]
        : seedsProducts.value
)

const getTransformStyle = () => {
    const translate = currentIndex.value * cardWidth.value
    return currentDirection.value === 'rtl'
        ? { transform: `translateX(${translate}px)` }
        : { transform: `translateX(-${translate}px)` }
}

const getCurrentSlideIndex = () =>
    isInfinite.value ? currentIndex.value % totalSlides.value : currentIndex.value

// Navigation
const next = () => {
    if (!seedsProducts.value.length) return
    let newIndex = currentIndex.value + 1

    if (isInfinite.value && newIndex >= displayItems.value.length - totalSlides.value + 1) {
        setTimeout(() => resetToStart(), 500)
    }

    currentIndex.value = newIndex
}

const prev = () => {
    if (!seedsProducts.value.length) return
    let newIndex = currentIndex.value - 1

    if (isInfinite.value && newIndex < totalSlides.value) {
        setTimeout(() => resetToEnd(), 500)
    }

    currentIndex.value = newIndex
}

const resetToStart = () => {
    if (!carouselRef.value) return
    const track = carouselRef.value.querySelector('.flex')
    if (!track) return

    track.style.transition = 'none'
    const resetIndex = totalSlides.value
    const translate = currentDirection.value === 'rtl'
        ? resetIndex * cardWidth.value
        : -(resetIndex * cardWidth.value)

    track.style.transform = `translateX(${translate}px)`
    currentIndex.value = resetIndex
    track.offsetHeight
    track.style.transition = 'transform 0.5s ease-out'
}

const resetToEnd = () => {
    if (!carouselRef.value) return
    const track = carouselRef.value.querySelector('.flex')
    if (!track) return

    track.style.transition = 'none'
    const resetIndex = displayItems.value.length - (totalSlides.value * 2)
    const translate = currentDirection.value === 'rtl'
        ? resetIndex * cardWidth.value
        : -(resetIndex * cardWidth.value)

    track.style.transform = `translateX(${translate}px)`
    currentIndex.value = resetIndex
    track.offsetHeight
    track.style.transition = 'transform 0.5s ease-out'
}

const goToSlide = (index) => {
    currentIndex.value = isInfinite.value ? index + totalSlides.value : index
}

// Autoplay
const startAutoplay = () => {
    if (autoplayInterval) clearInterval(autoplayInterval)
    autoplayInterval = setInterval(() => next(), 6000)
}

// API Calls
// const getSeedsProducts = () => {
//     store.dispatch('getHomeSeedsProducts')
// }

const fetchCart = async () => {
    try {
        await store.dispatch('fetchCart')
    } catch (error) {
        console.error('Failed to fetch cart:', error)
    }
}

// Add to Cart - Adds 1 piece/pack ONLY
const addToCart = async (product) => {
    if (!isInStock(product)) {
        showToast(t('out_of_stock'), 'error')
        return
    }

    addingToCart.value.add(product.id)

    try {
        const unit = product.unit || 'piece'
        const config = getUnitConfig(unit)
        const quantity = config.min // 1 piece/pack
        const quantityInGrams = convertToGrams(product, quantity)

        const response = await store.dispatch('addItem', {
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



const getCartItem = (product) => {
  // Use the new getter
  return store.getters.getCartItemByProductId(product.id);
};

// Update getCurrentQuantityInUnit to use quantity_value
const getCurrentQuantityInUnit = (product) => {
  const cartItem = getCartItem(product);
  if (!cartItem) return 0;

  // Use quantity_value if available (pre-calculated by backend)
  if (cartItem.quantity_value !== undefined) {
    return cartItem.quantity_value;
  }

  // Fallback to manual calculation
  const unit = product.unit || 'piece';
  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    return cartItem.quantity_grams;
  }

  if (unit === 'kg') {
    return cartItem.quantity_grams / 1000;
  }

  return cartItem.quantity_grams;
};

// Update formatQuantity to use quantity_display
const formatQuantity = (product) => {
  const cartItem = getCartItem(product);
  if (!cartItem) return '0';

  // Use quantity_display if available (pre-formatted by backend)
  if (cartItem.quantity_display) {
    return cartItem.quantity_display;
  }

  // Fallback to manual formatting
  return getDisplayValueFromGrams(product, cartItem.quantity_grams);
};
const updateQuantity = async (itemId, productId, quantityInGrams) => {
  if (!itemId) {
    console.error('No item ID provided for update');
    showToast('حدث خطأ: معرف المنتج غير موجود', 'error');
    return;
  }

  if (!productId) {
    console.error('No product ID provided for update');
    showToast('حدث خطأ: معرف المنتج غير موجود', 'error');
    return;
  }

  localUpdatingItems.value.add(itemId);
  console.log('Updating quantity:', { itemId, productId, quantityInGrams });

  try {
    // Make sure we're passing the correct parameters to the store action
    const response = await store.dispatch('updateQuantity', {
      itemId: itemId,        // The cart item ID
      quantityGrams: Math.round(quantityInGrams)  // The quantity in grams/pieces
    });

    console.log('Update quantity response:', response);

    // Refresh cart to ensure we have the latest data
    await fetchCart();
  } catch (error) {
    console.error('Update quantity error:', error);
    const errorMessage = error.response?.data?.message || error.message || t('update_error');
    showToast(errorMessage, 'error');
    throw error;
  } finally {
    localUpdatingItems.value.delete(itemId);
  }
};



const incrementQuantity = async (product) => {
  const cartItem = getCartItem(product);
  if (!cartItem) {
    console.error('No cart item found for product:', product.id);
    showToast('المنتج غير موجود في السلة', 'error');
    return;
  }

  console.log('Increment quantity for product:', {
    productId: product.id,
    cartItemId: cartItem.id,
    currentQuantity: cartItem.quantity_grams
  });

  const step = getStepValue(product);
  const currentVal = getCurrentQuantityInUnit(product);
  const maxVal = getMaxStockInUnit(product);

  if (currentVal >= maxVal) {
    showToast(t('max_quantity_reached'), 'warning');
    return;
  }

  const newVal = Math.min(currentVal + step, maxVal);
  if (newVal === currentVal) return;

  const newQuantityInGrams = convertToGrams(product, newVal);

  // Call updateQuantity with all three parameters
  await updateQuantity(cartItem.id, product.id, newQuantityInGrams);
};

//  decrement function
const decrementQuantity = async (product) => {
  const cartItem = getCartItem(product);
  if (!cartItem) {
    console.error('No cart item found for product:', product.id);
    showToast('المنتج غير موجود في السلة', 'error');
    return;
  }

  console.log('Decrement quantity for product:', {
    productId: product.id,
    cartItemId: cartItem.id,
    currentQuantity: cartItem.quantity_grams
  });

  const step = getStepValue(product);
  const currentVal = getCurrentQuantityInUnit(product);
  const minVal = getMinValue(product);

  if (currentVal <= minVal) {
    showToast(t('min_quantity_reached'), 'warning');
    return;
  }

  const newVal = Math.max(currentVal - step, minVal);
  if (newVal === currentVal) return;

  const newQuantityInGrams = convertToGrams(product, newVal);

  // Call updateQuantity with all three parameters
  await updateQuantity(cartItem.id, product.id, newQuantityInGrams);
};

// Responsive Card Width
const updateCardWidth = () => {
    const width = window.innerWidth
    if (width < 480) {
        cardWidth.value = 320  // Was 260 - wider for very small screens
    } else if (width < 640) {
        cardWidth.value = 340  // Was 260 - wider for mobile
    } else if (width < 768) {
        cardWidth.value = 320  // Was 240 - wider for tablets portrait
    } else if (width < 1024) {
        cardWidth.value = 350  // Was 235 - wider for tablets landscape
    } else if (width < 1280) {
        cardWidth.value = 320  // Was 240 - wider for small desktops
    } else if (width < 1536) {
        cardWidth.value = 320  // New - for medium desktops
    } else {
        cardWidth.value = 320  // Was 230 - wider for large desktops
    }
}
const handleResize = () => {
    const oldWidth = cardWidth.value
    updateCardWidth()
    if (Math.abs(oldWidth - cardWidth.value) > 10 && isInfinite.value && totalSlides.value > 0) {
        nextTick(() => {
            currentIndex.value = totalSlides.value
        })
    }
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
    if (isInfinite.value && totalSlides.value > 0) {
        currentIndex.value = totalSlides.value
    }
})

watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart()
    }
})

// Lifecycle
onMounted(() => {
    fetchCart()

    updateCardWidth()
    window.addEventListener('resize', handleResize)
    // getSeedsProducts()

    nextTick(() => {
        if (isInfinite.value && carouselRef.value && totalSlides.value > 0) {
            const track = carouselRef.value.querySelector('.flex')
            if (track) {
                const translate = currentDirection.value === 'rtl'
                    ? totalSlides.value * cardWidth.value
                    : -(totalSlides.value * cardWidth.value)
                track.style.transform = `translateX(${translate}px)`
                currentIndex.value = totalSlides.value
            }
        }
        startAutoplay()
    })
})

onBeforeUnmount(() => {
    if (autoplayInterval) {
        clearInterval(autoplayInterval);
        autoplayInterval = null;
    }
    window.removeEventListener('resize', handleResize);
});
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



/* Better text readability for wider cards */
@media (min-width: 1024px) {
    .p-6 {
        padding: 1.75rem;
    }

    .text-lg {
        font-size: 1.125rem;
        line-height: 1.5rem;
    }
}

/* Adjust navigation button positions for wider cards */
@media (min-width: 768px) {
    .carousel-container {
        padding-left: 2rem;
        padding-right: 2rem;
    }
}

@media (max-width: 640px) {
    .px-4 {
        padding-left: 1rem;
        padding-right: 1rem;
    }
}
</style>
