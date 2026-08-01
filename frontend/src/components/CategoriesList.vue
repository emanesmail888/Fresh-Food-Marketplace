<template>
  <section class="category-section">
    <div class="section-header pt-8">
         <div class="flex items-center justify-center gap-4 mb-4">
                <div class="h-px w-12 bg-linear-to-r from-transparent to-yellow-500"></div>
                <span class="text-yellow-600 font-semibold text-sm uppercase tracking-wider">
                    {{ t("our_collection") || "Our Collection" }}
                </span>
                <div class="h-px w-12 bg-linear-to-l from-transparent to-yellow-500"></div>
            </div>
      <h2 class=" section-title text-3xl text-yellow-600">{{ t('all_categories') }}</h2>
      <p class="section-subtitle">{{ t('categories_subtitle') || 'Browse our categories' }}</p>

    </div>

     <!-- Loading State -->
    <!-- <div v-if="isHomeLoading" class="loading-state">
      <div class="spinner"></div>
      <p>{{ t('loading') }}</p>
    </div> -->

    <!-- Error State -->
    <div v-if="homeError" class="error-state">
      <p class="error-text">{{ homeError }}</p>
      <button @click="retry" class="retry-btn">{{ t("retry") }}</button>
    </div>

    <!-- Empty State -->
    <div v-else-if="!allCategories?.length" class="empty-state">
      <p>{{ t('no_categories') || 'No categories found' }}</p>
    </div>



    <div v-else class="categories-slider w-full max-w-6xl mx-auto px-4 py-12">
      <swiper :modules="modules"
          :slides-per-view="2"
          :space-between="24"
          :autoplay="{ delay: 4500, disableOnInteraction: false }"
          :breakpoints="breakpoints"
          :loop="true"
          navigation
          pagination>
        <swiper-slide v-for="(category, idx) in allCategories" :key="category.id">
          <div class="category-card"  @click="navigateToCategory(category)"
            role="button"
            tabindex="0"
            @keydown.enter="navigateToCategory(category)">
            <img
              :src="getCategoryImage(category.image)"
              :srcset="getCategorySrcSet(category.image)"
              class="category-image"
              :fetchpriority="idx === 0 ? 'high' : 'auto'"
              :loading="idx === 0 ? 'eager' : 'lazy'"
              decoding="async"
              alt="category"
            />
            <div class="category-title">
              {{ currentLanguage === 'ar' && category.name_ar ? category.name_ar : category.name }}
            </div>
          </div>
        </swiper-slide>
      </swiper>
    </div>
  </section>
</template>


<script setup>
import { ref, computed, onMounted } from "vue";
import { Swiper, SwiperSlide } from "swiper/vue";
import { Navigation, Pagination, Scrollbar } from "swiper/modules";
import { useRouter } from "vue-router";
import { useLanguage } from '../composables/useLanguage';
import { useStore } from 'vuex'
// Import core swiper styles + modules you use
import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";
import "swiper/css/scrollbar";

const { currentLanguage, t } = useLanguage();
const router = useRouter(); // Initialize router
const modules = [Navigation, Pagination, Scrollbar]; // add EffectCards if needed

const storageBase = import.meta.env.VITE_STORAGE_URL ;
const store = useStore()

const isHomeLoading = computed(() => store.state.isHomeLoading);
const homeError = computed(() => store.state.homeError || null)

const props = defineProps({
  categories: { type: Array, default: () => [] }
});

const allCategories = computed(() => props.categories);
const getCategoryImage = (imagePath) => {
  if (!imagePath) return "/images/placeholder.jpg";
  if (imagePath.startsWith("http")) return imagePath;
  return `${storageBase}/${imagePath}`;
};

// Add srcset support (very important for LCP)
const getCategorySrcSet = (imagePath) => {
  if (!imagePath) return '';
  const base = imagePath.startsWith('http') ? '' : storageBase;
  return `
    ${base}/${imagePath} 480w,
    ${base}/thumbnails/${imagePath} 240w
  `.trim();
};

const navigateToCategory = (category) => {
  if (!category) return;

  router.push({
    path: '/category',
    query: {
      category_id: category.id,
      category_name: currentLanguage.value === 'ar' ? category.name_ar : category.name,
      page: 1
    }
  });
};

