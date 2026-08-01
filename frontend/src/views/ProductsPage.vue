<template>
    <home-layout>
        <div id="products-section" class="products-page min-h-screen bg-gray-50">
            <!-- Category Header -->
            <div class="category-header text-center py-8 bg-white shadow-sm">
                <div class="container mx-auto px-4">
                    <h1 class="text-3xl font-bold text-gray-800 mb-2">
                        {{ categoryName  }}
                    </h1>
                    <p v-if="totalProducts > 0" class="text-gray-600">
                        {{ totalProducts }} {{ t('products_found') || 'products found' }}
                    </p>
                    <p v-else class="text-gray-500">
                        {{ t('no_products') || 'No products in this category' }}
                    </p>
                </div>
            </div>

            <!-- Loading State -->
            <div v-if="loading" class="flex justify-center items-center py-20">
                <div class="animate-spin rounded-full h-12 w-12 border-4 border-yellow-500 border-t-transparent"></div>
            </div>

            <!-- Products Grid -->
            <div v-else-if="products.length > 0" class="container mx-auto px-4 py-8">
                <div
                    class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 md:gap-6">
                    <!-- Product Card -->
                    <div v-for="product in products" :key="product.id"
                        class="product-card bg-white rounded-xl shadow-md hover:shadow-xl transition-all duration-300 overflow-hidden group">
                        <!-- Product Image -->
                        <div class="relative overflow-hidden bg-gray-100 aspect-square">
                            <router-link :to="getProductLink(product)" class="block h-full">

                                <img :src="getProductImage(product.image)"
                                    :alt="currentLanguage === 'ar' ? product.title_ar : product.title"
                                    class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                    loading="lazy" />
                            </router-link>
                            <!-- Sale Badge -->
                            <div v-if="product.sale_price"
                                class="absolute top-2 left-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-full">
                                {{ t('sale') || 'SALE' }}
                            </div>

                            <!-- Out of Stock Overlay -->
                            <div v-if="!isInStock(product)"
                                class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                                <span class="text-white font-bold text-lg">{{ t('out_of_stock') }}</span>
                            </div>

                            <!-- Wishlist Button -->
                            <button @click="toggleWishlist(product)" :disabled="wishlistLoading[product.id]"
                                class="absolute top-2 right-2 bg-white rounded-full p-2 shadow-md hover:bg-gray-100 transition-colors z-10"
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

                        <!-- Product Info -->
                        <div class="p-3 md:p-4">
                            <!-- Product Name -->
                            <h3
                                class="text-sm md:text-base font-semibold text-gray-800 line-clamp-2 min-h-10 md:min-h-12">
                                {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}
                            </h3>

                            <!-- Unit Info -->
                            <p v-if="product.unit" class="text-xs text-gray-500 mt-1">
                                {{ t('per') || 'per' }} {{ getUnitLabel(product.unit) }}
                            </p>

                            <!-- Price -->
                            <div class="mt-2 flex items-center gap-2">
                                <span v-if="product.sale_price" class="text-lg md:text-xl font-bold text-yellow-600">
                                    {{ formatPrice(product.sale_price) }}
                                </span>
                                <span v-if="product.sale_price" class="text-sm text-gray-400 line-through">
                                    {{ formatPrice(product.price) }}
                                </span>
                                <span v-else class="text-lg md:text-xl font-bold text-yellow-600">
                                    {{ formatPrice(product.price) }}
                                </span>
                            </div>

                            <!-- Stock Status -->
                            <p v-if="isLowStock(product)" class="text-xs text-orange-600 mt-1">
                                ⚠️ {{ t("low_stock") }}
                            </p>

                            <!-- Add to Cart Section -->
                            <div class="mt-3">
                                <div v-if="!isInStock(product)">
                                    <button disabled
                                        class="w-full bg-gray-300 text-gray-500 font-medium py-2 rounded-lg cursor-not-allowed text-sm">
                                        {{ t("unavailable") }}
                                    </button>
                                </div>

                                <!-- Not in cart - Show Add button -->
                                <button v-else-if="!isInCart(product)" @click.stop="addToCart(product)"
                                    :disabled="isAddingToCart(product.id)"
                                    class="w-full bg-yellow-500 hover:bg-yellow-600 active:bg-yellow-700 text-white font-medium py-2 rounded-lg transition-all duration-200 hover:shadow-lg transform active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2 text-sm">
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
                                    class="quantity-control flex items-center border-2 border-yellow-500 rounded-lg overflow-hidden bg-white">
                                    <button @click.stop="decrementQuantity(product)" :disabled="isUpdatingQuantity(product.id) ||
                                        !canDecrement(product)
                                        "
                                        class="px-3 py-1.5 text-lg font-bold text-yellow-600 hover:bg-yellow-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                        −
                                    </button>

                                    <div
                                        class="flex-1 text-center py-1.5 bg-yellow-50/30 font-semibold relative min-w-10 text-sm">
                                        <span v-if="isUpdatingQuantity(product.id)"
                                            class="absolute inset-0 flex items-center justify-center bg-white bg-opacity-75">
                                            <div
                                                class="animate-spin rounded-full h-4 w-4 border-2 border-yellow-500 border-t-transparent">
                                            </div>
                                        </span>
                                        <span :class="{ 'opacity-0': isUpdatingQuantity(product.id) }">
                                            {{ formatQuantity(product) }}
                                        </span>
                                    </div>

                                    <button @click.stop="incrementQuantity(product)" :disabled="isUpdatingQuantity(product.id) || !canIncrement(product)
                                        "
                                        class="px-3 py-1.5 text-lg font-bold text-yellow-600 hover:bg-yellow-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                        +
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="flex justify-center items-center py-12 mt-8" id="pagination-section">
                    <nav class="flex items-center gap-1 md:gap-2" aria-label="Pagination">
                        <!-- Previous Button -->
                        <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1"
                            class="px-3 py-2 md:px-4 md:py-2 rounded-lg border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">
                            <span class="sr-only">{{ t('previous') || 'Previous' }}</span>
                            <svg class="w-4 h-4 md:w-5 md:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 19l-7-7 7-7" />
                            </svg>
                        </button>

                        <!-- Page Numbers -->
                        <div class="flex gap-1">
                            <button v-for="page in visiblePages" :key="page"
                                @click="typeof page === 'number' ? changePage(page) : null" :class="[
                                    'px-3 py-2 md:px-4 md:py-2 rounded-lg border transition-colors text-sm md:text-base min-w-10 md:min-w-12',
                                    page === currentPage
                                        ? 'bg-yellow-500 border-yellow-500 text-white font-semibold'
                                        : page === '...'
                                            ? 'bg-transparent border-transparent cursor-default'
                                            : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
                                ]" :disabled="page === '...'">
                                {{ page }}
                            </button>
                        </div>

                        <!-- Next Button -->
                        <button @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages"
                            class="px-3 py-2 md:px-4 md:py-2 rounded-lg border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">
                            <span class="sr-only">{{ t('next') || 'Next' }}</span>
                            <svg class="w-4 h-4 md:w-5 md:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9 5l7 7-7 7" />
                            </svg>
                        </button>
                    </nav>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-20">
                <svg class="w-24 h-24 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                </svg>
                <p class="text-gray-500 text-lg">{{ t('no_products_available') || 'No products available in this category' }}</p>
                <button @click="goBack"
                    class="mt-4 inline-block px-6 py-3 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition-colors">
                    {{ t('browse_categories') || 'Browse Other Categories' }}
                </button>
            </div>
        </div>
    </home-layout>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import axiosClient from '../axios.js';
