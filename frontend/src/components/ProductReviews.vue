<!-- components/ProductReviews.vue -->
<template>
    <div class="mt-12 border-t border-gray-200 pt-8" :dir="currentDirection">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-800">
                {{ t('reviews') }}
                <span class="text-sm font-normal text-gray-500 ml-2">
                    ({{ stats.total_reviews || 0 }})
                </span>
            </h2>

            <div class="flex items-center gap-4">
                <select v-model="sort" @change="handleSortChange"
                    class="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-green-500 focus:border-transparent">
                    <option value="latest">{{ t('newest_first') }}</option>
                    <option value="highest">{{ t('highest_rating') }}</option>
                    <option value="lowest">{{ t('lowest_rating') }}</option>
                </select>
            </div>
        </div>

        <!-- Rating Summary -->
        <div class="bg-gray-50 rounded-xl p-6 mb-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Average Rating -->
                <div class="text-center">
                    <div class="text-5xl font-bold text-gray-800">
                        {{ getAverageRating() }}
                    </div>
                    <div class="flex justify-center my-2">
                        <span v-for="n in 5" :key="n" class="text-2xl">
                            {{ n <= Math.round(getAverageRatingNumber()) ? '⭐' : '☆' }}
                        </span>
                    </div>
                    <p class="text-sm text-gray-500">
                        {{ stats.total_reviews || 0 }} {{ t('reviews') }}
                    </p>
                    <p v-if="stats.verified_count > 0" class="text-xs text-green-600">
                        ✅ {{ stats.verified_count }} {{ t('verified_purchases') }}
                    </p>
                </div>

                <!-- Rating Distribution -->
                <div class="col-span-2">
                    <div v-for="star in [5,4,3,2,1]" :key="star" class="flex items-center gap-2 mb-2">
                        <span class="text-sm font-medium w-16">{{ star }} ⭐</span>
                        <div class="flex-1 h-3 bg-gray-200 rounded-full overflow-hidden">
                            <div class="h-full bg-yellow-400 rounded-full transition-all duration-500"
                                :style="{ width: getPercentage(star) + '%' }">
                            </div>
                        </div>
                        <span class="text-sm text-gray-500 w-12">
                            {{ getDistributionCount(star) }}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Write Review Button -->
         <div v-if="isAuthenticated" class="mb-10">
            <button v-if="!userReview"
                @click="showReviewForm = true"
                class="flex items-center gap-3 bg-green-600 hover:bg-green-700 text-white font-semibold px-8 py-4 rounded-3xl transition-all active:scale-95 shadow-sm">
                <span class="text-xl">✍️</span>
                {{ t('write_review') }}
            </button>

            <div v-else class="flex items-center justify-between bg-green-50 border border-green-100 p-6 rounded-3xl">
                <div class="flex items-center gap-3 text-green-700">
                    <span class="text-2xl">✅</span>
                    <span class="font-medium">{{ t('you_reviewed_this_product') }}</span>
                </div>
                <button @click="startEditingReview"
                    class="text-blue-600 hover:text-blue-700 font-medium underline underline-offset-4">
                    {{ t('edit_review') }}
                </button>
            </div>
        </div>



        

        <!-- Review Form -->
        <ReviewForm
            v-if="showReviewForm || editingReview"
            :product-id="productId"
            :editing="editingReview"
            :review-data="editReviewData"
            @submitted="handleReviewSubmitted"
            @cancel="handleFormCancel"
        />

        <!-- Reviews List -->
        <div v-if="loading" class="flex justify-center py-10">
            <div class="animate-spin rounded-full h-10 w-10 border-4 border-green-500 border-t-transparent"></div>
        </div>

        <div v-else-if="reviews.length === 0" class="text-center py-10">
            <p class="text-gray-500">{{ t('no_reviews_yet') }}</p>
            <p class="text-sm text-gray-400 mt-2">{{ t('be_first_to_review') }}</p>
        </div>

        <div v-else class="space-y-6">
            <div v-for="review in reviews" :key="review.id"
                class="bg-white rounded-xl shadow-sm hover:shadow-md transition-all p-6 border border-gray-100">

                <!-- Review Header -->
                <div class="flex items-start justify-between">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-700 font-bold text-xl">
                            {{ getUserInitials(review.user) }}
                        </div>
                        <div>
                            <p class="font-semibold text-gray-800">{{ review.user?.name || 'User' }}</p>
                            <div class="flex items-center gap-2">
                                <div class="flex">
                                    <span v-for="n in 5" :key="n" class="text-lg">
                                        {{ n <= (review.rating || 0) ? '⭐' : '☆' }}
                                    </span>
                                </div>
                                <span v-if="review.is_verified" class="text-xs text-green-600 bg-green-50 px-2 py-1 rounded-full">
                                    ✅ {{ t('verified') }}
                                </span>
                            </div>
                            <p class="text-xs text-gray-400">{{ formatDate(review.created_at) }}</p>
                        </div>
                    </div>

                    <!-- Action Buttons for owner -->
                    <div v-if="review.user?.id === currentUser?.id" class="flex gap-2">
                        <button @click="editReview(review)" class="text-blue-600 hover:text-blue-700 text-sm">
                            {{ t('edit') }}
                        </button>
                        <button @click="deleteReview(review.id)" class="text-red-600 hover:text-red-700 text-sm">
                            {{ t('delete') }}
                        </button>
                    </div>
                </div>

                <!-- Review Content -->
                <div v-if="review.comment" class="mt-3 text-gray-600">
                    {{ review.comment }}
                </div>

                <!-- Review Images -->


                 <div v-if="getReviewImages(review).length > 0" class="mt-3 grid grid-cols-4 gap-2">
                    <div v-for="(image, idx) in getReviewImages(review)" :key="idx"
                        class="aspect-square rounded-lg overflow-hidden cursor-pointer"
                        @click="openImageModal(image)">
                        <img :src="image" :alt="'Review image ' + (idx + 1)"
                            class="w-35 h-25 object-cover hover:scale-105 transition-transform"
                            @error="handleImageError" />
                    </div>
                </div>


            </div>
        </div>

        <!-- Pagination -->
        <div v-if="pagination.last_page > 1" class="mt-8 flex justify-center">
            <div class="flex items-center gap-2">
                <button @click="changePage(pagination.current_page - 1)"
                    :disabled="pagination.current_page <= 1"
                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                    {{ t('previous') }}
                </button>
                <span class="px-4 py-2 text-sm text-gray-600">
                    {{ pagination.current_page }} / {{ pagination.last_page }}
                </span>
                <button @click="changePage(pagination.current_page + 1)"
                    :disabled="pagination.current_page >= pagination.last_page"
                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                    {{ t('next') }}
                </button>
            </div>
        </div>

        <!-- Image Modal -->
        <ImageModal
            v-if="selectedImage"
            :image="selectedImage"
            @close="selectedImage = null"
        />
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../composables/useLanguage.js';
import ReviewForm from './ReviewForm.vue';
import ImageModal from './ImageModal.vue';

