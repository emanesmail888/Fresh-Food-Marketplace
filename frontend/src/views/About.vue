<template>
    <home-layout>
        <div class="about-page" :dir="currentDirection">

            <!-- Loading State -->
            <!-- <div v-if="loading" class="flex justify-center items-center py-20">
                <div class="text-center">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600 mx-auto"></div>
                    <p class="mt-4 text-gray-600">{{ t('loading') || 'Loading...' }}</p>
                </div>
            </div> -->

            <!-- Content -->
            <!-- <template v-else> -->
            <!-- Hero Section -->
            <section class="relative bg-linear-to-r from-emerald-50 to-amber-50 py-20 overflow-hidden">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="flex flex-col md:flex-row items-center gap-12">
                        <div class="md:w-1/2" data-aos="fade-right">
                            <span
                                class="inline-block px-4 py-1 bg-emerald-100 text-emerald-700 rounded-full text-sm font-medium mb-4">
                                {{ t('about_us') }}
                            </span>
                            <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-gray-800 mb-6">
                                {{ t('about_hero_title') }}
                                <span class="text-emerald-600">{{ t('about_hero_highlight') }}</span>
                            </h1>
                            <p class="text-lg text-gray-600 mb-8 leading-relaxed">
                                {{ t('about_hero_description') }}
                            </p>
                            <div class="flex flex-wrap gap-4">
                                <router-link to="/shop"
                                    class="px-8 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors duration-300 font-medium inline-flex items-center gap-2">
                                    {{ t('shop_now') }}
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M17 8l4 4m0 0l-4 4m4-4H3" />
                                    </svg>
                                </router-link>
                                <router-link to="/contact"
                                    class="px-8 py-3 bg-white text-gray-700 rounded-lg hover:bg-gray-50 transition-colors duration-300 font-medium border border-gray-300">
                                    {{ t('contact_us') }}
                                </router-link>
                            </div>
                        </div>
                        <!-- <div class="md:w-1/2" data-aos="fade-left">
                            <div class="grid grid-cols-2 gap-4">
                                <img src="" alt="Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover">
                                <img src="" alt="Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover mt-8">
                                <img src="" alt="Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover -mt-8">
                                <img src="" alt="Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover">
                            </div>
                        </div> -->

                        <!-- <div class="md:w-1/2" data-aos="fade-left">
                            <div class="grid grid-cols-2 gap-4">
                                <img v-for="(img, i) in heroImages.slice(0, 4)" :key="i" :src="getFullImageUrl(img)"
                                    alt="Farm & Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover"
                                    :style="{ marginTop: i % 2 === 1 ? '2rem' : '0' }">
                            </div>
                        </div> -->
                        <!-- Hero Images Section -->
                        <div class="md:w-1/2" data-aos="fade-left">
                            <div class="grid grid-cols-2 gap-4">
                                <!-- Loading / Placeholder State -->
                                <template v-if="heroImages.length === 0">



                                    <!-- <div v-for="n in 4" :key="'skeleton-' + n"
                                        class="rounded-2xl shadow-lg w-full h-64 bg-gray-200 animate-pulse flex items-center justify-center overflow-hidden relative"
                                        :class="{
                                            'mt-8': n === 2,
                                            '-mt-8': n === 3
                                        }">
                                        <div class="flex flex-col items-center justify-center">
                                            <i class="fas fa-image text-4xl text-gray-300 mb-2"></i>
                                            <span class="text-gray-400 text-sm font-medium">Loading image...
                                                <img src="../assets/images/about_images/1.webp" alt="Plants"
                                                    class="rounded-2xl shadow-lg w-full h-64 object-cover">
                                                <img src="../assets/images/about_images/2.webp" alt="Plants"
                                                    class="rounded-2xl shadow-lg w-full h-64 object-cover mt-8">
                                                <img src="../assets/images/about_images/3.webp" alt="Plants"
                                                    class="rounded-2xl shadow-lg w-full h-64 object-cover -mt-8">
                                                <img src="../assets/images/about_images/4.webp" alt="Plants"
                                                    class="rounded-2xl shadow-lg w-full h-64 object-cover">

                                            </span>

                                        </div>

                                    </div> -->


                                    <div class="relative rounded-2xl shadow-lg w-full h-64 overflow-hidden">
                                        <!-- Overlay (loading) -->
                                        <div class="absolute inset-0 bg-gray-200/70 animate-pulse z-10"></div>

                                        <!-- Image -->
                                        <img src="../assets/images/about_images/1.webp" alt="Plants"
                                            class="w-full h-full object-cover z-0"
                                            />
                                    </div>
                                    <div class="relative rounded-2xl shadow-lg w-full h-64 overflow-hidden">
                                        <!-- Overlay (loading) -->
                                        <div class="absolute inset-0 bg-gray-200/70 animate-pulse z-10"></div>

                                        <!-- Image -->
                                        <img src="../assets/images/about_images/2.webp" alt="Plants"
                                            class="w-full h-full object-cover z-0"
                                            />
                                    </div>
                                    <div class="relative rounded-2xl shadow-lg w-full h-64 overflow-hidden">
                                        <!-- Overlay (loading) -->
                                        <div class="absolute inset-0 bg-gray-200/70 animate-pulse z-10"></div>

                                        <!-- Image -->
                                        <img src="../assets/images/about_images/3.webp" alt="Plants"
                                            class="w-full h-full object-cover z-0"
                                            />
                                    </div>
                                    <div class="relative rounded-2xl shadow-lg w-full h-64 overflow-hidden">
                                        <!-- Overlay (loading) -->
                                        <div class="absolute inset-0 bg-gray-200/70 animate-pulse z-10"></div>

                                        <!-- Image -->
                                        <img src="../assets/images/about_images/4.webp" alt="Plants"
                                            class="w-full h-full object-cover z-0"
                                            />
                                    </div>

                                </template>

                                <!-- Real Images when loaded -->
                                <template v-else>
                                    <img v-for="(img, i) in heroImages.slice(0, 4)" :key="i" :src="getFullImageUrl(img)"
                                        alt="Farm & Plants" class="rounded-2xl shadow-lg w-full h-64 object-cover"
                                        :style="{ marginTop: i % 2 === 1 ? '2rem' : '0' }" loading="lazy">
                                </template>
                            </div>
                        </div>




                    </div>
                </div>
            </section>

            <!-- Stats Section -->
            <section class="py-16 bg-white">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                        <div v-for="(stat, index) in stats" :key="index" class="text-center" :data-aos="'fade-up'"
                            :data-aos-delay="index * 100">
                            <div class="text-4xl md:text-5xl font-bold text-emerald-600 mb-2">{{ stat.value }}</div>
                            <div class="text-gray-600 font-medium">{{ t(stat.labelKey) }}</div>
                        </div>
                    </div>
                </div>
            </section>



            <!-- Our Story Section -->
            <section class="py-16 bg-gray-50">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="flex flex-col md:flex-row items-center gap-12">
                        <div v-if="storyImage" class="md:w-1/2" data-aos="fade-right">

                            <img :src="getFullImageUrl(storyImage)" alt="Our Story"
                                class="rounded-2xl shadow-lg w-full h-96 object-cover">
                        </div>
                        <div v-else class="md:w-1/2" data-aos="fade-right">

                            <img src="../assets/images/main_about_image.webp" alt="Our Story"
                                class="rounded-2xl shadow-lg w-full h-96 object-cover">
                        </div>


                        <div class="md:w-1/2" data-aos="fade-left">
                            <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-6">
                                {{ t('our_story_title') }}
                            </h2>
                            <p class="text-gray-600 leading-relaxed mb-4">
                                {{ t('our_story_text1') }}
                            </p>
                            <p class="text-gray-600 leading-relaxed mb-6">
                                {{ t('our_story_text2') }}
                            </p>
                            <div class="flex items-center gap-4">
                                <div class="flex -space-x-2">
                                    <img src="/images/team/team-1.jpg" class="w-12 h-12 rounded-full border-2 border-white object-cover">
                                    <img src="/images/team/team-2.jpg" class="w-12 h-12 rounded-full border-2 border-white object-cover">
                                    <img src="/images/team/team-3.jpg" class="w-12 h-12 rounded-full border-2 border-white object-cover">
                                </div>
                                <span class="text-gray-600 text-sm">{{ t('happy_team') }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Multi-Image Gallery Section - Tidy Arrangement -->
            <section class="py-16 bg-white">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="text-center mb-12" data-aos="fade-up">
                        <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-4">
                            {{ t('gallery_title') }}
                        </h2>
                        <p class="text-gray-600 max-w-2xl mx-auto">
                            {{ t('gallery_subtitle') }}
                        </p>
                    </div>

                    <!-- Gallery Grid - Tidy Masonry Style -->
                    <div class="gallery-grid">
                        <!-- Large Image -->
                        <div class="gallery-item gallery-item-large" data-aos="zoom-in" data-aos-duration="600">
                            <img :src="getFullImageUrl(fresh_plants)" alt="Plant Store" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('fresh_plants') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('daily_arrivals') }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Medium Images -->
                        <div class="gallery-item gallery-item-medium" data-aos="zoom-in" data-aos-delay="100"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(succulents)" alt="Succulents" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('succulents') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('easy_care') }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="gallery-item gallery-item-medium" data-aos="zoom-in" data-aos-delay="200"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(flowering_plants)" alt="Flowering Plants" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('flowering_plants') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('beautiful_blooms') }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Small Images -->
                        <div class="gallery-item gallery-item-small" data-aos="zoom-in" data-aos-delay="300"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(fresh_herbs)" alt="Herbs" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('fresh_herbs') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('aromatic') }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="gallery-item gallery-item-small" data-aos="zoom-in" data-aos-delay="400"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(garden_tools)" alt="Garden Tools" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('garden_tools') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('quality_equipment') }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="gallery-item gallery-item-small" data-aos="zoom-in" data-aos-delay="500"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(premium_seeds)" alt="Seeds" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('premium_seeds') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('grow_your_own') }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="gallery-item gallery-item-small" data-aos="zoom-in" data-aos-delay="600"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(indoor_plants)" alt="Indoor Plants" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('indoor_plants') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('home_decor') }}</p>
                                </div>
                            </div>
                        </div>

                        <div class="gallery-item gallery-item-small" data-aos="zoom-in" data-aos-delay="700"
                            data-aos-duration="600">
                            <img :src="getFullImageUrl(pots_planters)" alt="Pots & Planters" class="gallery-image">
                            <div class="gallery-overlay">
                                <div class="gallery-overlay-content">
                                    <h3 class="text-xl font-bold text-white">{{ t('pots_planters') }}</h3>
                                    <p class="text-white/80 text-sm">{{ t('stylish_containers') }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Values Section -->
            <section class="py-16 bg-emerald-50">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="text-center mb-12" data-aos="fade-up">
                        <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-4">
                            {{ t('our_values_title') }}
                        </h2>
                        <p class="text-gray-600 max-w-2xl mx-auto">
                            {{ t('our_values_subtitle') }}
                        </p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div v-for="(value, index) in values" :key="index"
                            class="bg-white p-8 rounded-2xl shadow-md hover:shadow-xl transition-shadow duration-300 text-center"
                            :data-aos="'fade-up'" :data-aos-delay="index * 100">
                            <div
                                class="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i :class="value.icon" class="text-2xl text-emerald-600"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-800 mb-3">{{ t(value.titleKey) }}</h3>
                            <p class="text-gray-600 leading-relaxed">{{ t(value.descriptionKey) }}</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Team Section -->
            <section class="py-16 bg-white">
                <div class="container mx-auto px-4 md:px-8">
                    <div class="text-center mb-12" data-aos="fade-up">
                        <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-4">
                            {{ t('meet_our_team') }}
                        </h2>
                        <p class="text-gray-600 max-w-2xl mx-auto">
                            {{ t('team_subtitle') }}
                        </p>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                        <div v-for="(member, index) in team" :key="index" class="text-center group"
                            :data-aos="'fade-up'" :data-aos-delay="index * 100">
                            <div class="relative overflow-hidden rounded-2xl mb-4">
                                <img :src="getTeamImageUrl(member.image)" :alt="member.name"
                                    class="w-full h-64  object-cover group-hover:scale-105 transition-transform duration-300">
                                <div
                                    class="absolute inset-0 bg-emerald-600/0 group-hover:bg-emerald-600/20 transition-colors duration-300">
                                </div>
                            </div>
                            <h4 class="text-lg font-semibold text-gray-800">{{ member.name }}</h4>
                            <p class="text-sm text-emerald-600">{{ t(member.roleKey) }}</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- CTA Section -->
            <section class="py-16 bg-emerald-600">
                <div class="container mx-auto px-4 md:px-8 text-center" data-aos="fade-up">
                    <h2 class="text-3xl md:text-4xl font-bold text-white mb-4">
                        {{ t('cta_title') }}
                    </h2>
                    <p class="text-emerald-100 max-w-2xl mx-auto mb-8">
                        {{ t('cta_subtitle') }}
                    </p>
                    <router-link to="/shop"
                        class="inline-flex items-center gap-2 px-8 py-3 bg-white text-emerald-600 rounded-lg hover:bg-gray-100 transition-colors duration-300 font-medium">
                        {{ t('explore_plants') }}
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17 8l4 4m0 0l-4 4m4-4H3" />
                        </svg>
                    </router-link>
                </div>
            </section>
            <!-- </template> -->

        </div>
    </home-layout>
</template>
<script>
import { computed, onMounted } from 'vue'; // onMounted not needed if using options API
import store from "../store/index.js";
import { useLanguage } from '../composables/useLanguage.js';
import HomeLayout from '../components/HomeLayout.vue';
import AOS from 'aos';
import 'aos/dist/aos.css';

import {
    getSessionData,
    setSessionData,
    hasValidSessionData,
    SessionStorageKeys
} from '../utils/sessionStorage.js';

export default {
    name: 'AboutPage',
    components: {
        HomeLayout
    },
    setup() {
        const { currentLanguage, currentDirection, t } = useLanguage();
        return { currentLanguage, currentDirection, t };
    },
    data() {
        return {
            loading: true,

            stats: [
                { value: '10K+', labelKey: 'happy_customers' },
                { value: '500+', labelKey: 'plant_varieties' },
                { value: '99%', labelKey: 'satisfaction_rate' },
                { value: '24/7', labelKey: 'customer_support' }
            ],
            values: [
                {
                    icon: 'fas fa-seedling',
                    titleKey: 'quality_title',
                    descriptionKey: 'quality_description'
                },
                {
                    icon: 'fas fa-hand-holding-heart',
                    titleKey: 'sustainability_title',
                    descriptionKey: 'sustainability_description'
                },
                {
                    icon: 'fas fa-users',
                    titleKey: 'community_title',
                    descriptionKey: 'community_description'
                }
            ],
            team: [
                { name: 'Ahmed Hassan', image: '/images/team/team-1.jpg', roleKey: 'role_owner' },
                { name: 'Sara Mohamed', image: '/images/team/team-4.jpg', roleKey: 'role_horticulturist' },
                { name: 'Khaled Ali', image: '/images/team/team-2.jpg', roleKey: 'role_manager' },
                { name: 'Nora Ibrahim', image: '/images/team/team-5.jpg', roleKey: 'role_designer' }
            ]
        };
    },
    computed: {
        aboutSettings() {
            return store.state.aboutSettings || {};
        },
        storageBase() {
            return import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/storage';
        },

        heroImages() {
            let raw = this.aboutSettings.about_images || '';
            if (!raw) return [];

            // Handle stringified JSON
            if (typeof raw === 'string') {
                try {
                    const parsed = JSON.parse(raw);
                    if (Array.isArray(parsed)) {
                        return parsed;
                    }
                } catch (e) {
                    // Fallback: comma separated
                    return raw.split(',').map(img => img.trim()).filter(Boolean);
                }
            }
            return Array.isArray(raw) ? raw : [raw].filter(Boolean);
        },

        // galleryImages() {
        //     let raw = this.aboutSettings.gallery_images || '';
        //     if (!raw) return [];

        //     if (typeof raw === 'string') {
        //         try {
        //             const parsed = JSON.parse(raw);
        //             if (Array.isArray(parsed)) {
        //                 return parsed;
        //             }
        //         } catch (e) {
        //             return raw.split(',').map(img => img.trim()).filter(Boolean);
        //         }
        //     }
        //     return Array.isArray(raw) ? raw : [];
        // },

        storyImage() {
            const path = this.aboutSettings.story_image;
            return path ? `${this.storageBase}/${path}` : '';
        },
        fresh_plants() {
            const path = this.aboutSettings.fresh_plants;
            return path ? `${this.storageBase}/${path}` : '';
        },
        succulents() {
            const path = this.aboutSettings.succulents;
            return path ? `${this.storageBase}/${path}` : '';
        },
        flowering_plants() {
            const path = this.aboutSettings.flowering_plants;
            return path ? `${this.storageBase}/${path}` : '';
        },
        fresh_herbs() {
            const path = this.aboutSettings.fresh_herbs;
            return path ? `${this.storageBase}/${path}` : '';
        },
        garden_tools() {
            const path = this.aboutSettings.garden_tools;
            return path ? `${this.storageBase}/${path}` : '';
        },
        premium_seeds() {
            const path = this.aboutSettings.premium_seeds;
            return path ? `${this.storageBase}/${path}` : '';
        },
        indoor_plants() {
            const path = this.aboutSettings.indoor_plants;
            return path ? `${this.storageBase}/${path}` : '';
        },
        pots_planters() {
            const path = this.aboutSettings.pots_planters;
            return path ? `${this.storageBase}/${path}` : '';
        }

    },
    methods: {

// ✅ Updated fetchProducts with proper session handling
 async getAboutSettings() {
    try {
        // Check if we have valid session data
        const hasSession = hasValidSessionData(SessionStorageKeys.ABOUT_SETTINGS);

        if (hasSession) {
            // ✅ Restore from session
            const aboutData = getSessionData(SessionStorageKeys.ABOUT_SETTINGS);
            if (aboutData) {
                store.commit('SET_ABOUT_SETTINGS', aboutData);
                 this.loading = false;

                try {

                     await store.dispatch('getAboutSettings');


                } catch (err) {
                    console.warn('No session data, using cached data:', err);
                }
            }
        } else {
            // ❌ No session data, fetch from API
            // console.log('⏳ No session data, fetching from API...');
              this.loading = true;

            try {
                await store.dispatch('getAboutSettings');
                console.log('✅ About settings loaded:', this.aboutSettings);
            } catch (error) {
                console.error('❌ Error fetching about settings:', error);
            }
            finally {
                this.loading = false;
            }



        }
    } catch (error) {
        console.error("Error fetching products:", error);
        this.loading = false;


    }
},
        // async getAboutSettings() {
        //     this.loading = true;

        //     try {
        //         await store.dispatch('getAboutSettings');
        //         console.log('✅ About settings loaded:', this.aboutSettings);
        //     } catch (error) {
        //         console.error('❌ Error fetching about settings:', error);
        //     }
        //     finally {
        //         this.loading = false;
        //     }
        // },
        getFullImageUrl(imagePath) {
            if (!imagePath) return '';
            return imagePath.startsWith('http')
                ? imagePath
                : `${this.storageBase}/${imagePath}`;
        },

        getTeamImageUrl(path) {
            if (!path) return '/images/placeholder.jpg';
            if (path.startsWith('http')) return path;
            return path.startsWith('/') ? path : path;
        }
    },
    mounted() {
        this.getAboutSettings();
        AOS.init({
            duration: 1000,
            once: true,
            offset: 120,
            easing: 'ease-in-out'
        });
    },
    //    async mounted() {
    //         await this.getAboutSettings();           // ← Now properly defined as method
    //         AOS.init({
    //             duration: 1000,
    //             once: true,
    //             offset: 120,
    //             easing: 'ease-in-out'
    //         });
    //     },
    updated() {
        AOS.refresh();
    }
};
</script>

<style scoped>
/* Gallery Grid Styles */
.gallery-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: 200px;
    gap: 16px;
    padding: 0;
}

