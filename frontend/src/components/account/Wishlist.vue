<template>
    <div class="wishlist-container">
        <!-- Header -->
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-800">
                {{ t('my_wishlist') }}
                <span v-if="items.length > 0" class="text-sm font-normal text-gray-500 ml-2">
                    ({{ items.length }} {{ t('items') }})
                </span>
            </h2>
            <button
                v-if="items.length > 0"
                @click="clearWishlist"
                class="text-sm text-red-600 hover:text-red-700 font-medium transition-colors"
            >
                {{ t('clear_all') }}
            </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-16">
            <div class="relative">
                <div class="animate-spin rounded-full h-16 w-16 border-4 border-green-200 border-t-green-600"></div>
                <div class="absolute inset-0 flex items-center justify-center">
                    <div class="h-8 w-8 bg-green-600 rounded-full animate-pulse"></div>
                </div>
            </div>
            <p class="mt-4 text-gray-500 font-medium">{{ t('loading') }}</p>
        </div>

        <!-- Empty State -->
        <div v-else-if="items.length === 0" class="text-center py-16">
            <div class="inline-flex items-center justify-center w-32 h-32 bg-gray-100 rounded-full mb-6">
                <svg class="w-16 h-16 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                        d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                </svg>
            </div>
            <h3 class="text-xl font-semibold text-gray-600 mb-2">{{ t('empty_wishlist') }}</h3>
            <p class="text-gray-400 mb-6">{{ t('empty_wishlist_message') || 'Start adding items you love to your wishlist' }}</p>
            <router-link to="/shop"
                class="inline-flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-full font-semibold shadow-md hover:shadow-lg transition-all duration-300 transform hover:scale-105">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                </svg>
                {{ t('browse_products') }}
            </router-link>
        </div>

        <!-- Wishlist Grid -->
        <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
            <div v-for="item in items" :key="item.id"
                class="group bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 hover:border-green-200 flex flex-col">

                <!-- Image Container -->
                <div class="relative overflow-hidden bg-gray-100 aspect-square">
                    <router-link :to="getProductLink(getProduct(item))" class="block h-full">
                        <img
                            :src="getImageUrl(getProduct(item).image)"
                            :alt="getProduct(item).title"
                            @error="handleImageError"
                            class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                            loading="lazy"
                            decoding="async" />
                        <!-- <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-10 transition-all duration-300"></div> -->
                    </router-link>

                    <!-- Discount Badge -->
                    <div v-if="getDiscount(getProduct(item).price, getProduct(item).sale_price)"
                        class="absolute top-3 z-10 bg-gradient-to-r from-red-600 to-red-500 text-white text-sm font-bold px-3 py-1.5 rounded-full shadow-lg"
                        :class="currentLanguage === 'ar' ? 'right-3' : 'left-3'">
                        -{{ getDiscount(getProduct(item).price, getProduct(item).sale_price) }}%
                    </div>

                    <!-- Remove Button (Mobile) -->
                    <button
                        @click="removeFromWishlist(item)"
                        :disabled="removingItems.has(item.id)"
                        class="absolute top-3 z-10 p-2.5 bg-white rounded-full shadow-md hover:shadow-lg transition-all duration-300 hover:scale-110 disabled:opacity-50"
                        :class="currentLanguage === 'ar' ? 'left-3' : 'right-3'">
                        <svg v-if="removingItems.has(item.id)"
                            class="animate-spin h-5 w-5 text-gray-400"
                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <svg v-else class="w-5 h-5 text-red-500 hover:text-red-600 transition-colors"
                            fill="currentColor" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>

                    <!-- Out of Stock Overlay -->
                    <div v-if="!isInStock(getProduct(item))"
                        class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center backdrop-blur-sm">
                        <span class="text-white font-bold text-sm px-4 py-2 bg-red-600 rounded-full shadow-xl">
                            {{ t('out_of_stock') }}
                        </span>
                    </div>
                </div>

                <!-- Product Details -->
                <div class="p-4 flex-1 flex flex-col">
                    <!-- Category -->
                    <p class="text-xs text-green-600 font-medium mb-1">
                        {{ getProduct(item).category?.name || t('uncategorized') }}
                    </p>

                    <!-- Title -->
                    <router-link :to="getProductLink(getProduct(item))" class="block">
                        <h3 class="text-sm font-semibold text-gray-800 hover:text-green-600 transition-colors duration-200 line-clamp-2 min-h-[2.5rem]">
                            {{ currentLanguage === 'ar' && getProduct(item).title_ar ? getProduct(item).title_ar : getProduct(item).title }}
                        </h3>
                    </router-link>

                    <!-- Rating -->
                    <div class="flex items-center mt-2">
                        <div class="flex text-yellow-400 rating-stars text-xs">
                            <span v-for="n in 5" :key="n"
                                :class="getStarClass(n, getProduct(item).rating || 0)">
                                ★
                            </span>
                        </div>
                        <span class="text-gray-400 text-xs ml-2 rtl:mr-2 rtl:ml-0">
                            ({{ getProduct(item).reviews_count || 0 }})
                        </span>
                    </div>

                    <!-- Price -->
                    <div class="flex items-end gap-2 mt-3">
                        <span v-if="getProduct(item).sale_price" class="text-lg font-bold text-green-700">
                            {{ formatPrice(getProduct(item).sale_price) }}
                        </span>
                        <span v-if="getProduct(item).sale_price" class="text-sm text-gray-400 line-through">
                            {{ formatPrice(getProduct(item).price) }}
                        </span>
                        <span v-else class="text-lg font-bold text-green-700">
                            {{ formatPrice(getProduct(item).price) }}
                        </span>
                        <span v-if="getProduct(item).unit" class="text-xs text-gray-400">/ {{ getProduct(item).unit }}</span>
                    </div>
                </div>

                <!-- Actions -->
                <div class="px-4 pb-4 mt-auto flex gap-2">
                    <!-- Add to Cart Button -->
                    <button
                        v-if="isInStock(getProduct(item))"
                        @click="addToCart(getProduct(item))"
                        :disabled="isAddingToCart(getProduct(item).id)"
                        class="flex-1 bg-gradient-to-r from-green-600 to-green-500 hover:from-green-700 hover:to-green-600 text-white font-semibold py-2.5 rounded-xl transition-all duration-300 flex items-center justify-center gap-2 shadow-md hover:shadow-lg disabled:opacity-60 disabled:cursor-not-allowed text-sm">
                        <svg v-if="isAddingToCart(getProduct(item).id)" class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <span>{{ t('add_to_cart') }}</span>
                    </button>

                    <!-- Remove Button (Desktop) -->
                    <button
                        @click="removeFromWishlist(item)"
                        :disabled="removingItems.has(item.id)"
                        class="px-4 bg-red-50 hover:bg-red-100 text-red-600 font-medium py-2.5 rounded-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed text-sm">
                        <svg v-if="removingItems.has(item.id)"
                            class="animate-spin h-5 w-5 text-red-400"
                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useToast } from 'vue-toastification';
