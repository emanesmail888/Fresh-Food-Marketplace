<template>
    <div class="max-w-10xl mx-auto px-4 sm:px-6 lg:px-8" :dir="currentDirection">
        <!-- Header -->
        <div class="text-center mb-12">
            <div class="flex items-center justify-center gap-4 mb-4">
                <div class="h-px w-12 bg-linear-to-r from-transparent to-yellow-500"></div>
                <span class="text-yellow-600 font-semibold text-sm uppercase tracking-wider">
                    {{ t("our_products") || "Our Products" }}
                </span>
                <div class="h-px w-12 bg-linear-to-l from-transparent to-yellow-500"></div>
            </div>

            <h2 class="text-4xl md:text-3xl font-bold text-yellow-800 mb-3">
                {{ t("featured_products") }}
            </h2>
            <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                {{ t("featured_products_subtitle") || "Discover our handpicked selection of premium products" }}
            </p>
        </div>

        <!-- Loading State -->
        <!-- <div v-if="isLoading" class="flex flex-col items-center justify-center py-20">
            <div class="relative">
                <div class="animate-spin rounded-full h-16 w-16 border-4 border-green-200 border-t-green-600"></div>
                <div class="absolute inset-0 flex items-center justify-center">
                    <div class="h-8 w-8 bg-green-600 rounded-full animate-pulse"></div>
                </div>
            </div>
            <p class="mt-4 text-gray-500 font-medium">{{ t("loading") }}</p>
        </div> -->

        <!-- Error State -->
        <div v-if="error" class="text-center py-20">
            <div class="inline-flex items-center justify-center w-20 h-20 bg-red-100 rounded-full mb-4">
                <svg class="w-10 h-10 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <p class="text-red-600 text-lg mb-6">{{ error }}</p>
            <button @click="getProducts"
                class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-full font-semibold shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                {{ t("retry") }}
            </button>
        </div>

        <!-- Products Grid -->
        <div v-else class="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-5 lg:grid-cols-5 xl:grid-cols-5 gap-4 md:gap-6">
            <!-- Product Card -->
            <div v-for="product in displayedProducts" :key="product.id"
                class="product-card group relative bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 hover:border-green-200 flex flex-col transform hover:-translate-y-1">

                <!-- Image Container -->
                <div class="relative overflow-hidden bg-gray-100 aspect-square">
                    <router-link :to="getProductLink(product)" class="block h-full">
                        <img :src="getProductImage(product.image)"
                            :alt="product.title"
                            @error="handleImageError"
                            class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                            decoding="async" />

                        <!-- <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-10 transition-all duration-300"></div> -->
                    </router-link>

                    <!-- Discount Badge -->
                    <div v-if="getDiscount(product.price, product.sale_price)"
                        class="absolute top-3 z-10 bg-linear-to-r from-red-600 to-red-500 text-white text-sm font-bold px-3 py-1.5 rounded-full shadow-lg"
                        :class="currentLanguage === 'ar' ? 'right-3' : 'left-3'">
                        -{{ getDiscount(product.price, product.sale_price) }}%
                    </div>

                    <!-- New Badge -->
                    <div v-if="isNewProduct(product)"
                        class="absolute top-3 z-10 bg-linear-to-r from-blue-500 to-blue-400 text-white text-xs font-bold px-3 py-1.5 rounded-full shadow-lg"
                        :class="currentLanguage === 'ar' ? 'left-3' : 'right-3'">
                        {{ t("new") || "New" }}
                    </div>

                    <!-- Wishlist Button -->
                    <button
                        @click="toggleWishlist(product)"
                        :disabled="wishlistLoading[product.id]"
                        class="absolute top-3 z-10 p-2.5 bg-white rounded-full shadow-md hover:shadow-lg transition-all duration-300 hover:scale-110 disabled:opacity-50"
                        :class="currentLanguage === 'ar' ? 'left-3' : 'right-3'">
                        <svg v-if="wishlistLoading[product.id]"
                            class="animate-spin h-5 w-5 text-gray-400"
                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <svg v-else class="w-5 h-5 transition-colors duration-300"
                            :class="isInWishlist(product.id) ? 'text-red-500 fill-current' : 'text-gray-400 hover:text-red-400'"
                            fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                        </svg>
                    </button>

                    <!-- Out of Stock Overlay -->
                    <div v-if="!isInStock(product)"
                        class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center backdrop-blur-sm">
                        <span class="text-white font-bold text-lg px-6 py-3 bg-red-600 rounded-full shadow-xl">
                            {{ t("out_of_stock") }}
                        </span>
                    </div>
                </div>

                <!-- Product Details -->
                <div class="p-4 flex-1 flex flex-col">
                    <p class="text-xs text-green-600 font-medium mb-1">
                        {{ currentLanguage === 'ar' && product.category?.name_ar ?product.category?.name_ar : product.category?.name|| t("uncategorized")}}

                    </p>

                    <router-link :to="getProductLink(product)" class="block">
                        <h3 class="text-base font-semibold text-gray-800 hover:text-green-600 transition-colors duration-200 line-clamp-2 min-h-12">
                            {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}
                        </h3>
                    </router-link>

                    <!-- <p class="text-sm text-gray-500 line-clamp-2 mt-1 min-h-10">
                        {{ product.short_description || product.description?.substring(0, 80) + '...' }}
                    </p> -->

                    <!-- Rating -->
                    <div class="flex items-center mt-2">
                        <div class="flex text-yellow-400 rating-stars text-sm">
                            <span v-for="n in 5" :key="n"
                                :class="getStarClass(n, product.rating || 0)">
                                ★
                            </span>
                        </div>
                        <span class="text-gray-400 text-xs ml-2 rtl:mr-2 rtl:ml-0">
                            ({{ product.reviews_count || 0 }})
                        </span>
                    </div>



                    <p class="text-xs text-gray-400 mt-1">
                        {{ product.unit || t("kg") }}
                    </p>

                    <!-- Price -->
                    <div class="flex items-end gap-2 mt-3">
                        <span v-if="product.sale_price" class="text-xl font-bold text-green-700">
                            {{ formatPrice(product.sale_price) }}
                        </span>
                        <span v-if="product.sale_price" class="text-sm text-gray-400 line-through">
                            {{ formatPrice(product.price) }}
                        </span>
                        <span v-else class="text-xl font-bold text-green-700">
                            {{ formatPrice(product.price) }}
                        </span>
                        <span class="text-xs text-gray-400">/ {{ t("kg") }}</span>
                    </div>

                    <!-- Stock Status -->
                    <p v-if="isLowStock(product)" class="text-xs text-orange-600 mt-1 flex items-center gap-1">
                        <span class="inline-block w-2 h-2 bg-orange-500 rounded-full animate-pulse"></span>
                        ⚠️ {{ t("low_stock") }}
                    </p>
                </div>

                <!-- Add to Cart Section -->
                <div class="px-4 pb-4 mt-auto">
                    <!-- Out of Stock -->
                    <div v-if="!isInStock(product)">
                        <button disabled
                            class="w-full bg-gray-200 text-gray-400 font-medium py-3 rounded-xl cursor-not-allowed">
                            {{ t("unavailable") }}
                        </button>
                    </div>

                    <!-- Add to Cart Button -->
                    <button v-else-if="!isInCart(product)"
                        @click="addToCart(product)"
                        :disabled="isAddingToCart(product.id)"
                        class="w-full bg-linear-to-r from-green-600 to-green-500 hover:from-green-700 hover:to-green-600 text-white font-semibold py-3 rounded-xl transition-all duration-300 flex items-center justify-center gap-2 shadow-md hover:shadow-lg disabled:opacity-60 disabled:cursor-not-allowed transform hover:scale-[1.02]">
                        <svg v-if="isAddingToCart(product.id)" class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <span>{{ t("add_to_cart") }}</span>
                    </button>

                    <!-- Quantity Controls -->
                    <div v-else class="quantity-control flex items-center border-2 border-green-500 rounded-xl overflow-hidden bg-white shadow-sm">
                        <button @click="decrementQuantity(product)"
                            :disabled="isUpdatingQuantity(product.id) || currentGrams(product) <= 100"
                            class="px-4 py-3 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed hover:text-green-800">
                            −
                        </button>

                        <div class="flex-1 text-center py-3 bg-green-50 font-semibold text-sm relative min-w-15">
                            <span v-if="isUpdatingQuantity(product.id)" class="absolute inset-0 flex items-center justify-center bg-white bg-opacity-80">
                                <div class="animate-spin rounded-full h-5 w-5 border-2 border-green-500 border-t-transparent"></div>
                            </span>
                            <span :class="{ 'opacity-0': isUpdatingQuantity(product.id) }" class="text-green-700">
                                {{ formatWeight(currentGrams(product)) }}
                            </span>
                        </div>

                        <button @click="incrementQuantity(product)"
                            :disabled="isUpdatingQuantity(product.id) || !canIncrement(product)"
                            class="px-4 py-3 text-xl font-bold text-green-700 hover:bg-green-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed hover:text-green-800">
                            +
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <div v-if="!isLoading && !error && displayedProducts.length === 0"
            class="text-center py-20">
            <div class="inline-flex items-center justify-center w-24 h-24 bg-gray-100 rounded-full mb-4">
                <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                </svg>
            </div>
            <h3 class="text-xl font-semibold text-gray-600 mb-2">{{ t("no_products") }}</h3>
            <p class="text-gray-400">{{ t("no_products_message") || "No products available at the moment" }}</p>
        </div>

    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useToast } from "vue-toastification";