import { useLanguage } from '../composables/useLanguage';
import HomeLayout from "../components/HomeLayout.vue";

const route = useRoute();
const router = useRouter();
const store = useStore();
const toast = useToast();
const { currentLanguage, t, formatPrice } = useLanguage();

const products = ref([]);
const loading = ref(false);
const totalProducts = ref(0);
const currentPage = ref(1);
const perPage = ref(20);
const totalPages = ref(0);
const categoryName = ref('');
const categoryId = ref(null);
const addingToCart = ref(new Set());
const localUpdatingItems = ref(new Set());
const wishlistLoading = ref({});

const storageBase = import.meta.env.VITE_STORAGE_URL ;

// Unit configuration
const UNIT_CONFIG = {
    piece: { step: 1, min: 1, displayUnit: 'piece', storageUnit: 'pieces', formatValue: (value) => `${Math.round(value)}` },
    pack: { step: 1, min: 1, displayUnit: 'pack', storageUnit: 'packs', formatValue: (value) => `${Math.round(value)}` },
    kg: { step: 0.5, min: 0.5, displayUnit: 'kg', formatValue: (value) => `${value.toFixed(1)}` },
    g: { step: 100, min: 100, displayUnit: 'g', formatValue: (value) => `${Math.round(value)}` },
    liter: { step: 0.5, min: 0.5, displayUnit: 'L', formatValue: (value) => `${value.toFixed(1)}` },
    bunch: { step: 1, min: 1, displayUnit: 'bunch', formatValue: (value) => `${Math.round(value)}` },
};

// Get unit config
const getUnitConfig = (unit) => {
    return UNIT_CONFIG[unit] || UNIT_CONFIG.piece;
};