import { useStore } from 'vuex';
import { useLanguage } from '../../composables/useLanguage';

const props = defineProps({
    items: {
        type: Array,
        default: () => []
    },
    loading: {
        type: Boolean,
        default: false
    }
});

const emit = defineEmits(['refresh', 'update']);

// Composables
const store = useStore();
const toast = useToast();
const { currentLanguage, currentDirection, t, formatPrice, formatWeight } = useLanguage();

// State
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000";
const removingItems = ref(new Set());
const addingToCart = ref(new Set());
const user = ref(null);


// Computed
const cartItems = computed(() => store.getters.cartItems);
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false);

// Helper Methods
const getProduct = (item) => {
    // If item has a product property, use it (for nested structure)
    if (item.product) {
        return item.product;
    }
    // Otherwise assume item itself is the product
    return item;
};

const getUserInitials = () => {
    if (!user.value?.name) return '?';
    return user.value.name
        .split(' ')
        .map(word => word.charAt(0))
        .join('')
        .toUpperCase()
        .slice(0, 2);
};

const fetchUser = async () => {
    try {
        const response = await store.dispatch('users/fetchProfile');
        user.value = response;
    } catch (error) {
        // console.error('Error fetching user:', error);
        toast.error(t('error_fetching_profile'));
    }
};

