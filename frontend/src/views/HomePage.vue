<template>
  <HomeLayout>
    <!-- Loading screen -->
    <div
      v-if="showLoading && !hasSessionData"
      class="fixed inset-0 bg-white flex items-center justify-center z-50"
    >
      <div class="text-center loader-container">
        <img
          :src="loadingGif"
          alt="Loading..."
          class="w-24 h-24 md:w-32 md:h-32 object-contain mx-auto drop-animation"
        />
      </div>
    </div>

    <!-- Main content with AOS animations -->
    <template v-else>
      <!-- Hero Banner - Fade in from top -->
      <div data-aos="fade-down" data-aos-duration="1000">
        <HeroBanner :home-settings="homeSettings"/>
      </div>

      <!-- Categories - Fade in from left -->
      <section
        id="categories-section"
        class="bg-gray-50"
        data-aos="fade-right"
        data-aos-duration="800"
        data-aos-delay="100"
      >
        <CategoriesList :categories="allCategories" />
      </section>

      <!-- Featured Products - Fade up with stagger -->
      <section
        class="py-12 bg-gray-50"
        data-aos="fade-up"
        data-aos-duration="800"
        data-aos-delay="200"
      >
        <FeaturedProducts :products="homeProducts"/>
      </section>

      <!-- Green Vegetables - Zoom in -->
      <section
        class="bg-gray-50"
        data-aos="zoom-in"
        data-aos-duration="900"
        data-aos-delay="300"
      >
        <GreenVegetables :green-vegetables-products="homeGreenVegetablesProducts"/>
      </section>

      <!-- Services - Fade up with longer delay -->
      <section
        class="py-12 bg-gray-50"
        data-aos="fade-up"
        data-aos-duration="800"
        data-aos-delay="400"
      >
        <Services
          class="bg-gray-50"
          :services="homeServices"
          :home-settings="homeSettings"
        />
      </section>

      <!-- Seeds - Fade up from bottom -->
      <div
        class="w-full mx-auto px-4 py-8"
        data-aos="fade-up"
        data-aos-duration="1000"
        data-aos-delay="500"
      >
        <Seed
          :seeds-products="homeSeedsProducts"
          :error="homeError"
        />
      </div>
    </template>
  </HomeLayout>
</template>

<script setup>
import { computed, onMounted, ref, onBeforeUnmount, nextTick } from 'vue';
import { useStore } from 'vuex';
import { useLanguage } from '../composables/useLanguage.js';
import AOS from 'aos';
import 'aos/dist/aos.css';

// Import Components
import HomeLayout from '../components/HomeLayout.vue';
import CategoriesList from '../components/CategoriesList.vue';
import FeaturedProducts from '../components/FeaturedProducts.vue';
import Seed from '../components/Seed.vue';
import Services from '../components/HomeServices.vue';
import HeroBanner from '../components/HeroBanner.vue';
import loadingGif from '../assets/images/loading.gif';
import GreenVegetables from '../components/GreenVegetables.vue';

const store = useStore();
const { t } = useLanguage();

// States
const showLoading = ref(true);
let loadingTimer = null;

// Computed from store
const homeProducts = computed(() => store.state.homeProducts?.data || []);
const homeSeedsProducts = computed(() => store.state.homeSeedsProducts || []);
const homeGreenVegetablesProducts = computed(() => store.state.homeGreenVegetablesProducts || []);
const homeServices = computed(() => store.state.homeServices || []);
const homeSettings = computed(() => store.state.homeSettings || {});
const allCategories = computed(() => store.state.HomeCategories || []);
const homeError = computed(() => store.state.homeError);

// Check if we have session data
const hasSessionData = computed(() => {
  try {
    const products = sessionStorage.getItem('home_products');
    const services = sessionStorage.getItem('home_services');
    const seeds = sessionStorage.getItem('home_seeds_products');
    const green_vegetables = sessionStorage.getItem('home_green_vegetables_products');
    return !!(products && services && seeds && green_vegetables);
  } catch {
    return false;
  }
});