// Convert to grams
const convertToGrams = (product, quantity) => {
    const unit = product.unit || 'piece';
    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return Math.round(quantity);
    }
    if (unit === 'kg' || unit === 'liter') {
        return Math.round(quantity * 1000);
    }
    return Math.round(quantity);
};

// Get unit label
const getUnitLabel = (unit) => {
    const labels = {
        kg: currentLanguage.value === 'ar' ? 'كجم' : 'kg',
        g: currentLanguage.value === 'ar' ? 'جم' : 'g',
        piece: currentLanguage.value === 'ar' ? 'قطعة' : 'piece',
        liter: currentLanguage.value === 'ar' ? 'لتر' : 'liter',
        pack: currentLanguage.value === 'ar' ? 'حزمة' : 'pack',
        bunch: currentLanguage.value === 'ar' ? 'حزمة' : 'bunch'
    };
    return labels[unit] || labels.piece;
};

// Cart computed
const cartItems = computed(() => store.getters.cartItems || []);
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false);
const wishlistItems = computed(() => {
    const items = store.getters['wishlist/wishlistItems'];
    return Array.isArray(items) ? items : [];
});



// Check if in cart
const isInCart = (product) => {
    return cartItems.value.some(item => item.product_id === product.id);
};

// Stock checks
const isInStock = (product) => {
    return (product.stock || 0) > 0;
};

const isLowStock = (product) => {
    return product.stock > 0 && product.stock <= 2;
};

const getMaxStockInUnit = (product) => {
    const unit = product.unit || 'piece';
    const maxStock = product.stock || 50;
    if (unit === 'kg' || unit === 'liter') {
        return maxStock;
    }
    if (unit === 'g') {
        return maxStock * 1000;
    }
    return maxStock;
};

const getStepValue = (product) => {
    const unit = product.unit || 'piece';
    return getUnitConfig(unit).step;
};

const getMinValue = (product) => {
    const unit = product.unit || 'piece';
    return getUnitConfig(unit).min;
};

const canIncrement = (product) => {
    const currentVal = getCurrentQuantityInUnit(product);
    const maxVal = getMaxStockInUnit(product);
    const step = getStepValue(product);
    return currentVal + step <= maxVal;
};

const canDecrement = (product) => {
    const currentVal = getCurrentQuantityInUnit(product);
    const minVal = getMinValue(product);
    const step = getStepValue(product);
    return currentVal - step >= minVal;
};

const isAddingToCart = (productId) => {
    return addingToCart.value.has(productId);
};

const getCartItem = (product) => {
    return store.getters.getCartItemByProductId(product.id);
};

const getCurrentQuantityInUnit = (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) return 0;
    if (cartItem.quantity_value !== undefined) {
        return cartItem.quantity_value;
    }
    const unit = product.unit || 'piece';
    if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
        return cartItem.quantity_grams;
    }
    if (unit === 'kg' || unit === 'liter') {
        return cartItem.quantity_grams / 1000;
    }
    return cartItem.quantity_grams;
};

const formatQuantity = (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) return '0';
    if (cartItem.quantity_display) {
        return cartItem.quantity_display;
    }
    const unit = product.unit || 'piece';
    const config = getUnitConfig(unit);
    const value = getCurrentQuantityInUnit(product);
    return config.formatValue(value);
};

const isUpdatingQuantity = (productId) => {
    const item = getCartItem({ id: productId });
    if (!item) return false;
    const isStoreUpdating = typeof store.getters.isUpdating === 'function'
        ? store.getters.isUpdating(item.id)
        : false;
    return isStoreUpdating || localUpdatingItems.value.has(item.id);
};

