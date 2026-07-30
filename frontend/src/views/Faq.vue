<template>
    <home-layout>

        <section class="faq-section py-16 bg-gray-50" :dir="currentDirection">
            <div class="container mx-auto px-4 md:px-8">
                <!-- Section Header -->
                <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-4" data-aos="fade-up"
                        data-aos-duration="800">
                        {{ t('faq_title') }}
                    </h2>
                    <p class="text-gray-600 max-w-2xl mx-auto" data-aos="fade-up" data-aos-delay="200"
                        data-aos-duration="800">
                        {{ t('faq_subtitle') }}
                    </p>
                </div>

                <!-- Category Filters -->
                <div class="flex flex-wrap justify-center gap-3 mb-10" data-aos="fade-up" data-aos-delay="100">
                    <button
                        v-for="category in categories"
                        :key="category.key"
                        @click="filterCategory = category.key"
                        class="px-5 py-2 rounded-full text-sm font-medium transition-colors duration-300"
                        :class="filterCategory === category.key
                            ? 'bg-emerald-600 text-white'
                            : 'bg-white text-gray-700 hover:bg-gray-100 border border-gray-200'"
                    >
                        {{ t(category.translationKey) }}
                    </button>
                </div>

                <!-- FAQ Items -->
                <div class="max-w-3xl mx-auto">
                    <div v-for="(faq, index) in filteredFaqs" :key="faq.id" class="mb-4"
                        :data-aos="index % 2 === 0 ? 'fade-right' : 'fade-left'"
                        :data-aos-delay="index * 100"
                        data-aos-duration="600" data-aos-offset="100">
                        <div
                            class="bg-white rounded-xl shadow-md hover:shadow-lg transition-shadow duration-300 overflow-hidden border border-gray-100">
                            <!-- Question -->
                            <button @click="toggleFaq(index)"
                                class="w-full px-6 py-5 flex items-center justify-between text-left focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-opacity-50"
                                :aria-expanded="activeIndex === index" :aria-controls="`faq-content-${index}`">
                                <span class="text-lg font-semibold text-gray-800 pr-4"
                                      :class="{ 'text-right': currentDirection === 'rtl' }">
                                    {{ t(faq.questionKey) }}
                                </span>
                                <span
                                    class="flex-shrink-0 ml-4 w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-600 transition-transform duration-300"
                                    :class="{ 'rotate-180': activeIndex === index }">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 9l-7 7-7-7" />
                                    </svg>
                                </span>
                            </button>

                            <!-- Answer -->
                            <transition enter-active-class="transition-all duration-300 ease-in-out"
                                leave-active-class="transition-all duration-300 ease-in-out"
                                enter-class="max-h-0 opacity-0" enter-to-class="max-h-96 opacity-100"
                                leave-class="max-h-96 opacity-100" leave-to-class="max-h-0 opacity-0">
                                <div v-if="activeIndex === index" :id="`faq-content-${index}`" class="px-6 pb-5"
                                    role="region" :aria-labelledby="`faq-question-${index}`">
                                    <div class="pt-2 border-t border-gray-100">
                                        <p class="text-gray-600 leading-relaxed"
                                           :class="{ 'text-right': currentDirection === 'rtl' }"
                                           v-html="t(faq.answerKey)">
                                        </p>
                                        <!-- Optional: Additional content like links or icons -->
                                        <div v-if="faq.link" class="mt-3"
                                             :class="{ 'text-right': currentDirection === 'rtl' }">
                                            <a :href="faq.link.url"
                                                class="text-emerald-600 hover:text-emerald-700 font-medium inline-flex items-center gap-1"
                                                :class="{ 'flex-row-reverse': currentDirection === 'rtl' }">
                                                {{ t(faq.link.textKey) }}
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                                                </svg>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </transition>
                        </div>
                    </div>
                </div>

                <!-- No Results Message -->
                <div v-if="filteredFaqs.length === 0" class="text-center py-8">
                    <p class="text-gray-600">{{ t('no_faqs_found') }}</p>
                </div>

                <!-- Footer CTA -->
                <div class="text-center mt-12" data-aos="fade-up" data-aos-delay="400" data-aos-duration="800">
                    <p class="text-gray-600 mb-4">
                        {{ t('still_have_questions') }}
                    </p>
                    <router-link to="/contact"
                        class="inline-flex items-center gap-2 px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors duration-300 font-medium"
                        :class="{ 'flex-row-reverse': currentDirection === 'rtl' }">
                        {{ t('contact_us') }}
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17 8l4 4m0 0l-4 4m4-4H3" />
                        </svg>
                    </router-link>
                </div>
            </div>
        </section>
    </home-layout>
