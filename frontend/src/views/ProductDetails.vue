<template>
    <home-layout>
        <div class="container mx-auto px-8 py-8" :dir="currentDirection">
            <div v-if="loading" class="flex justify-center items-center py-20">
                <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
            </div>

            <div v-else-if="error" class="text-center py-20">
                <p class="text-red-600 mb-4">{{ error }}</p>
                <button @click="fetchProduct" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700">
                    {{ t('retry') }}
                </button>
            </div>

            <div v-else-if="product" class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Product Images Slider -->
                <div class="space-y-4">
                    <div class="relative bg-gray-100 rounded-2xl overflow-hidden">
                        <!-- Main Image -->
                        <div class="aspect-square relative">
                            <img :src="currentImage" :alt="product.title"
                                class="w-full h-full object-cover transition-opacity duration-300" />

                            <!-- Discount Badge -->
                            <div v-if="getDiscount"
                                class="absolute top-4 z-10 bg-red-600 text-white text-lg font-bold px-4 py-2 rounded-full"
                                :class="currentLanguage === 'ar' ? 'right-4' : 'left-4'">
                                -{{ getDiscount }}%
                            </div>

                            <!-- Stock Status -->
                            <div v-if="!isInStock"
                                class="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-black bg-opacity-75 text-white px-6 py-2 rounded-full text-sm font-semibold">
                                {{ t('out_of_stock') }}
                            </div>
                        </div>

                        <!-- Navigation Arrows -->
                        <button v-if="allImages.length > 1" @click="prevImage"
                            class="absolute top-1/2 -translate-y-1/2 left-2 bg-white/90 hover:bg-white p-2 rounded-full shadow-lg transition-all hover:scale-110">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    :d="currentDirection === 'rtl' ? 'M9 5l7 7-7 7' : 'M15 19l-7-7 7-7'" />
                            </svg>
                        </button>
                        <button v-if="allImages.length > 1" @click="nextImage"
                            class="absolute top-1/2 -translate-y-1/2 right-2 bg-white/90 hover:bg-white p-2 rounded-full shadow-lg transition-all hover:scale-110">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    :d="currentDirection === 'rtl' ? 'M15 19l-7-7 7-7' : 'M9 5l7 7-7 7'" />
                            </svg>
                        </button>
                    </div>

                    <!-- Thumbnails -->
                    <div v-if="allImages.length > 1" class="grid grid-cols-4 sm:grid-cols-6 gap-2">
                        <div v-for="(image, index) in allImages" :key="index" @click="currentImageIndex = index"
                            class="aspect-square rounded-lg overflow-hidden cursor-pointer transition-all" :class="[
                                currentImageIndex === index
                                    ? 'ring-2 ring-green-500 ring-offset-2'
                                    : 'opacity-70 hover:opacity-100'
                            ]">
                            <img :src="image" :alt="`${product.title} - ${index + 1}`"
                                class="w-full h-full object-cover" />
                        </div>
                    </div>
                </div>

                <!-- Product Info -->
                <div class="space-y-6">
                    <!-- Category Breadcrumb -->
                    <div class="flex items-center gap-2 text-sm text-gray-500">
                        <span>{{ t('category') }}:</span>
                        <span class="text-green-600 font-medium">
                        {{ currentLanguage === 'ar' && product.category?.name_ar ?product.category?.name_ar : product.category?.name|| t("uncategorized")}}
                        </span>
                    </div>

                    <!-- Title -->
                    <h1 class="text-3xl md:text-4xl font-bold text-gray-800">
                        {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}

                    </h1>

                    <!-- Rating (Optional) -->
                    <div class="flex items-center gap-4">
                        <div class="text-2xl font-bold text-green-800">
                           {{ getAverageRating() }}
                        </div>
                        <div class="flex items-center">
                             <span v-for="n in 5" :key="n" class="text-xl">
                                {{ n <= Math.round(getAverageRatingNumber()) ? '⭐' : '☆' }}
                            </span>
                        </div>
                        <span class="text-gray-500 text-sm">( {{ stats.total_reviews || 0 }} {{ t('reviews') }})</span>
                    </div>


                    <!-- Price -->
                    <div class="flex items-center gap-4 py-4 border-t border-b border-gray-200">
                        <div v-if="product.sale_price" class="flex items-center gap-3">
                            <span class="text-3xl font-bold text-green-700">
                                {{ formatPrice(product.sale_price) }}
                            </span>
                            <span class="text-lg text-gray-400 line-through">
                                {{ formatPrice(product.price) }}
                            </span>
                        </div>
                        <span v-else class="text-3xl font-bold text-green-700">
                            {{ formatPrice(product.price) }}
                        </span>
                    </div>

                    <!-- Unit & Stock Info -->
                    <div class="grid grid-cols-2 gap-4 text-sm">
                        <div class="bg-gray-50 rounded-lg p-3">
                            <span class="text-gray-500">{{ t('unit') }}</span>
                            <p class="font-semibold">{{ getUnitLabel(product.unit) }}</p>
                        </div>
                        <div class="bg-gray-50 rounded-lg p-3">
                            <span class="text-gray-500">{{ t('stock_status') }}</span>
                            <p class="font-semibold" :class="isInStock ? 'text-green-600' : 'text-red-600'">
                                {{ isInStock ? t('in_stock') : t('out_of_stock') }}
                            </p>
                        </div>
                    </div>

                    <!-- Weight per Unit -->
                    <div v-if="product.weight_per_unit" class="text-sm text-gray-500">
                        {{ t('weight_per_unit') }}: {{ formatWeight(product.weight_per_unit) }}
                    </div>

                    <!-- Quantity Selector -->
                    <div v-if="isInStock" class="space-y-4">
                        <label class="block text-sm font-medium text-gray-700">
                            {{ t('quantity') }}
                        </label>
                        <div class="flex items-center gap-4">
                            <div class="flex items-center border-2 border-gray-300 rounded-lg overflow-hidden">
                                <button @click="decrementQuantity" :disabled="quantity <= 1"
                                    class="px-4 py-2 text-xl font-bold text-gray-600 hover:bg-gray-100 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                    −
                                </button>
                                <div class="px-8 py-2 text-center font-semibold min-w-15">
                                    {{ quantity }}
                                </div>
                                <button @click="incrementQuantity" :disabled="quantity >= product.stock"
                                    class="px-4 py-2 text-xl font-bold text-gray-600 hover:bg-gray-100 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                                    +
                                </button>
                            </div>
                            <span class="text-sm text-gray-500">
                                {{ t('available') }}: {{ product.stock }} {{ getUnitLabel(product.unit) }}
                            </span>
                        </div>
                    </div>

                    <!-- Add to Cart Button -->
                    <button v-if="isInStock" @click="addToCart" :disabled="addingToCart"
                        class="w-full bg-green-600 hover:bg-green-700 active:bg-green-800 text-white font-semibold py-4 rounded-xl transition-all duration-200 hover:shadow-lg transform active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-3 text-lg">
                        <svg v-if="addingToCart" class="animate-spin h-6 w-6" xmlns="http://www.w3.org/2000/svg"
                            fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
                            </circle>
                            <path class="opacity-75" fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                            </path>
                        </svg>
                        <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6M17 13l1.5 6M9 21h6M12 21v-8">
                            </path>
                        </svg>
                        <span>{{ t('add_to_cart') }}</span>
                    </button>

                    <button v-else disabled
                        class="w-full bg-gray-300 text-gray-500 font-semibold py-4 rounded-xl cursor-not-allowed text-lg">
                        {{ t('unavailable') }}
                    </button>

                    <!-- Description -->
                    <div class="pt-6 border-t border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">
                            {{ t('description') }}

                        </h3>
                        <div class="prose prose-sm max-w-none text-gray-600" v-html="formattedDescription">
                        </div>
                    </div>

                    <!-- Share/Social -->
                    <div class="flex items-center gap-4 pt-4 border-t border-gray-200">
                        <span class="text-sm text-gray-500">{{ t('share') }}:</span>
                        <button class="text-blue-600 hover:text-blue-700 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.104c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 0021.504-12.022 9.994 9.994 0 002.456-2.515z" />
                            </svg>
                        </button>
                        <button class="text-blue-700 hover:text-blue-800 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.184-.897-.957-2.178-1.555-3.594-1.555-2.719 0-4.924 2.205-4.924 4.917 0 .39.045.765.127 1.124C7.691 8.094 4.066 6.13 1.64 3.161c-.427.733-.666 1.587-.666 2.497 0 1.706.868 3.213 2.188 4.096-.807-.026-1.566-.248-2.228-.616v.061c0 2.385 1.693 4.374 3.946 4.827-.413.111-.849.171-1.296.171-.314 0-.615-.03-.916-.086.631 1.953 2.445 3.377 4.604 3.417-1.68 1.319-3.809 2.105-6.102 2.105-.39 0-.779-.023-1.17-.067 2.189 1.394 4.768 2.209 7.557 2.209 9.054 0 13.999-7.496 13.999-13.986 0-.209 0-.42-.015-.63.961-.689 1.8-1.56 2.46-2.548z" />
                            </svg>
                        </button>
                        <button class="text-red-600 hover:text-red-700 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path
                                    d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Related Products -->
            <div v-if="relatedProducts.length > 0" class="mt-16">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">
                    {{ t('related_products') }}
                </h2>
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                    <div v-for="item in relatedProducts" :key="item.id" @click="navigateToProduct(item.slug)"
                        class="bg-white rounded-xl shadow-md hover:shadow-xl transition-all cursor-pointer hover:-translate-y-1 overflow-hidden">
                        <div class="aspect-square bg-gray-100">
                            <img v-if="item.image" :src="getImageUrl(item.image)" :alt="item.title"
                                class="w-full h-full object-cover" />
                            <div v-else class="w-full h-full flex items-center justify-center text-6xl">🌱</div>
                        </div>
                        <div class="p-3">
                            <h4 class="text-sm font-semibold text-gray-800 line-clamp-2">{{ item.title }}</h4>
                            <p class="text-green-700 font-bold mt-1">{{ formatPrice(item.price) }}</p>
                        </div>
                    </div>
                </div>
            </div>

