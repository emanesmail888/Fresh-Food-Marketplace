<!-- components/account/OrdersList.vue -->
<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-800">{{ t('my_orders') }}</h2>
            <span class="text-sm text-gray-500">{{ orders.length }} {{ t('orders') }}</span>
        </div>

        <div v-if="loading" class="flex justify-center py-10">
            <div class="animate-spin rounded-full h-10 w-10 border-4 border-green-500 border-t-transparent"></div>
        </div>

        <div v-else-if="orders.length === 0" class="text-center py-10">
            <svg class="w-24 h-24 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
            </svg>
            <p class="text-gray-500">{{ t('no_orders') }}</p>
            <router-link to="/shop" class="text-green-600 hover:text-green-700 font-medium mt-2 inline-block">
                {{ t('start_shopping') }}
            </router-link>
        </div>

        <div v-else class="space-y-4">
            <div v-for="order in orders" :key="order.id"
                class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">

                <!-- Order Header -->
                <div class="flex flex-wrap items-center justify-between gap-4">
                    <div>
                        <p class="font-semibold text-gray-800">#{{ order.order_number }}</p>
                        <p class="text-sm text-gray-500">{{ formatDate(order.created_at) }}</p>
                    </div>

                    <div>
                        <span class="text-lg font-bold text-green-700">{{ formatPrice(order.total) }}</span>
                    </div>

                    <!-- Order Status -->
                    <div>
                        <span class="px-3 py-1 rounded-full text-sm font-medium" :class="getStatusClass(order.status)">
                            {{ getStatusLabel(order.status) }}
                        </span>
                    </div>

                    <button @click="viewOrder(order.order_number)"
                        class="text-blue-600 hover:text-blue-700 font-medium text-sm">
                        {{ t('view_details') }}
                    </button>
                </div>

                <!-- Order Items Preview with safe checks -->
                <div v-if="order.items && order.items.length > 0" class="mt-3 pt-3 border-t border-gray-100">
                    <div class="flex flex-wrap items-center gap-3">
                        <div v-for="(item, index) in order.items.slice(0, 3)" :key="index" class="flex items-center">
                            <div class="w-10 h-10 bg-gray-100 rounded overflow-hidden">
                                <img v-if="item.product_image" :src="getImageUrl(item.product_image)"
                                    :alt="item.product_name || 'Product'" class="w-full h-full object-cover" />
                                <img v-else-if="item.product && item.product.image"
                                    :src="getImageUrl(item.product.image)" :alt="item.product.title || 'Product'"
                                    class="w-full h-full object-cover" />
                                <div v-else
                                    class="w-full h-full flex items-center justify-center text-gray-400 text-xs">
                                    📦
                                </div>
                            </div>
                            <span class="text-xs text-gray-600 ml-2">
                                 {{ formatItemQuantity(item) }}
                            </span>
                        </div>
                        <span v-if="order.items.length > 3" class="text-xs text-gray-500">
                            +{{ order.items.length - 3 }} {{ t('more') }}
                        </span>
                    </div>
                </div>

                <!-- Payment & Shipping Status -->
                <div class="mt-3 flex flex-wrap items-center gap-4 text-xs text-gray-500">
                    <div class="flex items-center gap-1">
                        <span class="font-medium">{{ t('payment') }}:</span>
                        <span :class="getPaymentStatusClass(order.payment_status)">
                            {{ getPaymentStatusLabel(order.payment_status) }}
                        </span>
                    </div>
                    <div class="flex items-center gap-1">
                        <span class="font-medium">{{ t('shipping') }}:</span>
                        <span :class="getShippingStatusClass(order.shipping_status)">
                            {{ getShippingStatusLabel(order.shipping_status) }}
                        </span>
                    </div>
                    <div v-if="order.tracking_number" class="flex items-center gap-1">
                        <span class="font-medium">{{ t('tracking') }}:</span>
                        <span class="text-blue-600">{{ order.tracking_number }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pagination -->
        <div v-if="pagination && pagination.last_page > 1" class="mt-6 flex justify-center">
            <div class="flex items-center gap-2">
                <button @click="changePage(pagination.current_page - 1)" :disabled="pagination.current_page <= 1"
                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                    {{ t('previous') }}
                </button>
                <span class="px-4 py-2 text-sm text-gray-600">
                    {{ pagination.current_page }} / {{ pagination.last_page }}
                </span>
                <button @click="changePage(pagination.current_page + 1)"
                    :disabled="pagination.current_page >= pagination.last_page"
                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
                    {{ t('next') }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useLanguage } from '../../composables/useLanguage.js';
import { useRouter } from 'vue-router';

const props = defineProps({
    orders: {
        type: Array,
        default: () => []
    },
    loading: {
        type: Boolean,
        default: false
    },
    pagination: {
        type: Object,
        default: () => ({
            current_page: 1,
            last_page: 1,
            per_page: 10,
            total: 0
        })
    }
});

const emit = defineEmits(['refresh', 'page-change']);
const router = useRouter();
const { currentLanguage, t, formatPrice } = useLanguage();

const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";


const unitLabels = {
    kg: {
        en: "kg",
        ar: "كجم",
        convertToGrams: (val) => val * 1000,
        convertFromGrams: (grams) => grams / 1000
    },
    g: {
        en: "g",
        ar: "جم",
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    piece: {
        en: "piece",
        ar: "قطعة",
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    liter: {
        en: "liter",
        ar: "لتر",
        convertToGrams: (val) => val * 1000,
        convertFromGrams: (grams) => grams / 1000
    },
    pack: {
        en: "pack",
        ar: "حزمة",
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    },
    bunch: {
        en: "bunch",
        ar: "حزمة",
        convertToGrams: (val) => val,
        convertFromGrams: (grams) => grams
    }
};

const getUnitConfig = (unit) => {
    return unitLabels[unit] || unitLabels.kg;
};

const getUnitLabel = (unit) => {
    const config = getUnitConfig(unit);
    return currentLanguage.value === "ar" ? config.ar : config.en;
};

// Format item quantity for display
const formatItemQuantity = (item) => {
    // If there's a quantity_display in options, use it
    if (item.options && typeof item.options === 'string') {
        try {
            const options = JSON.parse(item.options);
            if (options.quantity_display) {
                return options.quantity_display;
            }
        } catch (e) {
            // If parsing fails, continue with normal formatting
        }
    }

    // If there's a direct quantity_display field
    if (item.quantity_display) {
        return item.quantity_display;
    }

    // Get unit from item or product
    const unit = item.unit || item.product?.unit || 'kg';
    const config = getUnitConfig(unit);
    const label = getUnitLabel(unit);

    // Get quantity in grams
    const quantityInGrams = item.quantity_grams || 0;

    // If quantity is 0, show 0
    if (quantityInGrams === 0) {
        return `0 ${label}`;
    }

    // Get display quantity based on unit
    let displayQuantity = quantityInGrams;

    if (unit === 'kg') {
        displayQuantity = quantityInGrams / 1000;
        return `${displayQuantity.toFixed(2)} ${label}`;
    } else if (unit === 'liter') {
        displayQuantity = quantityInGrams / 1000;
        return `${displayQuantity.toFixed(2)} ${label}`;
    } else if (unit === 'g') {
        return `${Math.round(displayQuantity)} ${label}`;
    } else {
        // For piece, pack, bunch (whole numbers)
        const quantity = Math.round(quantityInGrams);
        const isArabic = currentLanguage.value === "ar";

        // Handle plural for English only
        if (quantity > 1 && !isArabic) {
            return `${quantity} ${label}s`;
        }
        return `${quantity} ${label}`;
    }
};

const formatDate = (date) => {
    if (!date) return '';
    try {
        return new Date(date).toLocaleDateString(currentLanguage.value === 'ar' ? 'ar-EG' : 'en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        return date;
    }
};

const getImageUrl = (path) => {
    if (!path) return '/images/placeholder.jpg';
    if (path.startsWith('http')) return path;
    return `${storageBase}/${path}`;
};

// Order Status
const getStatusClass = (status) => {
    const classes = {
        'pending': 'bg-yellow-100 text-yellow-800',
        'processing': 'bg-blue-100 text-blue-800',
        'paid': 'bg-indigo-100 text-indigo-800',
        'completed': 'bg-green-100 text-green-800',
        'cancelled': 'bg-red-100 text-red-800',
        'refunded': 'bg-gray-100 text-gray-800',
        'partially_refunded': 'bg-orange-100 text-orange-800'
    };
    return classes[status] || 'bg-gray-100 text-gray-800';
};

const getStatusLabel = (status) => {
    const labels = {
        'pending': t('order_status_pending'),
        'processing': t('order_status_processing'),
        'paid': t('order_status_paid'),
        'completed': t('order_status_completed'),
        'cancelled': t('order_status_cancelled'),
        'refunded': t('order_status_refunded'),
        'partially_refunded': t('order_status_partially_refunded')
    };
    return labels[status] || status;
};

// Payment Status
const getPaymentStatusClass = (status) => {
    const classes = {
        'unpaid': 'text-yellow-600',
        'paid': 'text-green-600',
        'failed': 'text-red-600',
        'refunded': 'text-gray-600',
        'partially_refunded': 'text-orange-600'
    };
    return classes[status] || 'text-gray-600';
};

const getPaymentStatusLabel = (status) => {
    const labels = {
        'unpaid': t('payment_unpaid'),
        'paid': t('payment_paid'),
        'failed': t('payment_failed'),
        'refunded': t('payment_refunded'),
        'partially_refunded': t('payment_partially_refunded')
    };
    return labels[status] || status;
};

// Shipping Status
const getShippingStatusClass = (status) => {
    const classes = {
        'pending': 'text-yellow-600',
        'processing': 'text-blue-600',
        'shipped': 'text-indigo-600',
        'delivered': 'text-green-600',
        'cancelled': 'text-red-600'
    };
    return classes[status] || 'text-gray-600';
};

const getShippingStatusLabel = (status) => {
    const labels = {
        'pending': t('shipping_pending'),
        'processing': t('shipping_processing'),
        'shipped': t('shipping_shipped'),
        'delivered': t('shipping_delivered'),
        'cancelled': t('shipping_cancelled')
    };
    return labels[status] || status;
};

const viewOrder = (orderNumber) => {
    router.push({ name: 'order-details', params: { orderNumber } });
};

const changePage = (page) => {
    emit('page-change', page);
};
</script>

<style scoped>
.border {
    transition: all 0.2s ease;
}

.hover\:shadow-md:hover {
    transform: translateY(-2px);
}
</style>
