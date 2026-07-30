<!-- components/ImageModal.vue -->
<template>
    <div v-if="image"
         class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-90 p-4"
         @click="$emit('close')">
        <div class="relative max-w-4xl w-full max-h-[90vh]" @click.stop>
            <!-- Close Button -->
            <button @click="$emit('close')"
                    class="absolute -top-12 right-0 text-white hover:text-gray-300 transition-colors">
                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>

            <!-- Image -->
            <img :src="image"
                 alt="Review image"
                 class="w-full h-full object-contain rounded-lg" />
        </div>
    </div>
</template>

<script setup>
defineProps({
    image: {
        type: String,
        default: null
    }
});

defineEmits(['close']);
</script>
  <!-- <div v-if="isHomeLoading" class="flex justify-center items-center py-20">
              <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
            </div> -->

        <!-- <div v-if="isLoading" class="flex justify-center items-center py-20">
                <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-500 border-t-transparent"></div>
                <p class="mr-3 rtl:ml-3 rtl:mr-0 text-gray-600">{{ t("loading") }}</p>
            </div> -->