<ProductReviews
    v-if="product && product.id"
    :product-id="product.id"
/>
        </div>
    </home-layout>
</template>


<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { useToast } from 'vue-toastification'
import { useLanguage } from '../composables/useLanguage.js'
import HomeLayout from "../components/HomeLayout.vue";
import ProductReviews from '../components/ProductReviews.vue';


const route = useRoute()
const router = useRouter()
const store = useStore()
const toast = useToast()
const { currentLanguage, currentDirection, t, formatPrice } = useLanguage()

// State
const product = ref(null)
const loading = ref(false)
const error = ref(null)
const quantity = ref(1)
const addingToCart = ref(false)
const currentImageIndex = ref(0)
const relatedProducts = ref([])

// Computed
const stats = computed(() => store.state.reviews?.stats || {
    average_rating: 0,
    total_reviews: 0,
    verified_count: 0,
    rating_distribution: {}
});

const allImages = computed(() => {
    if (!product.value) return []

    const images = []

    // Add main image
    if (product.value.image) {
        images.push(getImageUrl(product.value.image))
    }

    // Add additional images from JSON field
    if (product.value.images) {
        try {
            const parsed = typeof product.value.images === 'string'
                ? JSON.parse(product.value.images)
                : product.value.images

            if (Array.isArray(parsed)) {
                parsed.forEach(img => {
                    if (img) images.push(getImageUrl(img))
                })
            }
        } catch (e) {
            console.error('Failed to parse images:', e)
        }
    }

    return images.length > 0 ? images : ['/images/placeholder.jpg']
})