.gallery-item {
    position: relative;
    overflow: hidden;
    border-radius: 16px;
    cursor: pointer;
}

.gallery-item-large {
    grid-column: span 2;
    grid-row: span 2;
}

.gallery-item-medium {
    grid-column: span 2;
    grid-row: span 1;
}

.gallery-item-small {
    grid-column: span 1;
    grid-row: span 1;
}

.gallery-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.gallery-item:hover .gallery-image {
    transform: scale(1.1);
}

/* Gallery Overlay */
.gallery-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to top, rgba(0, 0, 0, 0.7) 0%, transparent 60%);
    opacity: 0;
    transition: opacity 0.3s ease;
    display: flex;
    align-items: flex-end;
    padding: 20px;
}

.gallery-item:hover .gallery-overlay {
    opacity: 1;
}

.gallery-overlay-content {
    color: white;
    transform: translateY(20px);
    transition: transform 0.3s ease;
}

.gallery-item:hover .gallery-overlay-content {
    transform: translateY(0);
}

/* Responsive Gallery */
@media (max-width: 1024px) {
    .gallery-grid {
        grid-template-columns: repeat(3, 1fr);
        grid-auto-rows: 180px;
    }

    .gallery-item-large {
        grid-column: span 2;
        grid-row: span 2;
    }
}