// Restore data from session storage
const restoreFromSession = () => {
  try {
    const products = JSON.parse(sessionStorage.getItem('home_products'));
    const services = JSON.parse(sessionStorage.getItem('home_services'));
    const seeds = JSON.parse(sessionStorage.getItem('home_seeds_products'));
    const green_vegetables = JSON.parse(sessionStorage.getItem('home_green_vegetables_products'));
    const categories = JSON.parse(sessionStorage.getItem('home_categories'));
    const settings = JSON.parse(sessionStorage.getItem('home_settings'));
    const footer = JSON.parse(sessionStorage.getItem('footer_settings'));

    if (products?.data) store.commit('SET_HOME_PRODUCTS', products.data);
    if (services?.data) store.commit('SET_HOME_SERVICES', services.data);
    if (seeds?.data) store.commit('SET_HOME_SEEDS_PRODUCTS', seeds.data);
    if (green_vegetables?.data) store.commit('SET_HOME_GREEN_VEGETABLES_PRODUCTS', green_vegetables.data);
    if (categories?.data) store.commit('SET_HOME_CATEGORIES', categories.data);
    if (settings?.data) store.commit('SET_HOME_SETTINGS', settings.data);
    if (footer?.data) store.commit('SET_FOOTER_SETTINGS', footer.data);

    store.commit('SET_IS_DATA_LOADED', true);
    return true;
  } catch (error) {
    console.error('Failed to restore from session:', error);
    return false;
  }
};

// Initialize AOS
const initAOS = () => {
  AOS.init({
    // Global settings
    duration: 800, // Animation duration
    once: true, // Whether animation should happen only once
    mirror: false, // Whether elements should animate out when scrolling past them
    offset: 120, // Offset (in px) from the original trigger point
    delay: 50, // Default delay for animations
    easing: 'ease-out-cubic', // Default easing function
    disable: false, // Disable on mobile? (false = enabled on all devices)
    startEvent: 'DOMContentLoaded', // Event that triggers animation
    throttleDelay: 99, // Throttle delay for scroll events
  });
};

// Refresh AOS when new content is added
const refreshAOS = () => {
  AOS.refresh();
};

onMounted(() => {
  // 🚀 STEP 1: Check if session data exists
  if (hasSessionData.value) {
    console.log('✅ Session data found! Displaying instantly...');

    // Restore data from session
    restoreFromSession();

    // ✅ Hide loading immediately
    showLoading.value = false;

    // Initialize AOS after content is rendered
    nextTick(() => {
      initAOS();
    });

    // 📡 Refresh data in background (silent update)
    store.dispatch('fetchHomeData').catch(err => {
      console.warn('Background refresh failed:', err);
    });

  } else {
    // ❌ No session data - show loading and fetch
    console.log('⏳ No session data, loading from API...');

    // Start data fetching
    store.dispatch('fetchHomeData');

    // Hide loading after 3 seconds (or when data loads)
    loadingTimer = setTimeout(() => {
      showLoading.value = false;

      // Initialize AOS after loading is hidden
      nextTick(() => {
        initAOS();
      });
    }, 3000);
  }
});

onBeforeUnmount(() => {
  if (loadingTimer) clearTimeout(loadingTimer);
  // Refresh AOS to clean up
  AOS.refreshHard();
});
</script>

<style scoped>
/* Your existing styles... */
.fixed {
    background-color: #ffffff !important;
}

.loader-container {
    animation: fadeIn 0.5s ease-in-out;
}

.drop-animation {
    animation: dropFromTop 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

@keyframes dropFromTop {
    0% {
        opacity: 0;
        transform: translateY(-200px) scale(0.5);
    }
    60% {
        opacity: 1;
        transform: translateY(10px) scale(1.05);
    }
    80% {
        transform: translateY(-5px) scale(0.98);
    }
    100% {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
}

.animate-pulse {
    animation: pulse 1.5s ease-in-out infinite;
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

@keyframes fadeOut {
    from {
        opacity: 1;
    }
    to {
        opacity: 0;
    }
}

.fixed.fade-out {
    animation: fadeOut 0.5s ease-in-out forwards;
}

/* Additional custom animations you can add */
[data-aos] {
    pointer-events: none;
}
[data-aos].aos-animate {
    pointer-events: auto;
}
</style>