const currentImage = computed(() => {
    return allImages.value[currentImageIndex.value] || '/images/placeholder.jpg'
})

const getDiscount = computed(() => {
    if (!product.value) return 0
    const { price, sale_price } = product.value
    if (!price || !sale_price || sale_price >= price) return 0
    return Math.round(((price - sale_price) / price) * 100)
})

const isInStock = computed(() => {
    return (product.value?.stock || 0) > 0
})



const formattedDescription = computed(() => {
    if (!product.value) return '';

    // Get description based on current language
    const description = currentLanguage.value === 'ar'
        ? product.value.description_ar
        : product.value.description;

    if (!description) return '';

    // Replace newlines with <br> tags
    return description.replace(/\n/g, '<br>');
});

// ============ NEW: Helper Methods for safe number handling ============

/**
 * Get average rating as formatted string
 */
const getAverageRating = () => {
    const rating = parseFloat(stats.value.average_rating) || 0;
    return rating.toFixed(1);
};

/**
 * Get average rating as number
 */
const getAverageRatingNumber = () => {
    return parseFloat(stats.value.average_rating) || 0;
};

// Methods
const getImageUrl = (path) => {
    if (!path) return '/images/placeholder.jpg'
    if (path.startsWith('http')) return path
    const baseUrl = import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/'
    return `${baseUrl}/${path}`
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

const formatWeight = (weight) => {
    if (weight >= 1000) {
        return `${(weight / 1000).toFixed(2)} kg`
    }
    return `${weight} g`
}

const prevImage = () => {
    if (allImages.value.length > 1) {
        currentImageIndex.value = (currentImageIndex.value - 1 + allImages.value.length) % allImages.value.length
    }
}

const nextImage = () => {
    if (allImages.value.length > 1) {
        currentImageIndex.value = (currentImageIndex.value + 1) % allImages.value.length
    }
}

const incrementQuantity = () => {
    if (product.value && quantity.value < product.value.stock) {
        quantity.value++
    }
}

const decrementQuantity = () => {
    if (quantity.value > 1) {
        quantity.value--
    }
}

const addToCart = async () => {
    if (!isInStock.value) {
        toast.error(t('out_of_stock'))
        return
    }

    addingToCart.value = true
    try {
        await store.dispatch('addItem', {
            productId: product.value.id,
            quantityGrams: quantity.value * (product.value.weight_per_unit || 1)
        })
        toast.success(`${product.value.title} ${t('added_to_cart')}`)
        await store.dispatch('fetchCart')
    } catch (error) {
        console.error('Add to cart error:', error)
        toast.error(error.response?.data?.message || t('add_to_cart_error'))
    } finally {
        addingToCart.value = false
    }
}

const fetchProduct = async () => {
    const slug = route.params.slug
    if (!slug) {
        error.value = t('product_not_found')
        return
    }

    loading.value = true
    error.value = null

    try {
        // Fetch product details
        const response = await store.dispatch('product/fetchProductBySlug', slug)
        product.value = response
        // console.log(product.value.id)

        // Fetch related products
        if (product.value.category_id) {
            const related = await store.dispatch('product/fetchRelatedProducts', {
                categoryId: product.value.category_id,
                productId: product.value.id,
                // limit: 5
            })
            relatedProducts.value = related || []
        }
    } catch (err) {
        console.error('Error fetching product:', err)
        error.value = err.message || t('error_loading_product')
    } finally {
        loading.value = false
    }
}

const navigateToProduct = (slug) => {
    router.push({ name: 'product-details', params: { slug } })
}

// Watch for slug changes
watch(() => route.params.slug, () => {
    currentImageIndex.value = 0
    quantity.value = 1
    fetchProduct()
})

// Lifecycle
onMounted(() => {
    fetchProduct()
})
</script>

<style scoped>
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.prose {
    max-width: 100%;
}

.prose p {
    margin-bottom: 0.5rem;
}

.prose ul {
    list-style-type: disc;
    padding-left: 1.5rem;
}
</style>
