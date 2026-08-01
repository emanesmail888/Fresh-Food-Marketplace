<!-- components/ReviewForm.vue -->
<template>
    <div class="bg-white rounded-xl shadow-md p-6 mb-8 border border-gray-200">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">
            {{ editing ? t('edit_review') : t('write_review') }}
        </h3>

        <form @submit.prevent="submitReview" class="space-y-4">
            <!-- Rating Stars -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('your_rating') }} *
                </label>
                <div class="flex gap-2">
                    <button v-for="n in 5" :key="n" type="button"
                        @click="form.rating = n"
                        class="text-4xl transition-transform hover:scale-110 focus:outline-none"
                        :class="[
                            n <= form.rating ? 'text-yellow-400' : 'text-gray-300'
                        ]">
                        ★
                    </button>
                </div>
                <p v-if="errors.rating" class="text-red-600 text-sm mt-1">{{ errors.rating }}</p>
            </div>

            <!-- Comment -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('your_comment') }}
                </label>
                <textarea v-model="form.comment"
                    rows="4"
                    :placeholder="t('share_experience')"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent resize-none"
                    maxlength="1000">
                </textarea>
                <div class="flex justify-end text-sm text-gray-400">
                    {{ form.comment?.length || 0 }}/1000
                </div>
            </div>

            <!-- Images -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('add_photos') }}
                </label>
                <div class="flex items-center gap-4">
                    <label class="cursor-pointer bg-gray-100 hover:bg-gray-200 px-6 py-3 rounded-lg transition-colors">
                        <span class="text-gray-600">{{ t('upload_images') }}</span>
                        <input type="file" multiple accept="image/*"
                            @change="handleImageUpload"
                            class="hidden" />
                    </label>
                    <span v-if="form.images.length > 0" class="text-sm text-green-600">
                        {{ form.images.length }} {{ t('images_uploaded') }}
                    </span>
                </div>
            </div>

            <!-- Image Previews - Updated -->
            <div v-if="form.images.length > 0" class="grid grid-cols-4 gap-2">
                <div v-for="(image, index) in form.images" :key="index"
                    class="relative aspect-square rounded-lg overflow-hidden border group">
                    <img :src="getPreviewUrl(image)"
                         class="w-full h-full object-cover"
                         :alt="'Review image ' + (index + 1)" />

                    <!-- Delete Button - Shows on hover -->
                    <button type="button"
                            @click="removeImage(index)"
                            class="absolute top-1 right-1 bg-red-600 text-white rounded-full p-1 hover:bg-red-700 transition-opacity opacity-0 group-hover:opacity-100">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>

                    <!-- Image Counter -->
                    <div class="absolute bottom-1 left-1 bg-black bg-opacity-60 text-white text-xs px-2 py-0.5 rounded-full">
                        {{ index + 1 }}
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex gap-3 pt-4">
                <button type="submit"
                    :disabled="submitting"
                    class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-3 rounded-lg transition-all disabled:opacity-60 disabled:cursor-not-allowed flex items-center gap-2">
                    <span v-if="submitting" class="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></span>
                    {{ editing ? t('update_review') : t('submit_review') }}
                </button>
                <button type="button" @click="$emit('cancel')"
                    class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold px-6 py-3 rounded-lg transition-all">
                    {{ t('cancel') }}
                </button>
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref, watch, onBeforeUnmount } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../composables/useLanguage.js';

const props = defineProps({
    productId: {
        type: Number,
        required: true
    },
    editing: {
        type: Boolean,
        default: false
    },
    reviewData: {
        type: Object,
        default: null
    }
});

const emit = defineEmits(['submitted', 'cancel']);

const store = useStore();
const toast = useToast();
const { t } = useLanguage();

// Storage base URL
const storageBase = import.meta.env.VITE_STORAGE_URL ;

const form = ref({
    rating: 5,
    comment: '',
    images: []
});

const submitting = ref(false);
const errors = ref({});
const objectUrls = ref([]);