import { useStore } from "vuex";
import { useRouter } from "vue-router";
import { useLanguage } from "../composables/useLanguage";

const store = useStore();
const props = defineProps({
    products: { type: Array, default: () => [] }
});

const { currentLanguage, currentDirection, t, formatPrice, formatWeight } = useLanguage();

const displayedProducts = computed(() => props.products);
const toast = useToast();
const storageBase = import.meta.env.VITE_STORAGE_URL ;

// State

const addingToCart = ref(new Set());
const localUpdatingItems = ref(new Set());
const wishlistLoading = ref({});

// Computed
const isLoading = computed(() => store.state.isHomeLoading);

const error = computed(() => store.state.homeError);





// Cart computed
const cartItems = computed(() => store.getters.cartItems);
const isAuthenticated = computed(() => store.getters["isAuthenticated"] || false);
// const wishlistItems = computed(() => store.getters['wishlist/wishlistItems'] || []);
const wishlistItems = computed(() => {
    const items = store.getters['wishlist/wishlistItems'];
    return Array.isArray(items) ? items : [];
});

// Helper Methods
const getProductLink = (product) => {
    if (product.slug) {
        return { name: 'product-details', params: { slug: product.slug } };
    }
    return { name: 'product-details', params: { id: product.id } };
};

const getProductImage = (imagePath) => {
    if (!imagePath) return "/images/placeholder.jpg";
    if (imagePath.startsWith("http")) return imagePath;
    return `${storageBase}/${imagePath}`;
};