const getProductLink = (product) => {
    if (!product) return null;

    // Use slug if available
    if (product.slug) {
        // Clean the slug (handle spaces and special characters)
        const cleanSlug = String(product.slug)
            .toLowerCase()
            .trim()
            .replace(/\s+/g, '-')
            .replace(/[^a-z0-9-]/g, '');

        if (cleanSlug) {
            return {
                name: 'product-details',
                params: { slug: cleanSlug }
            };
        }
    }

    // Fallback to ID
    if (product.id) {
        return {
            name: 'product-details',
            params: { slug: String(product.id) }
        };
    }

    return null;
};

const getImageUrl = (imagePath) => {
    if (!imagePath) return "/images/placeholder.jpg";
    if (imagePath.startsWith("http")) return imagePath;
    return `${storageBase}/${imagePath}`;
};



const handleImageError = (event) => {
    event.target.src = '/images/placeholder.jpg';
};

const getDiscount = (price, salePrice) => {
    if (!price || !salePrice || salePrice >= price) return 0;
    return Math.round(((price - salePrice) / price) * 100);
};

const getStarClass = (star, rating) => {
    return star <= Math.round(rating) ? 'text-yellow-400' : 'text-gray-300';
};

const isInStock = (product) => {
    return (product?.stock || 0) > 0;
};

// Cart Methods
const isInCart = (product) => {
    return cartItems.value.some((item) => item.product_id === product.id);
};

const getCartItem = (product) => {
    return cartItems.value.find((item) => item.product_id === product.id);
};

const isAddingToCart = (productId) => {
    return addingToCart.value.has(productId);
};

const addToCart = async (product) => {
    if (!isInStock(product)) {
        toast.error(t('out_of_stock'));
        return;
    }

    addingToCart.value.add(product.id);

    try {
        await store.dispatch("addItem", {
            productId: product.id,
            quantityGrams: 1000,
        });
        toast.success(t('added_to_cart'));
    } catch (error) {
        toast.error(error.response?.data?.message || error.message || t('add_to_cart_error'));
    } finally {
        addingToCart.value.delete(product.id);
    }
};

// Wishlist Methods
const removeFromWishlist = async (item) => {
    // Get the product ID from the wishlist item
    const productId = item.product_id || item.product?.id || item.id;

    // Use the item's id (wishlist record ID) for the loading state
    const wishlistItemId = item.id;

    removingItems.value.add(wishlistItemId);

    try {
        // Pass the product ID to the store action
        await store.dispatch('wishlist/removeFromWishlist', productId);
        toast.success(t('removed_from_wishlist'));
        emit('refresh');
    } catch (error) {
        console.error('Remove from wishlist error:', error);
        toast.error(error.response?.data?.message || t('remove_error'));
    } finally {
        removingItems.value.delete(wishlistItemId);
    }
};

const clearWishlist = async () => {
    if (!confirm(t('clear_wishlist_confirm') || 'Are you sure you want to clear your wishlist?')) {
        return;
    }

    try {
        for (const item of props.items) {
            await store.dispatch('wishlist/removeFromWishlist', item.id);
        }
        toast.success(t('wishlist_cleared'));
        emit('refresh');
    } catch (error) {
        toast.error(t('clear_error'));
    }
};

// Lifecycle
onMounted(() => {
    fetchUser();
    // Log the items to debug
    // console.log('Wishlist items:', props.items);
});

// Watch for changes
watch(() => props.items, (newItems) => {
    // console.log('Wishlist items updated:', newItems);
}, { deep: true });

// Expose methods
defineExpose({
    removeFromWishlist,
    clearWishlist,
    addToCart,
    getProduct
});
</script>

<style scoped>
.wishlist-container {
    max-width: 100%;
}

/* Rating Stars */
.rating-stars {
    letter-spacing: 2px;
}

/* Line Clamp */
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* RTL Support */
[dir="rtl"] .mr-2 {
    margin-left: 0.5rem;
    margin-right: 0;
}

[dir="rtl"] .ml-2 {
    margin-right: 0.5rem;
    margin-left: 0;
}

/* Animations */
.animate-pulse {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: .5;
    }
}

/* Product Card Hover */
.group {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.group:hover {
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    transform: translateY(-4px);
}

/* Responsive Grid */
@media (max-width: 640px) {
    .wishlist-container {
        padding: 0 0.5rem;
    }
}
</style>