// Watch for edit data
watch(() => props.reviewData, (data) => {
    if (data) {
        form.value.rating = data.rating || 5;
        form.value.comment = data.comment || '';

        // Handle existing images
        if (data.images) {
            let existingImages = [];

            // Parse images if it's a JSON string
            if (typeof data.images === 'string') {
                try {
                    existingImages = JSON.parse(data.images);
                } catch (e) {
                    console.warn('Failed to parse images:', e);
                    existingImages = [];
                }
            } else if (Array.isArray(data.images)) {
                existingImages = data.images;
            }

            // Convert to full URLs and filter out invalid ones
            form.value.images = existingImages
                .filter(img => img) // Remove null/undefined
                .map(img => {
                    // If it's already a full URL
                    if (img.startsWith('http') ) {
                        return img;
                    }

                    return `${storageBase}/${img}`;
                });
        } else {
            form.value.images = [];
        }
    }
}, { immediate: true });

/**
 * Handle image upload
 */
const handleImageUpload = (event) => {
    const files = Array.from(event.target.files);

    if (!files || files.length === 0) {
        return;
    }

    // Limit to 5 images total
    const maxImages = 5;
    const currentCount = form.value.images.filter(img => img instanceof File).length;
    const newCount = files.length;

    if (currentCount + newCount > maxImages) {
        toast.error(t('max_images_limit', { max: maxImages }));
        event.target.value = '';
        return;
    }

    // Check file size (2MB max)
    const maxSize = 2 * 1024 * 1024; // 2MB
    const validFiles = files.filter(file => {
        if (file.size > maxSize) {
            toast.error(`${file.name}: ${t('file_too_large')}`);
            return false;
        }
        return true;
    });

    if (validFiles.length > 0) {
        form.value.images.push(...validFiles);
    }

    // Reset input
    event.target.value = '';
};

/**
 * Get preview URL for image
 */
const getPreviewUrl = (image) => {
    // For new files (uploaded by user)
    if (image instanceof File) {
        const index = form.value.images.indexOf(image);
        if (index !== -1 && objectUrls.value[index]) {
            return objectUrls.value[index];
        }

        const url = URL.createObjectURL(image);
        const fileIndex = form.value.images.indexOf(image);
        objectUrls.value[fileIndex] = url;
        return url;
    }

    // For existing images (strings from database)
    if (typeof image === 'string') {
        // If it's already a full URL
        if (image.startsWith('http://') || image.startsWith('https://')) {
            return image;
        }

        // If it already has /storage/ - return as is
        if (image.startsWith('/storage/')) {
            return image;
        }

        // If it starts with storage/ (no slash)
        if (image.startsWith('storage/')) {
            return '/' + image;
        }

        // Otherwise, prepend /storage/
        const cleanPath = image.replace(/^\/+/, '');
        return `/storage/${cleanPath}`;
    }

    return '/images/placeholder.jpg';
};

/**
 * Remove image by index
 */
const removeImage = (index) => {
    const image = form.value.images[index];

    // If it's a File, revoke object URL
    if (image instanceof File) {
        const url = objectUrls.value[index];
        if (url) {
            URL.revokeObjectURL(url);
            objectUrls.value.splice(index, 1);
        }
    }

    form.value.images.splice(index, 1);
};

/**
 * Submit review
 */
const submitReview = async () => {
    // Validate
    if (!form.value.rating || form.value.rating < 1) {
        errors.value.rating = t('please_select_rating');
        return;
    }

    submitting.value = true;
    errors.value = {};

    try {
        const formData = new FormData();
        formData.append('rating', form.value.rating);
        formData.append('comment', form.value.comment || '');

        // Only append new files (not existing image URLs)
        let imageIndex = 0;
        form.value.images.forEach((image) => {
            if (image instanceof File) {
                formData.append(`images[${imageIndex}]`, image);
                imageIndex++;
            }
        });

        let response;
        if (props.editing && props.reviewData) {
            formData.append('_method', 'PUT');
            response = await store.dispatch('reviews/updateReview', {
                reviewId: props.reviewData.id,
                reviewData: formData
            });
        } else {
            response = await store.dispatch('reviews/submitReview', {
                productId: props.productId,
                reviewData: formData
            });
        }

        // Cleanup object URLs
        objectUrls.value.forEach(url => URL.revokeObjectURL(url));
        objectUrls.value = [];

        emit('submitted', response);
    } catch (error) {
        if (error.response?.data?.errors) {
            errors.value = error.response.data.errors;
        } else {
            toast.error(error.response?.data?.message || t('error_submitting_review'));
        }
    } finally {
        submitting.value = false;
    }
};