// Update quantity
const updateQuantity = async (itemId, productId, quantityInGrams) => {
    if (!itemId || !productId) {
        console.error('Missing itemId or productId for update');
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

// Increment quantity
const incrementQuantity = async (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) {
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

// Decrement quantity
const decrementQuantity = async (product) => {
    const cartItem = getCartItem(product);
    if (!cartItem) {
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

// Add to cart
const addToCart = async (product) => {
    if (!isInStock(product)) {
        showToast(t('out_of_stock'), 'error');
        return;
    }
    addingToCart.value.add(product.id);
    try {
        const unit = product.unit || 'piece';
        const config = getUnitConfig(unit);
        const quantity = config.min;
        const quantityInGrams = convertToGrams(product, quantity);
        await store.dispatch('addItem', {
            productId: product.id,
            quantityGrams: quantityInGrams
        });
        showToast(`${product.title} ${t('added_to_cart')}`, 'success');
        await fetchCart();
    } catch (error) {
        console.error('Add to cart error:', error);
        showToast(error.response?.data?.message || error.message || t('add_to_cart_error'), 'error');
    } finally {
        addingToCart.value.delete(product.id);
    }
};
const getProductLink = (product) => {
    if (product.slug) {
        return { name: 'product-details', params: { slug: product.slug } };
    }
    return { name: 'product-details', params: { id: product.id } };
};


// Fetch cart
const fetchCart = async () => {
    try {
        await store.dispatch('fetchCart');
    } catch (error) {
        console.error('Failed to fetch cart:', error);
    }
};

const fetchWishlist = async () => {
    if (isAuthenticated.value) {
        try {
            await store.dispatch('wishlist/fetchWishlist');
        } catch (error) {
            console.error('Failed to fetch wishlist:', error);
        }
    }
};

// Wishlist methods


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
        });
    }
};

// Visible pages for pagination
const visiblePages = computed(() => {
    const total = totalPages.value;
    const current = currentPage.value;
    const pages = [];
    if (total <= 7) {
        for (let i = 1; i <= total; i++) pages.push(i);
    } else {
        pages.push(1);
        if (current > 3) pages.push('...');
        const start = Math.max(2, current - 1);
        const end = Math.min(total - 1, current + 1);
        for (let i = start; i <= end; i++) pages.push(i);
        if (current < total - 2) pages.push('...');
        pages.push(total);
    }
    return pages;
});

// Get product image
const getProductImage = (imagePath) => {
    if (!imagePath) return '/images/placeholder.jpg';
    if (imagePath.startsWith('http')) return imagePath;
    return `${storageBase}/${imagePath}`;
};

// Fetch products by category
const fetchProducts = async (page = 1) => {
    loading.value = true;
    try {
        const response = await axiosClient.get('/category', {
            params: {
                category_id: categoryId.value,
                page: page,
                per_page: perPage.value
            }
        });
        products.value = response.data.data || [];
        totalProducts.value = response.data.total || 0;
        totalPages.value = response.data.last_page || 1;
        currentPage.value = response.data.current_page || 1;
        await nextTick();
        scrollToMiddle();
    } catch (error) {
        console.error('Error fetching products:', error);
        products.value = [];
        totalProducts.value = 0;
    } finally {
        loading.value = false;
    }
};

// Change page
const changePage = (page) => {
    if (page < 1 || page > totalPages.value || page === currentPage.value) return;
    router.push({
        path: '/category',
        query: { ...route.query, page: page }
    });
    fetchProducts(page);
};

// Scroll to middle of page
const scrollToMiddle = () => {
    const productsSection = document.getElementById('products-section');
    if (productsSection) {
        const sectionTop = productsSection.offsetTop;
        const windowHeight = window.innerHeight;
        const scrollTo = sectionTop + (windowHeight / 2.5);
        window.scrollTo({ top: scrollTo, behavior: 'smooth' });
    } else {
        window.scrollTo({ top: window.innerHeight / 2, behavior: 'smooth' });
    }
};

// Navigate to product detail
const navigateToProduct = (product) => {
    router.push({
        path: `/product/${product.slug || product.id}`
    });
};

// Go back
const goBack = () => {
    router.push('/');
};

// Watch for route changes
watch(
    () => route.query.category_id,
    (newCategoryId) => {
        if (newCategoryId) {
            categoryId.value = newCategoryId;
            categoryName.value = route.query.category_name ;
            const page = parseInt(route.query.page) || 1;
            currentPage.value = page;
            fetchProducts(page);
        }
    },
    { immediate: true }
);

// Watch authentication
watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart();
    }
});

onMounted(() => {
    categoryId.value = route.query.category_id || null;
    categoryName.value = route.query.category_name;
    const page = parseInt(route.query.page) || 1;
    currentPage.value = page;
    fetchCart();
    if (categoryId.value) {
        fetchProducts(page);
    }
    fetchWishlist();

});
</script>

<style scoped>
.products-page {
    min-height: 100vh;
}

.category-header {
    background: linear-gradient(135deg, #fbbf24, #f59e0b);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.category-header h1 {
    color: #1a1a2e;
}

.product-card {
    cursor: pointer;
}

.product-card:hover {
    transform: translateY(-4px);
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

nav button {
    min-width: 40px;
}

nav button:focus-visible {
    outline: 2px solid #fbbf24;
    outline-offset: 2px;
}

@media (max-width: 640px) {
    .products-page {
        padding: 0.5rem;
    }

    .grid {
        gap: 0.75rem;
    }

    nav button {
        padding: 0.5rem 0.75rem;
        font-size: 0.875rem;
    }
}

@media (min-width: 640px) {
    .grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (min-width: 768px) {
    .grid {
        grid-template-columns: repeat(4, 1fr);
    }
}

@media (min-width: 1024px) {
    .grid {
        grid-template-columns: repeat(5, 1fr);
    }
}

@media (min-width: 1280px) {
    .grid {
        grid-template-columns: repeat(6, 1fr);
    }
}
</style>
