<template>
  <section class="hero-banner relative h-125 md:h-150 flex items-center overflow-hidden">
    <!-- Background Image -->
    <img
      :src="HeroImage ? HeroImage : `${storageBase}/${homeSettings['hero_image']}`"
      :width="1200"
      :height="600"
      alt="Fresh Organic Products"
      class="absolute inset-0 w-full h-full object-cover"
      fetchpriority="high"
    />

    <!-- Dark Overlay -->
    <div class="absolute inset-0 bg-linear-to-r from-black/70 via-black/50 to-transparent"></div>

    <!-- Content -->
    <div class="relative z-10 max-w-4xl mx-auto px-6 md:px-10 text-white">
      <div class="max-w-lg">
        <!-- Title with AOS -->
        <h1
          data-aos="fade-up"
          data-aos-duration="2000"
          data-aos-delay="600"
          class="text-4xl md:text-6xl font-bold leading-tight mb-6"
        >
          {{ currentLanguage === 'ar' ? homeSettings['hero_title_ar'] || 'طازج من المزرعة' : homeSettings['hero_title_en'] || 'Fresh From Farm' }}<br>
          <span class="text-yellow-400">{{ currentLanguage === 'ar' ? homeSettings['hero_sub_title_ar'] || 'إلى طاولتك' : homeSettings['hero_sub_title_en'] || 'To Your Table' }}</span>
        </h1>

        <!-- Description  -->
        <p
          data-aos="fade-up"
          data-aos-duration="2500"
          data-aos-delay="800"
          class="text-lg md:text-xl text-gray-200 mb-8"
        >
          {{ currentLanguage === 'ar' ? (homeSettings['hero_description_ar'] || 'بذور عالية الجودة، منتجات عضوية، وخدمات استثنائية. مزروعة بحب، ومُسلّمة بعناية.') : (homeSettings['hero_description_en'] || 'Premium quality seeds, organic products & exceptional services. Grown with love, delivered with care.') }}
        </p>

        <!-- Buttons  -->
        <div
          data-aos="fade-up"
          data-aos-duration="2500"
          data-aos-delay="800"
          class="flex flex-wrap gap-4"
        >
          <button
            @click="scrollToShop"
            class="bg-green-600 hover:bg-green-700 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 flex items-center gap-2"
          >
            {{ t('shop_now') }}
            <span>→</span>
          </button>

          <button
            @click="scrollToCategories"
            class="border-2 border-white hover:bg-white hover:text-black px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300"
          >
            {{ t('browse_categories') }}
          </button>
        </div>
      </div>
    </div>


  </section>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import HeroImage from "../assets/images/hero_image.webp"
import { useLanguage } from '../composables/useLanguage.js'
import AOS from 'aos'
import 'aos/dist/aos.css'

const props = defineProps({
  homeSettings: {
    type: Object,
    default: () => ({})
  }
})

// Store
const store = useStore();
const router = useRouter();

// Language
const { currentLanguage, currentDirection, t } = useLanguage();

// Constants
const storageBase = import.meta.env.VITE_STORAGE_URL ;

// Computed - Store State
const homeSettings = computed(() => props.homeSettings || {})

const scrollToShop = () => {
  router.push({ name: 'shop' })
}

const scrollToCategories = () => {
  document.getElementById('categories-section')?.scrollIntoView({ behavior: 'smooth' })
}

// Initialize AOS
onMounted(() => {
  AOS.init({
    once: true,
    duration: 1000,
    easing: 'ease-out-cubic',
    offset: 50
  })
})
</script>

<style scoped>
.hero-banner {
  contain: layout paint;
}

/*Add custom AOS animations */
[data-aos] {
  pointer-events: none;
}

[data-aos].aos-animate {
  pointer-events: auto;
}
</style>