// const handleImageError = (event) => {
//     event.target.src = '/images/placeholder.jpg';
// };

const getDiscount = (price, salePrice) => {
    if (!price || !salePrice || salePrice >= price) return 0;
    return Math.round(((price - salePrice) / price) * 100);
};

const getStarClass = (star, rating) => {
    return star <= Math.round(rating) ? 'text-yellow-400' : 'text-gray-300';
};

const isNewProduct = (product) => {
    if (!product.created_at) return false;
    const daysSinceCreation = (Date.now() - new Date(product.created_at).getTime()) / (1000 * 60 * 60 * 24);
    return daysSinceCreation <= 7;
};

// Wishlist Methods
// const isInWishlist = (productId) => {
//     return wishlistItems.value.some(item => item.id === productId);
// };

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

// Cart Methods
const isInCart = (product) => {
    return cartItems.value.some((item) => item.product_id === product.id);
};

const getCartItem = (product) => {
    return cartItems.value.find((item) => item.product_id === product.id);
};

const currentGrams = (product) => {
    const item = getCartItem(product);
    return item?.quantity_grams || 0;
};

const isAddingToCart = (productId) => {
    return addingToCart.value.has(productId);
};

const isUpdatingQuantity = (productId) => {
    const item = getCartItem({ id: productId });
    if (!item) return false;
    const isStoreUpdating = typeof store.getters.isUpdating === "function" ? store.getters.isUpdating(item.id) : false;
    return isStoreUpdating || localUpdatingItems.value.has(item.id);
};