@media (max-width: 768px) {
    .gallery-grid {
        grid-template-columns: repeat(2, 1fr);
        grid-auto-rows: 160px;
        gap: 12px;
    }

    .gallery-item-large {
        grid-column: span 2;
        grid-row: span 1;
    }

    .gallery-item-medium {
        grid-column: span 1;
        grid-row: span 1;
    }
}

@media (max-width: 480px) {
    .gallery-grid {
        grid-template-columns: repeat(2, 1fr);
        grid-auto-rows: 140px;
        gap: 8px;
    }

    .gallery-item-large {
        grid-column: span 2;
        grid-row: span 1;
    }

    .gallery-item-medium {
        grid-column: span 1;
        grid-row: span 1;
    }

    .gallery-item-small {
        grid-column: span 1;
        grid-row: span 1;
    }
}

/* RTL Support */
[dir="rtl"] .gallery-overlay-content {
    text-align: right;
}

/* Animation Enhancements */
[data-aos] {
    opacity: 0;
    transition-property: transform, opacity;
}

[data-aos].aos-animate {
    opacity: 1;
}

/* Stat Number Animation */
.stats-number {
    font-size: 3rem;
    font-weight: 700;
    color: #059669;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .about-page .hero-section {
        padding: 3rem 0;
    }

    .stats-number {
        font-size: 2rem;
    }
}
</style>
