<template>
    <footer class="bg-gray-800 text-white py-12">
        <div class="container mx-auto px-4">
            <!-- Main Footer Content -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-8 lg:justify-items-center">

                <!-- Contact Us Section -->
                <div>
                    <h3 class="text-xl font-bold mb-4">{{ t('contact_us') }}</h3>
                    <div class="space-y-3">
                        <p class="text-gray-300 flex items-start gap-2"
                            :class="{ 'flex-row-reverse': currentDirection === 'rtl' }">
                            <span>📍</span>
                            <span> {{ currentLanguage === 'ar' ? footerSettings['address_ar'] || 'القاهرة - مدينة نصر' :
                                footerSettings['address_en'] || 'Cairo - Nasr City' }}<br>
                            </span>

                        </p>
                        <p class="text-gray-300 flex items-center gap-2"
                            :class="{ 'flex-row-reverse': currentDirection === 'rtl' }">
                            <span>💬</span>
                            <a href="#" class="hover:text-blue-400 transition">{{footerSettings['whatsapp'] || '+201003452188'}}</a>
                        </p>
                        <p class="text-gray-300 flex items-center gap-2"
                            :class="{ 'flex-row-reverse': currentDirection === 'rtl' }">
                            <span>✉️</span>
                            <a href="mailto:info@shop_plants.com" class="hover:text-blue-400 transition">{{footerSettings['email'] ||'info@shop_plants.com'}}</a>
                        </p>
                    </div>
                </div>

                <!-- About Us Section -->
                <div>
                    <h3 class="text-xl font-bold mb-4">{{ t('about_us') }}</h3>
                    <ul class="space-y-2">
                        <li>
                            <a href="/account" class="text-gray-300 hover:text-blue-400 transition">{{ t('my_account')
                                }}</a>
                        </li>
                        <li>
                            <a href="/about" class="text-gray-300 hover:text-blue-400 transition">{{ t('about_us_link')
                                }}</a>
                        </li>
                        <li>
                            <a href="/contact" class="text-gray-300 hover:text-blue-400 transition">{{
                                t('contact_us_link') }}</a>
                        </li>
                        <li>
                            <a href="/account?tab=wishlist" class="text-gray-300 hover:text-blue-400 transition">{{
                                t('wishlist') }}</a>
                        </li>
                    </ul>
                </div>

                <!-- Information Section -->
                <div>
                    <h3 class="text-xl font-bold mb-4">{{ t('information') }}</h3>
                    <ul class="space-y-2">
                        <li>
                            <a href="/faq" class="text-gray-300 hover:text-blue-400 transition">{{ t('faq') }}</a>
                        </li>
                        <li>
                            <a href="/home" class="text-gray-300 hover:text-blue-400 transition">{{ t('home') }}</a>
                        </li>
                        <li>
                            <a href="/shop" class="text-gray-300 hover:text-blue-400 transition">{{ t('shop') }}</a>
                        </li>
                        <li>
                            <a href="/faq" class="text-gray-300 hover:text-blue-400 transition">{{ t('shipping_policy')
                                }}</a>
                        </li>

                        <li>
                            <a href="/faq" class="text-gray-300 hover:text-blue-400 transition">{{ t('return_policy')
                                }}</a>
                        </li>
                        <li>
                            <a href="/services" class="text-gray-300 hover:text-blue-400 transition">{{ t('services')
                                }}</a>
                        </li>
                    </ul>
                </div>
            </div>


            <!-- Copyright Section -->
            <div class="border-t border-gray-700 pt-8 text-center text-gray-400 text-sm">
                <p>
                    © 2026 {{ t('website_name') }}. {{ t('all_rights_reserved') }} |
                    {{ t('design_by') }}
                    <a href="http://protofilio.byethost22.com/" target="_blank" rel="noopener noreferrer"
                        class="text-green-400 hover:text-green-300 transition">
                        Plants Store
                    </a>
                </p>
            </div>
        </div>
    </footer>
</template>

<script>
import { useLanguage } from '../composables/useLanguage.js';
import { useStore } from 'vuex'
import { computed, onMounted } from 'vue';
export default {
    name: 'Footer',
    props: {
        showNewsletter: {
            type: Boolean,
            default: false
        }


    },
    data() {
        return {
            email: ''
        }
    },
  setup() {
        const store = useStore();
        const { t, currentDirection, currentLanguage } = useLanguage();

        // Reactive footer settings
        const footerSettings = computed(() => store.state.footerSettings || {});

        // Fetch data when component is mounted
        onMounted(() => {
            store.dispatch('fetchHomeData'); // or 'fetchFooterSettings' if you have a dedicated action
        });

        return {
            t,
            currentDirection,
            currentLanguage,
            footerSettings
        };
    },

    mounted() {

        // Listen for language changes if needed
        window.addEventListener('language-changed', (event) => {
            // Force re-render if needed
            this.$forceUpdate();
        });


    },
    beforeUnmount() {
        window.removeEventListener('language-changed', () => { });
    }
};
</script>

<style scoped>
/* Optional: Add any custom styles if needed */
</style>
