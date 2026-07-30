<!-- components/account/ReviewsList.vue -->
<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-800">{{ t('my_reviews') }}</h2>
            <span class="text-sm text-gray-500">{{ reviews.length }} {{ t('reviews') }}</span>
        </div>

        <div v-if="loading" class="flex justify-center py-10">
            <div class="animate-spin rounded-full h-10 w-10 border-4 border-green-500 border-t-transparent"></div>
        </div>

        <div v-else-if="reviews.length === 0" class="text-center py-10">
            <svg class="w-24 h-24 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
            </svg>
            <p class="text-gray-500">{{ t('no_reviews_yet') }}</p>
            <router-link to="/shop" class="text-green-600 hover:text-green-700 font-medium mt-2 inline-block">
                {{ t('browse_products') }}
            </router-link>
        </div>

        <div v-else class="space-y-4">
            <div v-for="review in reviews" :key="review.id"
                class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">

                <!-- Review Header -->
                <div class="flex items-start justify-between">
                    <div class="flex-1">
                        <!-- Product Info -->
                        <router-link :to="`/product/${review.product?.slug}`"
                                     class="font-semibold text-gray-800 hover:text-green-600 transition-colors">
                            {{ review.product?.title || t('product_not_available') }}
                        </router-link>

                        <!-- Rating Stars -->
                        <div class="flex items-center gap-2 mt-1">
                            <div class="flex">
                                <span v-for="n in 5" :key="n" class="text-lg">
                                    {{ n <= (review.rating || 0) ? '⭐' : '☆' }}
                                </span>
                            </div>
                            <span v-if="review.is_verified" class="text-xs text-green-600 bg-green-50 px-2 py-0.5 rounded-full">
                                ✅ {{ t('verified_purchase') }}
                            </span>
                            <span class="text-xs text-gray-400">{{ formatDate(review.created_at) }}</span>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex gap-2">
                        <button @click="editReview(review)"
                                class="text-blue-600 hover:text-blue-700 text-sm font-medium">
                            {{ t('edit') }}
                        </button>
                        <button @click="deleteReview(review.id)"
                                class="text-red-600 hover:text-red-700 text-sm font-medium">
                            {{ t('delete') }}
                        </button>
                    </div>
                </div>

                <!-- Review Content -->
                <p v-if="review.comment" class="mt-2 text-gray-600 text-sm">
                    {{ review.comment }}
                </p>

                <!-- Review Images -->
                <div v-if="getReviewImages(review).length > 0" class="mt-3 grid grid-cols-4 gap-2">
                    <div v-for="(image, idx) in getReviewImages(review)" :key="idx"
                        class="aspect-square rounded-lg overflow-hidden cursor-pointer"
                        @click="openImageModal(image)">
                        <img :src="image" :alt="'Review image ' + (idx + 1)"
                            class="w-full h-full object-cover hover:scale-105 transition-transform" />
                    </div>
                </div>

                <!-- Helpful Section -->
                <!-- <div class="mt-3 flex items-center gap-4 text-sm text-gray-500">
                    <button @click="markHelpful(review.id)" class="hover:text-green-600 transition-colors">
                        👍 {{ t('helpful') }} ({{ review.helpful_count || 0 }})
                    </button>
                    <button @click="markNotHelpful(review.id)" class="hover:text-red-600 transition-colors">
                        👎 {{ t('not_helpful') }} ({{ review.not_helpful_count || 0 }})
                    </button>
                </div> -->

                <!-- Reply from Admin (if any) -->
                <div v-if="review.reply" class="mt-3 bg-gray-50 rounded-lg p-3 border-l-4 border-green-500">
                    <p class="text-sm font-medium text-gray-700">{{ t('admin_reply') }}:</p>
                    <p class="text-sm text-gray-600 mt-1">{{ review.reply }}</p>
                    <p class="text-xs text-gray-400 mt-1">{{ formatDate(review.replied_at) }}</p>
                </div>
            </div>
        </div>

        <!-- Pagination -->
        <div v-if="pagination.last_page > 1" class="mt-6 flex justify-center">
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

        <!-- Edit Review Modal -->
        <ReviewForm
            v-if="editingReview"
            :product-id="editReviewData.product_id"
            :editing="true"
            :review-data="editReviewData"
            @submitted="handleReviewUpdated"
            @cancel="editingReview = false"
        />

        <!-- Image Modal -->
        <ImageModal
            v-if="selectedImage"
            :image="selectedImage"
            @close="selectedImage = null"
        />
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../../composables/useLanguage.js';
import ReviewForm from '../ReviewForm.vue';
import ImageModal from '../ImageModal.vue';

const props = defineProps({
    reviews: {
        type: Array,
        default: () => []
    },
    loading: {
        type: Boolean,
        default: false
    },
    pagination: {
        type: Object,
        default: () => ({
            current_page: 1,
            last_page: 1,
            per_page: 10,
            total: 0
        })
    }
});

const emit = defineEmits(['refresh', 'page-change']);

const store = useStore();
const toast = useToast();
const { currentLanguage, t } = useLanguage();

// State
const editingReview = ref(false);
const editReviewData = ref(null);
const selectedImage = ref(null);

// Storage base URL
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";

// Methods
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString(currentLanguage.value === 'ar' ? 'ar-EG' : 'en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};

/**
 * Get review images as array with correct URLs
 */
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
        .map(img => {
            // If it's already a full URL
            if (img.startsWith('http') ) {
               return img;
            }

            return `${storageBase}/${img}`;
        });
};

const editReview = (review) => {
    editingReview.value = true;
    editReviewData.value = review;
};

const deleteReview = async (reviewId) => {
    if (!confirm(t('confirm_delete_review'))) {
        return;
    }

    try {
        await store.dispatch('reviews/deleteReview', reviewId);
        toast.success(t('review_deleted'));
        emit('refresh');
    } catch (error) {
        console.error('Error deleting review:', error);
        toast.error(error.response?.data?.message || t('error_deleting_review'));
    }
};

const handleReviewUpdated = () => {
    editingReview.value = false;
    editReviewData.value = null;
    toast.success(t('review_updated_success'));
    emit('refresh');
};

// const markHelpful = async (reviewId) => {
//     try {
//         await store.dispatch('reviews/markHelpful', reviewId);
//         toast.success(t('marked_helpful'));
//         emit('refresh');
//     } catch (error) {
//         console.error('Error marking helpful:', error);
//         toast.error(t('error_marking_helpful'));
//     }
// };

// const markNotHelpful = async (reviewId) => {
//     try {
//         await store.dispatch('reviews/markNotHelpful', reviewId);
//         toast.success(t('marked_not_helpful'));
//         emit('refresh');
//     } catch (error) {
//         console.error('Error marking not helpful:', error);
//         toast.error(t('error_marking_not_helpful'));
//     }
// };

const openImageModal = (image) => {
    selectedImage.value = image;
};

const changePage = (page) => {
    emit('page-change', page);
};
</script>

<style scoped>
/* Smooth transitions */
.border {
    transition: all 0.2s ease;
}

.group:hover .group-hover\:opacity-100 {
    opacity: 1;
}
</style>