</template>

<script>
import { useLanguage } from '../composables/useLanguage.js';
import HomeLayout from '../components/HomeLayout.vue';
import AOS from 'aos';
import 'aos/dist/aos.css';

export default {
    name: 'FaqSection',

    components: {
        HomeLayout
    },

    setup() {
        const { currentLanguage, currentDirection, t } = useLanguage();
        return { currentLanguage, currentDirection, t };
    },

    data() {
        return {
            activeIndex: null,
            filterCategory: 'all',
            categories: [
                { key: 'all', translationKey: 'all_categories' },
                { key: 'shipping', translationKey: 'shipping' },
                { key: 'returns', translationKey: 'returns' },
                { key: 'payments', translationKey: 'payments' },
                { key: 'products', translationKey: 'products' }
            ],
            faqs: [
                {
                    id: 1,
                    questionKey: 'faq_shipping_question',
                    answerKey: 'faq_shipping_answer',
                    category: 'shipping'
                },
                {
                    id: 2,
                    questionKey: 'faq_shipping_area_question',
                    answerKey: 'faq_shipping_area_answer',
                    category: 'shipping'
                },
                {
                    id: 3,
                    questionKey: 'faq_return_question',
                    answerKey: 'faq_return_answer',
                    category: 'returns'
                },
                {
                    id: 4,
                    questionKey: 'faq_return_period_question',
                    answerKey: 'faq_return_period_answer',
                    category: 'returns'
                },
                {
                    id: 5,
                    questionKey: 'faq_payment_question',
                    answerKey: 'faq_payment_answer',
                    category: 'payments'
                },
                {
                    id: 6,
                    questionKey: 'faq_product_freshness_question',
                    answerKey: 'faq_product_freshness_answer',
                    category: 'products'
                },
                {
                    id: 7,
                    questionKey: 'faq_bulk_order_question',
                    answerKey: 'faq_bulk_order_answer',
                    category: 'products'
                }
            ]
        };
    },

    computed: {
        filteredFaqs() {
            if (this.filterCategory === 'all') {
                return this.faqs;
            }
            return this.faqs.filter(faq => faq.category === this.filterCategory);
        }
    },

    mounted() {
        this.initAOS();
    },

    methods: {
        toggleFaq(index) {
            this.activeIndex = this.activeIndex === index ? null : index;
            this.$nextTick(() => {
                AOS.refresh();
            });
        },

        initAOS() {
            AOS.init({
                duration: 1000,
                once: true,
                offset: 120,
                easing: 'ease-in-out',
            });
        }
    },

    updated() {
        AOS.refresh();
    },

    beforeUnmount() {
        // Clean up if needed
    }
};
</script>

<style scoped>
/* Custom styles for better animation */
.faq-section {
    min-height: 600px;
}

/* Hover effect for FAQ items */
.faq-item:hover {
    transform: translateY(-2px);
    transition: transform 0.3s ease;
}

/* AOS animation enhancements */
[data-aos] {
    opacity: 0;
    transition-property: transform, opacity;
}

[data-aos].aos-animate {
    opacity: 1;
}

/* Smooth scroll behavior */
.faq-section {
    scroll-behavior: smooth;
}

/* Accessibility improvements */
button:focus-visible {
    outline: 2px solid #059669;
    outline-offset: 2px;
}

/* RTL Support */
[dir="rtl"] .faq-section {
    text-align: right;
}

[dir="rtl"] .flex-row-reverse {
    flex-direction: row-reverse;
}

[dir="rtl"] .ml-4 {
    margin-left: 0;
    margin-right: 1rem;
}

[dir="rtl"] .pr-4 {
    padding-right: 0;
    padding-left: 1rem;
}

/* Responsive adjustments */
@media (max-width: 640px) {
    .faq-section {
        padding: 3rem 0;
    }

    .faq-section h2 {
        font-size: 1.75rem;
    }

    .faq-section .px-6 {
        padding-left: 1rem;
        padding-right: 1rem;
    }

    .flex-wrap {
        gap: 0.5rem;
    }
}
</style>
