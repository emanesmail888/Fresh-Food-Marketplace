<template>
    <HomeLayout>

        <div class="w-full mx-auto px-4 py-8" :dir="currentDirection">
            <!-- Header -->
            <div class="text-center mb-8">
                <h2 class="text-3xl md:text-4xl font-bold text-yellow-800">
                    {{ t('plants_shop') }}
                </h2>
                <p class="text-gray-600 mt-3 text-base md:text-lg max-w-2xl mx-auto">
                    {{ t('discover_plants') }}
                </p>
            </div>

            <!-- Filters Bar -->
            <div class="bg-white rounded-xl shadow-sm p-4 mb-8">
                <div class="flex flex-col md:flex-row justify-between items-center gap-4">
                    <!-- Left Section - Per Page and Results -->
                    <div class="flex flex-wrap items-center gap-3">
                        <div class="flex items-center gap-2">
                            <span class="text-gray-700 whitespace-nowrap">{{ t("show") }}:</span>
                            <select v-model="perPage" @change="resetAndFetch"
                                class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent bg-white">
                                <option :value="12">12</option>
                                <option :value="24">24</option>
                                <option :value="48">48</option>
                            </select>
                        </div>
                        <!-- <div class="text-gray-600 text-sm">
            <span class="font-medium">{{ pagination.from }}-{{ pagination.to }}</span> {{ t("of") }} {{ pagination.total }} {{ t("products") }}
          </div> -->

                        <div class="text-gray-600 text-sm">
                            <span class="font-medium">
                                {{ getFirstValue(pagination.from) }}-{{ getFirstValue(pagination.to) }}
                            </span>
                            {{ t("of") }}
                            {{ getFirstValue(pagination.total) }}
                            {{ t("products") }}
                        </div>
                    </div>

                    <!-- Right Section - Sort and Search -->
                    <div class="flex flex-wrap items-center justify-around gap-4">
                        <!-- Sort Options -->
                        <div class="flex items-center gap-2">
                            <span class="text-gray-700 whitespace-nowrap">{{ t("sort_by") }}:</span>
                            <div class="flex gap-2">
                                <button @click="setSort('created_at')"
                                    class="px-4 py-2 rounded-lg border transition-all duration-200 text-sm font-medium"
                                    :class="[
                                        sortField === 'created_at'
                                            ? 'bg-green-600 text-white border-green-600'
                                            : 'bg-white text-gray-700 border-gray-300 hover:border-green-500'
                                    ]">
                                    {{ t("newest") }}
                                    <span v-if="sortField === 'created_at'" class="ml-1">
                                        {{ sortDirection === 'desc' ? '↓' : '↑' }}
                                    </span>
                                </button>
                                <button @click="setSort('price')"
                                    class="px-4 py-2 rounded-lg border transition-all duration-200 text-sm font-medium"
                                    :class="[
                                        sortField === 'price'
                                            ? 'bg-green-600 text-white border-green-600'
                                            : 'bg-white text-gray-700 border-gray-300 hover:border-green-500'
                                    ]">
                                    {{ t("price") }}
                                    <span v-if="sortField === 'price'" class="ml-1">
                                        {{ sortDirection === 'asc' ? '↑' : '↓' }}
                                    </span>
                                </button>
                            </div>
                        </div>

                        <!-- Search -->
                        <div class="relative w-full md:w-72">
                            <input v-model="searchQuery" @input="debouncedSearch" type="text"
                                :placeholder="t('search_products')"
                                class="w-full px-4 py-2 pl-10 border border-gray-300  rounded-lg focus:outline-0 focus:ring-2 focus:ring-green-500 active:border-green-500" />
                            <svg class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" fill="none" stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Loading State -->
            <!-- <div v-if="isLoading" class="flex justify-center items-center py-20">
                <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
                <p class="mr-3 rtl:ml-3 rtl:mr-0 text-gray-600">{{ t("loading") }}</p>
            </div> -->
            <div v-if="isLoading" class="loading-state">
                <div class="spinner"></div>
                <p>{{ t('loading') }}</p>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="text-center py-20">
                <p class="text-red-600 mb-4">{{ error }}</p>
                <button @click="fetchProducts" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700">
                    {{ t("retry") }}
                </button>
            </div>

            <!-- Products Grid -->
            <div v-else-if="products.length > 0"
                class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 lg:px-30 sm:px-20">
                <div v-for="product in products" :key="product.id"
                    class="bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 overflow-hidden group h-full flex flex-col">
                    <!-- Image Area -->
                    <div
                        class="w-full aspect-square bg-linear-to-br from-green-100 to-emerald-100 relative overflow-hidden">
                        <img v-if="product.image" :src="getProductImage(product.image)" :alt="product.title"
                            class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
                        <div v-else class="w-full h-full flex items-center justify-center">
                            <div class="text-7xl md:text-8xl transition-transform duration-300 group-hover:scale-110">
                                {{ getCategoryIcon(product.category_id) }}
                            </div>
                        </div>

                        <!-- Discount Badge -->
                        <div v-if="getDiscount(product.price, product.sale_price)"
                            class="absolute top-3 z-10 bg-red-500 text-white text-sm font-bold px-3 py-1.5 rounded-full shadow-sm"
                            :class="currentLanguage === 'ar' ? 'right-3' : 'left-3'">
                            -{{ getDiscount(product.price, product.sale_price) }}%
                        </div>

                        <!-- New Arrival Badge -->
                        <div v-if="product.new_arrival"
                            class="absolute top-3 z-10 bg-green-500 text-white text-sm font-bold px-3 py-1.5 rounded-full shadow-sm"
                            :class="currentLanguage === 'ar' ? 'left-3' : 'right-3'">
                            {{ t("new") }}
                        </div>

                        <!-- Out of Stock Overlay -->
                        <div v-if="!isInStock(product)"
                            class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                            <span class="text-white font-bold text-lg">{{ t("out_of_stock") }}</span>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="p-5 text-center flex-1 flex flex-col">
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
                            <!-- <button
              v-else-if="!isInCart(product)"
              @click="addToCart(product)"
              :disabled="isAddingToCart(product.id)"
              class="w-full bg-green-600 hover:bg-green-700 active:bg-green-800 text-white font-medium py-3 rounded-xl transition-all duration-200 hover:shadow-lg transform active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <svg v-if="isAddingToCart(product.id)" class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6M17 13l1.5 6M9 21h6M12 21v-8"></path>
              </svg>
              <span>{{ t("add_to_cart") }}</span>
            </button> -->
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
                                <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6M17 13l1.5 6M9 21h6M12 21v-8">
                                    </path>
                                </svg>
                                <span>{{ t("add_to_cart") }}</span>
                            </button>
                            <!-- In cart - Show quantity controls -->
                            <div v-else
                                class="quantity-control flex items-center border-2 border-green-600 rounded-xl overflow-hidden bg-white">
                                <button @click="decrementQuantity(product)"
                                    :disabled="isUpdatingQuantity(product.id) || !canDecrement(product)"
                                    class="px-4 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
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

                                <button @click="incrementQuantity(product)"
                                    :disabled="isUpdatingQuantity(product.id) || !canIncrement(product)"
                                    class="px-4 py-2 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                    +
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else-if="!isLoading && products.length === 0" class="text-center py-20">
                <div class="text-6xl mb-4">🌱</div>
                <p class="text-gray-600">{{ t("no_products_found") }}</p>
                <p class="text-gray-400 text-sm mt-2">{{ t("try_adjusting_filters") }}</p>
            </div>

            <!-- Pagination -->
            <div v-if="pagination.last_page > 1" class="mt-12">
                <div class="flex justify-center items-center gap-2 flex-wrap">
                    <button @click="changePage(pagination.current_page - 1)" :disabled="pagination.current_page === 1"
                        class="px-4 py-2 rounded-lg border border-gray-300 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50 transition-colors">
                        {{ t("previous") }}
                    </button>

                    <div class="flex gap-1">
                        <button v-for="page in visiblePages" :key="page" @click="changePage(page)" :class="[
                            'px-4 py-2 rounded-lg transition-colors min-w-10',
                            page === pagination.current_page
                                ? 'bg-green-600 text-white'
                                : 'border border-gray-300 hover:bg-gray-50'
                        ]">
                            <span v-if="page === '...'">...</span>
                            <span v-else>{{ page }}</span>
                        </button>
                    </div>

                    <button @click="changePage(pagination.current_page + 1)"
                        :disabled="pagination.current_page === pagination.last_page"
                        class="px-4 py-2 rounded-lg border border-gray-300 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50 transition-colors">
                        {{ t("next") }}
                    </button>
                </div>

                <!-- Page Info -->
                <div class="text-center text-gray-500 text-sm mt-4">
                    {{ t("showing") }} {{ pagination.from }}-{{ pagination.to }} {{ t("of") }} {{ pagination.total }} {{
                        t("products") }}
                </div>
            </div>
        </div>
    </HomeLayout>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useStore } from 'vuex'