// Responsive behavior (very important for category sliders)
const breakpoints = {
  // when window width >= 320px
  320: { slidesPerView: 2, spaceBetween: 12 },
  // >= 480px
  640: { slidesPerView: 3, spaceBetween: 16 },
  // >= 768px
  768: { slidesPerView: 4, spaceBetween: 20 },
  // >= 1024px
  1024: { slidesPerView: 5, spaceBetween: 24 },
  // >= 1400px
  1400: { slidesPerView: 6, spaceBetween: 28 },
};
</script>
<style scoped>
.category-section {
  padding: 2rem 1rem;
  background: #f3f0f0;
}

/* ===== HEADER ===== */
.section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.section-title {
  font-size: 2rem;
  font-weight: 700;
  color: #834b1d;
  margin: 0 0 0.50rem 0;
}

.section-subtitle {
  color: #7e7064;
  font-size: 0.95rem;
  margin: 0;
}


/* ===== LOADING ===== */
.loading-state {
  text-align: center;
  padding: 2rem 0;
}

.spinner {
  display: inline-block;
  width: 2.5rem;
  height: 2.5rem;
  border: 3px solid #e5e7eb;
  border-top-color: #fbbf24;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 0.5rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-state p {
  color: #6b7280;
  margin: 0;
}

/* ===== ERROR ===== */
.error-state {
  text-align: center;
  padding: 2rem 0;
}

.error-text {
  color: #dc2626;
  margin: 0 0 1rem 0;
}

.retry-btn {
  background: #fbbf24;
  color: #1a1a2e;
  border: none;
  padding: 0.5rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.retry-btn:hover {
  background: #f59e0b;
}

/* ===== EMPTY ===== */
.empty-state {
  text-align: center;
  padding: 2rem 0;
  color: #6b7280;
}


.categories-slider {
  padding: 12px 0;
  margin: 0 auto;
  max-width: 1400px;
}

.category-card {
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s;
  margin: 20px 0;
    contain: layout paint;


}

.category-card:hover {
  /* transform: translateY(-6px); */
  transform: scale(0.90) translateZ(0);
  transition: .3s;

}

.category-image {
  width: 100%;
  height: 140px;
  object-fit: cover;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  margin-bottom: 10px;

  /* Fix for LCP + CLS */
  display: block;
  background: #f3f4f6;           /* Placeholder color while loading */
  aspect-ratio: 240 / 140;       /* Reserve exact space */
  will-change: transform;
}


.category-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ===== SWIPER CUSTOMIZATION ===== */
:deep(.swiper) {
  padding: 0.5rem 0.25rem 2.5rem;
}

:deep(.swiper-button-next),
:deep(.swiper-button-prev) {
  width: 2.5rem;
  height: 2.5rem;
  background: white;
  border-radius: 50%;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  color: #f59e0b;
  padding: 0.5rem;
  transition: background 0.2s, color 0.2s;
  margin-top: -3.00rem; /* Center vertically */
}

:deep(.swiper-button-next::after),
:deep(.swiper-button-prev::after) {
  font-size: 1rem;
  font-weight: 700;
}

:deep(.swiper-button-disabled) {
  opacity: 0.3;
}

:deep(.swiper-pagination-bullet) {
  background: #756d66;
}


:deep(.swiper-pagination-bullet-active) {
  background: #fbbf24;
}


/* Optional: hide scrollbar but keep functionality */
:deep(.swiper-scrollbar) {
  background: rgba(0, 0, 0, 0.08);
  height: 6px;
  border-radius: 3px;
}
:deep(.swiper-scrollbar-drag) {
  background: #4caf50;
  border-radius: 3px;
}


/* ===== RESPONSIVE ===== */
@media (max-width: 640px) {
  .category-section {
    padding: 1.5rem 0.75rem;
  }

  .section-title {
    font-size: 1.5rem;
  }

  /* .category-image {
    height: 100px;
  } */

  /* .category-name {
    font-size: 0.9rem;
  } */

  :deep(.swiper-button-next),
  :deep(.swiper-button-prev) {
    display: none;
  }
}

/* @media (min-width: 641px) and (max-width: 768px) {
  .category-image {
    height: 120px;
  }
} */
</style>


