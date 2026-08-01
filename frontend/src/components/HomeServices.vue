<template>

    <div class="container mx-auto px-4" :dir="currentDirection">
      <!-- Section Title -->
       <div class="text-center mb-12">
            <div class="flex items-center justify-center gap-4 mb-4">
                <div class="h-px w-12 bg-linear-to-r from-transparent to-yellow-500"></div>
                <span class="text-yellow-600 font-semibold text-sm uppercase tracking-wider">
                    {{ t("our_help") || "how can we help you?" }}
                </span>
                <div class="h-px w-12 bg-linear-to-l from-transparent to-yellow-500"></div>
            </div>

            <h2 class="text-4xl md:text-3xl font-bold text-yellow-800 mb-3">
                {{ t("our_services") }}
            </h2>
            <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                {{ t("our_services_subtitle") || "Explore the range of services we offer to help you grow and maintain your garden." }}
            </p>
        </div>

      <!-- Loading State -->
      <!-- <div v-if="isHomeLoading" class="flex justify-center items-center py-20">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div> -->

      <!-- Content -->
      <div v-if="services.length > 0" class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-center">
        <!-- Left Column - Services -->
        <div  class="lg:col-span-3 space-y-6" >
          <div
            v-for="service in leftServices"
            :key="service.id"
            class="border border-gray-200   rounded-lg relative hover:shadow-lg transition-shadow bg-yellow-50"
            :class="{ 'text-right': currentDirection === 'rtl' }"
          >
            <div  :class="['p-5', currentDirection === 'rtl' ? 'pl-16' : 'pr-16']">
              <h5 class="text-xl text-green-800 font-bold mb-2">
                {{ currentLanguage === 'ar' && service.title_ar ? service.title_ar : service.title }}
              </h5>
              <hr class="w-12 h-0.5  border-green-800 bg-green-800 my-3 " :class="{ 'ml-auto': currentDirection === 'rtl' }">
              <p class="text-gray-600 mb-0">
                {{ currentLanguage === 'ar' && service.description_ar ? service.description_ar : service.description }}
              </p>
            </div>
            <div :class="['absolute top-1/2 transform -translate-y-1/2', currentDirection === 'rtl' ? '-left-4 md:-left-5' : '-right-4 md:-right-5']">
              <span class="inline-flex w-16 h-16 bg-yellow-100 text-gray-900 rounded-full items-center justify-center shadow-lg">
                <img
                  :src="getServiceImage(service.image)"
                  :alt="service.title"
                  class="w-6 h-6 md:w-8 md:h-8 object-contain"
                />
              </span>
            </div>
          </div>
        </div>

        <!-- Center Column - Image -->
        <div class="lg:col-span-6">
          <div class="flex justify-center">
            <img
              :src="`${storageBase}/${homeSettings['service_main_image']}`"
              alt="Our Services"
                decoding="async"
                width="800"
                height="600"
                class="w-full max-w-md mx-auto rounded-lg shadow-xl"
                style="aspect-ratio: 800/600; object-fit: cover;"
            >
          </div>
        </div>
        <!-- Center Column - Image -->
        <!-- <div class="lg:col-span-6">
          <div class="flex justify-center">
            <img
              :src="getMainServiceImage()"
              alt="Our Services"
              loading="lazy"
              decoding="async"
              width="800"
              height="600"
              class="w-full max-w-md mx-auto rounded-lg shadow-xl"
              style="aspect-ratio: 800/600; object-fit: cover;"
            >
          </div>
        </div> -->

        <!-- Right Column - Services -->
        <div class="lg:col-span-3 space-y-6">
          <div
            v-for="service in rightServices"
            :key="service.id"

            class="border border-gray-200 rounded-lg relative hover:shadow-lg transition-shadow bg-yellow-50"
            :class="{ 'text-right': currentDirection === 'rtl' }"
          >
            <div :class="['p-5', currentDirection === 'rtl' ? 'pr-16' : 'pl-16', currentDirection === 'rtl' ? 'text-left' : 'text-right']">
              <h5 class="text-xl text-green-800 font-bold mb-2">
                {{ currentLanguage === 'ar' && service.title_ar ? service.title_ar : service.title }}
              </h5>
              <hr class="w-12 h-0.5  border-green-800 bg-green-800 my-3" :class="{ 'mr-auto': currentDirection === 'rtl', 'ml-auto': currentDirection !== 'rtl' }">
              <p class="text-gray-600 mb-0">
                {{ currentLanguage === 'ar' && service.description_ar ? service.description_ar : service.description }}
              </p>
            </div>
            <div :class="['absolute top-1/2 transform -translate-y-1/2', currentDirection === 'rtl' ? '-right-4 md:-right-5' : '-left-4 md:-left-5']">
              <span class="inline-flex w-16 h-16 bg-yellow-100 text-gray-900 rounded-full items-center justify-center shadow-lg">
                <img
                  :src="getServiceImage(service.image)"
                  :alt="service.title"
                  class="w-6 h-6 md:w-8 md:h-8 object-contain"
                />
              </span>
            </div>
          </div>
        </div>
      </div>


    </div>
</template>

<script setup>
import { computed, onMounted, watch } from 'vue'
import { useStore } from 'vuex'
import AOS from 'aos'
import 'aos/dist/aos.css'


const props = defineProps({
  services: {
    type: Array,
    default: () => []
  },
  homeSettings: {
    type: Object,
    default: () => ({})
  }
})
import { useLanguage } from '../composables/useLanguage.js'

// Store
const store = useStore();

// Language
const { currentLanguage, currentDirection, t } = useLanguage();

// Constants
const storageBase = import.meta.env.VITE_STORAGE_URL ;

// Computed - Store State

const services = computed(() => props.services || [])
const homeSettings = computed(() => props.homeSettings || {})
// const services = computed(() => {
//   const data = store.state.HomeServices || [];

//   return data;
// });
// const homeSettings = computed(() => store.state.homeSettings || {});

// Computed - Split Services
const leftServices = computed(() => services.value.slice(0, 3));
const rightServices = computed(() => services.value.slice(3, 6));

// Methods
const getServiceImage = (imagePath) => {
  if (!imagePath) {
    return getDefaultIcon();
  }
  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  return `${storageBase}/${imagePath}`;
};

const getDefaultIcon = () => {
  const defaultSvg = `<svg fill="none" stroke="#1b7d4c" stroke-width="1.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z"/>
  </svg>`;
  return `data:image/svg+xml,${encodeURIComponent(defaultSvg)}`;
};

const getMainServiceImage = () => {
  const image = homeSettings.value['service_main_image']
  if (!image) {
    return 'https://via.placeholder.com/800x600?text=Services'
  }
  if (image.startsWith('http')) {
    return image
  }
  return `${storageBase}/${image}`
}


</script>
<style scoped>

</style>


