<template>
    <home-layout>
        <div class="min-h-screen bg-gray-50">
            <!-- Hero Section -->
            <section class="relative bg-linear-to-r from-green-700 to-green-800 py-20 md:py-28 overflow-hidden">
                <!-- Background Pattern -->
                <div class="absolute inset-0 opacity-10">
                    <div
                        class="absolute top-0 left-0 w-64 h-64 bg-white rounded-full -translate-x-1/2 -translate-y-1/2">
                    </div>
                    <div
                        class="absolute bottom-0 right-0 w-96 h-96 bg-white rounded-full translate-x-1/2 translate-y-1/2">
                    </div>
                </div>

                <div class="relative container mx-auto px-4 text-center text-white">
                    <h1 data-aos="fade-up" data-aos-duration="1000"
                        class="text-4xl md:text-5xl lg:text-6xl font-bold mb-4">
                        <span class="border-b-4 border-yellow-400 pb-2">{{ t('our_services') }}</span>
                    </h1>
                    <p data-aos="fade-up" data-aos-duration="1000" data-aos-delay="200"
                        class="text-lg md:text-xl text-green-100 max-w-3xl mx-auto mt-6">
                        {{ t('contact_hero_description') }}
                    </p>
                </div>
            </section>


            <section data-aos="fade-up" data-aos-duration="1000" class="container mx-auto px-4 mt-12 mb-16  bg-gray-50">
                <Services :services="homeServices" :home-settings="homeSettings" />
            </section>


        </div>
    </home-layout>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useStore } from 'vuex';

import AOS from 'aos'
import 'aos/dist/aos.css'
import HomeLayout from "../components/HomeLayout.vue";
import Services from '../components/HomeServices.vue';


import { useLanguage } from '../composables/useLanguage.js';

const { t, currentLanguage } = useLanguage();

// Store & Language
const store = useStore();

const homeServices = computed(() => store.state.homeServices || []);
const homeSettings = computed(() => store.state.homeSettings || {})


// Lifecycle
onMounted(() => {
    // Start data fetching
    store.dispatch('fetchHomeData');
    AOS.init({
        once: true,
        duration: 1000,
        easing: 'ease-out-cubic',
        offset: 50
    })

});


</script>

<style scoped>
/* Custom animations */
@keyframes float {

    0%,
    100% {
        transform: translateY(0);
    }

    50% {
        transform: translateY(-10px);
    }
}

/* Smooth transitions */
.transition-all {
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 300ms;
}




/* Responsive adjustments */
@media (max-width: 640px) {
    .container {
        padding-left: 1rem;
        padding-right: 1rem;
    }
}

/* RTL Support */
[dir="rtl"] .space-x-4> :not([hidden])~ :not([hidden]) {
    --tw-space-x-reverse: 1;
}

[dir="rtl"] .flex-row-reverse {
    flex-direction: row;
}

[dir="rtl"] .text-left {
    text-align: right;
}

[dir="rtl"] .text-right {
    text-align: left;
}
</style>