import { useToast } from 'vue-toastification'
import { useLanguage } from '../composables/useLanguage.js'
import HomeLayout from '../components/HomeLayout.vue';
import {
    getSessionData,
    setSessionData,
    hasValidSessionData,
    SessionStorageKeys
} from '../utils/sessionStorage.js';

const store = useStore()
const toast = useToast()
const storageBase = import.meta.env.VITE_STORAGE_URL 

const {
    currentLanguage,
    currentDirection,
    t,
    formatPrice
} = useLanguage()

// ============ Constants ============
const EXPIRY_30_MINUTES = 1800; // 30 minutes in seconds

// ============ State ============
const perPage = ref(12)
const currentPage = ref(1)
const searchQuery = ref("")
const sortField = ref("created_at")
const sortDirection = ref("desc")
const addingToCart = ref(new Set())
const localUpdatingItems = ref(new Set())
const isLoading = ref(true)

// ============ Unit Configuration ============
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

// Category Icons Mapping
const categoryIcons = {
    1: '🥬', // Vegetables
    2: '🌸', // Flowers
    3: '🍎', // Fruits
    4: '🌿', // Herbs
    5: '🌱', // Microgreens
    6: '🧅'  // Bulbs
}

// ============ Computed ============
const products = computed(() => store.state.shopProducts?.data || [])
const storeLoading = computed(() => store.state.shopProducts?.loading || false)
const error = computed(() => store.state.shopProducts?.error || null)