const props = defineProps({
    productId: {
        type: Number,
        required: true
    }
});

const store = useStore();
const toast = useToast();
const { currentLanguage, currentDirection, t } = useLanguage();
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/"

// State
const showReviewForm = ref(false);
const editingReview = ref(false);
const editReviewData = ref(null);
const selectedImage = ref(null);
const sort = ref('latest');

// Computed
const reviews = computed(() => store.state.reviews?.reviews || []);
const userReview = computed(() => store.state.reviews?.userReview || null);
const stats = computed(() => store.state.reviews?.stats || {
    average_rating: 0,
    total_reviews: 0,
    verified_count: 0,
    rating_distribution: {}
});
const loading = computed(() => store.state.reviews?.loading || false);
const pagination = computed(() => store.state.reviews?.pagination || {
    current_page: 1,
    last_page: 1,
    per_page: 10,
    total: 0
});
const isAuthenticated = computed(() => store.getters.isAuthenticated);
const currentUser = computed(() => store.state.user.data);

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

/**
 * Get distribution count for a specific rating
 */
const getDistributionCount = (rating) => {
    if (!stats.value.rating_distribution) return 0;
    return stats.value.rating_distribution[rating] || 0;
};

/**
 * Get percentage for rating distribution
 */
const getPercentage = (rating) => {
    const total = parseInt(stats.value.total_reviews) || 0;
    if (total === 0) return 0;
    const count = parseInt(getDistributionCount(rating)) || 0;
    return (count / total) * 100;
};

 const getReviewImages = (review) => {
    if (!review) return [];

    let images = [];

    // Case 1: images is a string (JSON)
    if (typeof review.images === 'string') {
        try {
            const parsed = JSON.parse(review.images);
            images = Array.isArray(parsed) ? parsed : [];
        } catch (e) {
            console.warn('Failed to parse review images:', e);
            return [];
        }
    }
    // Case 2: images is already an array
    else if (Array.isArray(review.images)) {
        images = review.images;
    }
    // Case 3: images is null or undefined
    else {
        return [];
    }

    // Process each image to get full URL
    return images
        .filter(img => img) // Remove null/undefined
        .map(img => getImageUrl(img));
};

const fetchReviews = async (page = 1) => {

    await store.dispatch('reviews/fetchReviews', {
        productId: props.productId,
        page
    });
};

const handleSortChange = () => {
    store.dispatch('reviews/setSort', sort.value);
};

const changePage = async (page) => {
    if (page >= 1 && page <= pagination.value.last_page) {
        await fetchReviews(page);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

const handleReviewSubmitted = () => {
    showReviewForm.value = false;
    editingReview.value = false;
    editReviewData.value = null;
    fetchReviews();
    toast.success(t('review_submitted_success'));
};

const handleFormCancel = () => {
    showReviewForm.value = false;
    editingReview.value = false;
    editReviewData.value = null;
};

const editReview = (review) => {
    editingReview.value = true;
    editReviewData.value = review;
};

const deleteReview = async (reviewId) => {
    if (confirm(t('confirm_delete_review'))) {
        try {
            await store.dispatch('reviews/deleteReview', reviewId);
            toast.success(t('review_deleted'));
            fetchReviews();
        } catch (error) {
            toast.error(t('error_deleting_review'));
        }
    }
};

const getImageUrl = (imagePath) => {
    if (!imagePath) return '/images/placeholder.jpg';
     if (imagePath.startsWith("http")) return imagePath;
    return `${storageBase}/${imagePath}`;

};

const getUserInitials = (user) => {
    if (!user || !user.name) return '?';
    return user.name
        .split(' ')
        .map(word => word.charAt(0))
        .join('')
        .toUpperCase()
        .slice(0, 2);
};

const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString(currentLanguage.value === 'ar' ? 'ar-EG' : 'en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};

const openImageModal = (image) => {
    selectedImage.value = getImageUrl(image);
};

// Watch for product changes
watch(() => props.productId, () => {
    if (props.productId) {
        fetchReviews();
    }
});

// Lifecycle
onMounted(() => {
    if (props.productId) {
        fetchReviews();
    }
});
</script>