// Cleanup on unmount

// const submitReview = async () => {
//     // Reset errors
//     errors.value = {};

//     // Validate rating - يجب أن يكون رقم بين 1 و 5
//     const ratingValue = parseInt(form.value.rating);
//     if (!form.value.rating || isNaN(ratingValue) || ratingValue < 1 || ratingValue > 5) {
//         errors.value.rating = t('please_select_rating');
//         toast.error(t('please_select_rating'));

//         // Scroll to rating section
//         const ratingElement = document.querySelector('.rating-stars-container');
//         if (ratingElement) {
//             ratingElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
//             ratingElement.classList.add('ring-2', 'ring-red-500', 'rounded-lg', 'p-2', 'transition-all', 'duration-300');
//             setTimeout(() => {
//                 ratingElement.classList.remove('ring-2', 'ring-red-500', 'rounded-lg', 'p-2');
//             }, 3000);
//         }
//         return;
//     }

//     // Validate comment (optional but recommended)
//     if (form.value.comment && form.value.comment.length > 1000) {
//         errors.value.comment = t('comment_too_long');
//         toast.error(t('comment_too_long'));
//         return;
//     }

//     submitting.value = true;

//     try {
//         const formData = new FormData();

//         // Append rating as integer
//         formData.append('rating', ratingValue);

//         // Append comment
//         formData.append('comment', form.value.comment?.trim() || '');

//         // Append new image files only (not existing URLs)
//         let imageIndex = 0;
//         form.value.images.forEach((image) => {
//             if (image instanceof File) {
//                 formData.append(`images[${imageIndex}]`, image);
//                 imageIndex++;
//             }
//         });

//         // If editing, add _method for PUT
//         if (props.editing && props.reviewData) {
//             formData.append('_method', 'PUT');
//         }

//         // Dispatch action
//         let response;
//         if (props.editing && props.reviewData) {
//             response = await store.dispatch('reviews/updateReview', {
//                 reviewId: props.reviewData.id,
//                 reviewData: formData
//             });
//         } else {
//             response = await store.dispatch('reviews/submitReview', {
//                 productId: props.productId,
//                 reviewData: formData
//             });
//         }

//         // Cleanup object URLs to prevent memory leaks
//         objectUrls.value.forEach(url => URL.revokeObjectURL(url));
//         objectUrls.value = [];

//         // Success message
//         toast.success(props.editing ? t('review_updated_success') : t('review_submitted_success'));

//         // Emit success event
//         emit('submitted', response);

//     } catch (error) {
//         console.error('Review submission error:', error);

//         // Handle validation errors from backend
//         if (error.response?.data?.errors) {
//             errors.value = error.response.data.errors;

//             // Show specific error messages
//             if (errors.value.rating) {
//                 toast.error(errors.value.rating[0] || t('please_select_rating'));
//             } else if (errors.value.comment) {
//                 toast.error(errors.value.comment[0] || t('please_fix_errors'));
//             } else if (errors.value.images) {
//                 toast.error(errors.value.images[0] || t('image_upload_error'));
//             } else {
//                 toast.error(t('please_fix_errors'));
//             }
//         } else if (error.response?.data?.message) {
//             // Show backend error message
//             toast.error(error.response.data.message);
//         } else {
//             // Generic error
//             toast.error(t('error_submitting_review'));
//         }
//     } finally {
//         submitting.value = false;
//     }
// };

onBeforeUnmount(() => {
    objectUrls.value.forEach(url => URL.revokeObjectURL(url));
    objectUrls.value = [];
});
</script>

<style scoped>
/* Hide delete button by default, show on hover */
.group .opacity-0 {
    opacity: 0;
}

.group:hover .group-hover\:opacity-100 {
    opacity: 1;
}

/* Smooth transition */
.group button {
    transition: opacity 0.2s ease;
}
</style>