const pagination = computed(() => ({
    current_page: store.state.shopProducts?.current_page || 1,
    last_page: store.state.shopProducts?.last_page || 1,
    total: store.state.shopProducts?.total || 0,
    from: store.state.shopProducts?.from || 0,
    to: store.state.shopProducts?.to || 0,
    per_page: store.state.shopProducts?.per_page || 12,
}))

// Cart related
const cartItems = computed(() => store.getters.cartItems || [])
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false)

// ============ Helper Functions ============
const getUnitConfig = (unit) => {
    return UNIT_CONFIG[unit] || UNIT_CONFIG.piece
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

const getCategoryIcon = (categoryId) => {
    return categoryIcons[categoryId] || '🌱'
}

const getProductImage = (imagePath) => {
    if (!imagePath) return null
    if (imagePath.startsWith('http')) return imagePath
    return `${storageBase}/${imagePath}`
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
    const unit = product.unit
    const config = getUnitConfig(unit)
    return config.step
}

const getMinValue = (product) => {
    const unit = product.unit
    const config = getUnitConfig(unit)
    return config.min
}

const isAddingToCart = (productId) => {
    return addingToCart.value.has(productId)
}

const isInCart = (product) => {
    return cartItems.value.some(item => item.product_id === product.id)
}

const isUpdatingQuantity = (productId) => {
    const item = getCartItem({ id: productId })
    if (!item) return false

    const isStoreUpdating = typeof store.getters.isUpdating === 'function'
        ? store.getters.isUpdating(item.id)
        : false

    return isStoreUpdating || localUpdatingItems.value.has(item.id)
}

const getDisplayValueFromGrams = (product, grams) => {
    const unit = product.unit || 'piece'
    const config = getUnitConfig(unit)

    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return config.formatValue(grams)
    }

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

const convertToGrams = (product, quantity) => {
    const unit = product.unit || 'piece'

    switch (unit) {
        case 'kg':
            return Math.round(quantity * 1000)
        case 'liter':
            return Math.round(quantity * 1000)
        case 'g':
            return Math.round(quantity)
        case 'piece':
        case 'pack':
        case 'bunch':
            return Math.round(quantity)
        default:
            return Math.round(quantity * 1000)
    }
}

const getCurrentQuantityInUnit = (product) => {
    const cartItem = getCartItem(product)
    if (!cartItem) return 0

    if (cartItem.quantity_value !== undefined) {
        return cartItem.quantity_value
    }

    const unit = product.unit || 'piece'
    const grams = cartItem.quantity_grams

    if (unit === 'kg') {
        return grams / 1000
    }
    if (unit === 'liter') {
        return grams / 1000
    }
    if (unit === 'g') {
        return grams
    }
    return grams
}

// ============ Pagination ============
const visiblePages = computed(() => {
    const delta = 2
    const range = []
    const rangeWithDots = []
    let l
    const lastPage = pagination.value.last_page
    const currentPageVal = pagination.value.current_page

    if (lastPage <= 1) return []

    for (let i = 1; i <= lastPage; i++) {
        if (i === 1 || i === lastPage || (i >= currentPageVal - delta && i <= currentPageVal + delta)) {
            range.push(i)
        }
    }

    range.forEach((i) => {
        if (l) {
            if (i - l === 2) rangeWithDots.push(l + 1)
            else if (i - l !== 1) rangeWithDots.push('...')
        }
        rangeWithDots.push(i)
        l = i
    })

    return rangeWithDots
})

// ============ Session Storage Functions ============

// Save shop products to session storage
const saveToSession = (data) => {
    try {
        const shopData = {
            data: data.data || [],
            current_page: data.current_page || 1,
            last_page: data.last_page || 1,
            per_page: data.per_page || 12,
            total: data.total || 0,
            from: data.from || 0,
            to: data.to || 0,
        };
        setSessionData(SessionStorageKeys.SHOP_PRODUCTS, shopData, EXPIRY_30_MINUTES);
        // console.log('✅ Shop products saved to session storage');
        return true;
    } catch (error) {
        console.error('Failed to save shop products to session:', error);
        return false;
    }
};

// Restore shop products from session storage
const restoreFromSession = () => {
    try {
        const shopData = getSessionData(SessionStorageKeys.SHOP_PRODUCTS);
        if (shopData) {
            store.commit('SET_SHOP_PRODUCTS', shopData);
            // console.log('✅ Shop products restored from session storage');
            return true;
        }
        return false;
    } catch (error) {
        console.error('Failed to restore shop products from session:', error);
        return false;
    }
};

// ============ API Calls ============

// ✅ Updated fetchProducts with proper session handling
const fetchProducts = async () => {
    try {
        // Check if we have valid session data
        const hasSession = hasValidSessionData(SessionStorageKeys.SHOP_PRODUCTS);

        if (hasSession) {
            // ✅ Restore from session
            const shopData = getSessionData(SessionStorageKeys.SHOP_PRODUCTS);
            if (shopData) {
                store.commit('SET_SHOP_PRODUCTS', shopData);
                isLoading.value = false;
                // console.log('✅ Shop data loaded from session');
                // console.log(`📊 Products: ${shopData.data?.length || 0}, Page: ${shopData.current_page}/${shopData.last_page}`);

                // 🔄 Refresh in background with current filters
                try {
                    await store.dispatch("getShopProducts", {
                        page: currentPage.value,
                        per_page: perPage.value,
                        search: searchQuery.value,
                        sort_field: sortField.value,
                        sort_direction: sortDirection.value
                    });

                    // Save fresh data to session
                    const freshData = {
                        data: store.state.shopProducts?.data || [],
                        current_page: store.state.shopProducts?.current_page || 1,
                        last_page: store.state.shopProducts?.last_page || 1,
                        per_page: store.state.shopProducts?.per_page || 12,
                        total: store.state.shopProducts?.total || 0,
                        from: store.state.shopProducts?.from || 0,
                        to: store.state.shopProducts?.to || 0,
                    };
                    saveToSession(freshData);
                    // console.log('🔄 Background refresh completed');
                } catch (err) {
                    console.warn('Background refresh failed, using cached data:', err);
                }
            }
        } else {
            // ❌ No session data, fetch from API
            // console.log('⏳ No session data, fetching from API...');
            isLoading.value = true;

            await store.dispatch("getShopProducts", {
                page: currentPage.value,
                per_page: perPage.value,
                search: searchQuery.value,
                sort_field: sortField.value,
                sort_direction: sortDirection.value
            });

            // Save to session after successful fetch
            const freshData = {
                data: store.state.shopProducts?.data || [],
                current_page: store.state.shopProducts?.current_page || 1,
                last_page: store.state.shopProducts?.last_page || 1,
                per_page: store.state.shopProducts?.per_page || 12,
                total: store.state.shopProducts?.total || 0,
                from: store.state.shopProducts?.from || 0,
                to: store.state.shopProducts?.to || 0,
            };
            saveToSession(freshData);
            isLoading.value = false;
            console.log('✅ Data fetched and saved to session');
        }
    } catch (error) {
        console.error("Error fetching products:", error);
        isLoading.value = false;

        // If error occurs, try to use session data as fallback
        const fallbackData = getSessionData(SessionStorageKeys.SHOP_PRODUCTS);
        if (fallbackData) {
            console.log('⚠️ Using fallback session data due to error');
            store.commit('SET_SHOP_PRODUCTS', fallbackData);
            showToast('Using cached data due to connection error', 'warning');
        }
    }
};

const fetchCart = async () => {
    try {
        await store.dispatch('fetchCart')
    } catch (error) {
        console.error('Failed to fetch cart:', error)
    }
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

const getCartItem = (product) => {
    return store.getters.getCartItemByProductId(product.id);
};

const formatQuantity = (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) return '0';

    if (cartItem.quantity_display) {
        return cartItem.quantity_display;
    }

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

    try {
        await store.dispatch('updateQuantity', {
            itemId: itemId,
            quantityGrams: Math.round(quantityInGrams)
        });

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
    await updateQuantity(cartItem.id, product.id, newQuantityInGrams);
};

const decrementQuantity = async (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) {
        console.error('No cart item found for product:', product.id);
        showToast('المنتج غير موجود في السلة', 'error');
        return;
    }

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
    await updateQuantity(cartItem.id, product.id, newQuantityInGrams);
};

const resetAndFetch = () => {
    currentPage.value = 1
    fetchProducts()
}

const setSort = (field) => {
    if (sortField.value === field) {
        sortDirection.value = sortDirection.value === "asc" ? "desc" : "asc"
    } else {
        sortField.value = field
        sortDirection.value = field === "created_at" ? "desc" : "asc"
    }
    resetAndFetch()
}

const debouncedSearch = () => {
    resetAndFetch()
};

const changePage = (page) => {
    if (page >= 1 && page <= pagination.value.last_page && page !== pagination.value.current_page) {
        currentPage.value = page
        fetchProducts()
        window.scrollTo({ top: 0, behavior: "smooth" })
    }
}


// Helper function to get first value from array or return value
const getFirstValue = (value) => {
    if (Array.isArray(value)) {
        return value[0] || 0
    }
    return value || 0
}
// ============ Toast Helper ============
const showToast = (message, type = 'success') => {
    if (toast) {
        toast[type](message, {
            timeout: 3000,
            position: currentLanguage.value === 'ar' ? 'top-left' : 'top-right'
        })
    }
}

// ============ Watchers ============
watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart()
    }
})

// ============ Lifecycle ============
onMounted(() => {
    // Load products (will use session if available)
    fetchProducts();

    // Always fetch cart
    fetchCart();
})

onBeforeUnmount(() => {
    // Clean up any subscriptions if needed
})
</script>
<style scoped>
/* ===== LOADING ===== */
.loading-state {
    text-align: center;
    padding: 2rem 0;
}

.spinner {
    display: inline-block;
    width: 2.5rem;
    height: 2.5rem;
    border: 3px solid #e5e7eb;
    border-top-color: #148c52;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
    margin-bottom: 0.5rem;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

.loading-state p {
    color: #6b7280;
    margin: 0;
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

/* RTL Support */
[dir="rtl"] .ml-2 {
    margin-left: 0;
    margin-right: 0.5rem;
}

[dir="rtl"] .mr-3 {
    margin-right: 0;
    margin-left: 0.75rem;
}
</style>