const isInStock = (product) => {
    return (product.stock || 0) > 0;
};

const isLowStock = (product) => {
    return product.stock > 0 && product.stock <= 2;
};

const canIncrement = (product) => {
    const item = getCartItem(product);
    if (!item) return true;
    const maxStock = (product.stock || 50) * 1000;
    return item.quantity_grams < maxStock;
};

const addToCart = async (product) => {
    if (!isInStock(product)) {
        showToast(t("out_of_stock"), "error");
        return;
    }

    addingToCart.value.add(product.id);

    try {
        await store.dispatch("addItem", {
            productId: product.id,
            quantityGrams: 1000,
        });
        showToast(t("added_to_cart"), "success");
        await fetchCart();
    } catch (error) {
        showToast(error.response?.data?.message || error.message || t("add_to_cart_error"), "error");
    } finally {
        addingToCart.value.delete(product.id);
    }
};

const updateQuantity = async (itemId, productId, quantityGrams) => {
    if (!itemId) {
        console.error("No item ID provided for update");
        return;
    }

    localUpdatingItems.value.add(itemId);

    try {
        await store.dispatch("updateQuantity", { itemId, quantityGrams });
        await fetchCart();
    } catch (error) {
        showToast(error.response?.data?.message || error.message || t("update_error"), "error");
        throw error;
    } finally {
        localUpdatingItems.value.delete(itemId);
    }
};

const incrementQuantity = async (product) => {
    const item = getCartItem(product);
    if (!item) return;

    const step = 100;
    const currentQuantity = Math.round(item.quantity_grams);
    const maxStock = (product.stock || 50) * 1000;

    if (currentQuantity >= maxStock) {
        showToast(t("max_quantity_reached"), "warning");
        return;
    }

    const newQuantity = Math.min(currentQuantity + step, maxStock);
    if (newQuantity === currentQuantity) return;
    await updateQuantity(item.id, product.id, Math.round(newQuantity));
};

const decrementQuantity = async (product) => {
    const item = getCartItem(product);
    if (!item) return;

    const step = 100;
    const currentQuantity = Math.round(item.quantity_grams);

    if (currentQuantity <= 100) {
        showToast(t("min_quantity_reached"), "warning");
        return;
    }

    const newQuantity = Math.max(currentQuantity - step, 100);
    await updateQuantity(item.id, product.id, newQuantity);
};

const fetchCart = async () => {
    try {
        await store.dispatch("fetchCart");
    } catch (error) {
        console.error("Failed to fetch cart:", error);
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



const showToast = (message, type = "success") => {
    if (toast) {
        toast[type](message, {
            timeout: 3000,
            position: currentLanguage.value === "ar" ? "top-left" : "top-right",
        });
    }
};

// Lifecycle
onMounted(() => {
    fetchCart();
    fetchWishlist();
});

watch(isAuthenticated, (newValue, oldValue) => {
    if (newValue !== oldValue) {
        fetchCart();
        fetchWishlist();
    }
});

defineExpose({ cartItems, getCartItem, getCartItemId: () => {} });
</script>

<style scoped>
.product-card {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.product-card:hover {
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    transform: translateY(-4px);
}

.rating-stars {
    letter-spacing: 2px;
}

.quantity-control button {
    user-select: none;
    touch-action: manipulation;
}

[dir="rtl"] .mr-2 {
    margin-left: 0.5rem;
    margin-right: 0;
}

[dir="rtl"] .ml-2 {
    margin-right: 0.5rem;
    margin-left: 0;
}

.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

@media (max-width: 640px) {
    .featured-products-section {
        padding: 2rem 0;
    }
}

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
</style>
