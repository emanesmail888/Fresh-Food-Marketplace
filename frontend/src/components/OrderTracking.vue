<template>
  <home-layout>
    <div :dir="currentDirection">
      <!-- Breadcrumb -->
      <section class="py-5">
        <div class="container mx-auto px-4">
          <div class="text-center">
            <h1 class="text-3xl font-bold text-gray-800">{{ t('track_order') }}</h1>
            <h4 class="text-sm mt-3 text-gray-600">
              <router-link to="/" class="text-gray-600 hover:text-green-600 transition-colors">{{ t('home') }}</router-link>
              <span class="text-gray-400 mx-1 text-xs align-middle">›</span>
              <router-link to="/account" class="text-gray-600 hover:text-green-600 transition-colors">{{ t('my_account') }}</router-link>
              <span class="text-gray-400 mx-1 text-xs align-middle">›</span>
              <span class="text-gray-800">{{ t('track_order') }}</span>
            </h4>
          </div>
        </div>
      </section>

      <!-- Tracking Section -->
      <section class="py-8 bg-gray-50 min-h-screen">
        <div class="container mx-auto px-4">
          <div class="max-w-3xl mx-auto">
            <!-- Loading State -->
            <div v-if="loading" class="text-center py-16">
              <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-green-600 border-t-transparent"></div>
              <p class="text-xl text-gray-600 mt-4">{{ t('loading_tracking') }}</p>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="text-center py-16">
              <div class="inline-flex items-center justify-center w-20 h-20 bg-red-100 rounded-full mb-4">
                <svg class="w-10 h-10 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </div>
              <h1 class="text-3xl font-bold text-gray-800 mb-2">{{ t('tracking_not_found') }}</h1>
              <p class="text-gray-600 mb-6">{{ error }}</p>
              <router-link
                to="/account"
                class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg transition-colors"
              >
                {{ t('back_to_profile') }}
              </router-link>
            </div>

            <!-- Tracking Info -->
            <div v-else-if="trackingInfo" class="bg-white rounded-lg shadow-sm overflow-hidden">
              <!-- Order Header -->
              <div class="bg-linear-to-r from-green-600 to-green-700 p-6 text-white">
                <div class="flex flex-wrap justify-between items-center">
                  <div>
                    <p class="text-green-100 text-sm">{{ t('order_number') }}</p>
                    <p class="text-2xl font-bold">{{ trackingInfo.order_number }}</p>
                  </div>
                  <div class="text-right">
                    <p class="text-green-100 text-sm">{{ t('current_status') }}</p>
                    <p class="text-xl font-bold flex items-center">
                      <span class="w-3 h-3 bg-green-300 rounded-full animate-pulse mr-2"></span>
                      {{ formatOrderStatus(trackingInfo.current_status)}}
                    </p>
                  </div>
                </div>
              </div>

              <!-- Progress Tracker -->
              <div class="p-8 border-b border-gray-200">
                <div class="relative">
                  <!-- Progress Bar Background -->
                  <div class="absolute top-5 left-0 w-full h-1 bg-gray-200 rounded"></div>

                  <!-- Progress Bar Fill -->
                  <div
                    class="absolute top-5 left-0 h-1 bg-green-600 rounded transition-all duration-500"
                    :style="{ width: progressPercentage + '%' }"
                  ></div>

                  <!-- Timeline Steps -->
                  <div class="relative flex justify-between">
                    <div v-for="(step, index) in timeline" :key="step.status" class="text-center" style="flex: 1">
                      <!-- Step Icon -->
                      <div
                        class="w-10 h-10 mx-auto rounded-full flex items-center justify-center relative z-10 transition-all duration-300"
                        :class="[
                          step.completed
                            ? 'bg-green-600 text-white'
                            : index === currentStepIndex
                              ? 'bg-green-100 text-green-600 border-2 border-green-600'
                              : 'bg-gray-200 text-gray-400'
                        ]"
                      >
                        <svg v-if="step.completed" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        <span v-else-if="index === currentStepIndex" class="w-2 h-2 bg-green-600 rounded-full animate-pulse"></span>
                        <span v-else class="w-2 h-2 bg-gray-400 rounded-full"></span>
                      </div>

                      <!-- Step Label -->
                      <p class="mt-2 text-sm font-medium" :class="step.completed ? 'text-gray-900' : 'text-gray-500'">
                        {{ step.label}}
                      </p>

                      <!-- Step Date -->
                      <p v-if="step.date" class="text-xs text-gray-500">
                        {{ formatDate(step.date) }}
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Tracking Details -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('tracking_details') }}</h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <!-- Left Column -->
                  <div class="space-y-4">
                    <div>
                      <p class="text-sm text-gray-600">{{ t('payment_status') }}</p>
                      <p class="font-medium" :class="paymentStatusClass(trackingInfo.payment_status)">
                        {{ t(formattedPaymentStatus(trackingInfo.payment_status)) }}
                      </p>
                    </div>

                    <div>
                      <p class="text-sm text-gray-600">{{ t('shipping_status') }}</p>
                      <p class="font-medium text-gray-800">{{ t(trackingInfo.shipping_status) || 'Pending' }}</p>
                    </div>

                    <div v-if="trackingInfo.tracking_number">
                      <p class="text-sm text-gray-600">{{ t('tracking_number') }}</p>
                      <p class="font-medium text-gray-800">{{ trackingInfo.tracking_number }}</p>
                    </div>
                  </div>

                  <!-- Right Column -->
                  <div class="space-y-4">
                    <div>
                      <p class="text-sm text-gray-600">{{ t('carrier') }}</p>
                      <p class="font-medium text-gray-800">{{ t(trackingInfo.carrier) || 'Standard Shipping' }}</p>
                    </div>

                    <div>
                      <p class="text-sm text-gray-600">{{ t('estimated_delivery') }}</p>
                      <p class="font-medium text-gray-800">{{ formatDate(trackingInfo.estimated_delivery) }}</p>
                    </div>

                    <div v-if="trackingInfo.delivered_at">
                      <p class="text-sm text-gray-600">{{ t('delivered_date') }}</p>
                      <p class="font-medium text-gray-800">{{ formatDate(trackingInfo.delivered_at) }}</p>
                    </div>
                  </div>
                </div>

                <div v-if="trackingInfo?.payment_status === 'refunded'" class="mt-4 p-4 bg-red-50 rounded-lg border border-red-200">
                <div class="flex items-start">
                    <svg class="w-5 h-5 text-red-600 mt-0.5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <div>
                    <h4 class="font-medium text-red-800">{{ t('order_refunded') }}</h4>
                    <p class="text-sm text-red-600 mt-1">
                        {{ t('refund_amount') }}: {{ formatPrice(trackingInfo.order_total) }}
                    </p>
                    <p v-if="trackingInfo.refund_reason" class="text-sm text-red-600 mt-1">
                        {{ t('reason') }}: {{ trackingInfo.refund_reason }}
                    </p>
                    <p v-if="trackingInfo.refunded_at" class="text-sm text-red-600 mt-1">
                        {{ t('refunded_on') }}: {{ formatDate(trackingInfo.refunded_at) }}
                    </p>
                    </div>
                </div>
                </div>
              </div>



              <!-- Order Summary -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('order_summary') }}</h3>

                <div class="bg-gray-50 p-4 rounded-lg">
                  <div class="flex justify-between items-center mb-2">
                    <span class="text-gray-600">{{ t('order_total') }}:</span>
                    <span class="text-xl font-bold text-green-600">{{ formatPrice(trackingInfo.order_total) }}</span>
                  </div>

                  <div class="flex justify-between items-center text-sm">
                    <span class="text-gray-600">{{ t('items_count') }}:</span>
                    <span class="font-medium">{{ trackingInfo.items_count }} {{ t('items') }}</span>
                  </div>
                </div>
              </div>

              <!-- Shipping Address -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('shipping_address') }}</h3>
                <p class="text-gray-600">{{ trackingInfo.shipping_address?.name }}</p>
                <p class="text-gray-600">{{ trackingInfo.shipping_address?.address_line1 }}</p>
                <p v-if="trackingInfo.shipping_address?.address_line2" class="text-gray-600">
                  {{ trackingInfo.shipping_address.address_line2 }}
                </p>
                <p class="text-gray-600">
                  {{ trackingInfo.shipping_address?.city }}, {{ trackingInfo.shipping_address?.state }} {{ trackingInfo.shipping_address?.postal_code }}
                </p>
                <p class="text-gray-600">{{ trackingInfo.shipping_address?.country }}</p>
              </div>

              <!-- Action Buttons -->
              <div class="p-6 flex flex-wrap justify-center gap-4">
                <router-link
                  :to="`/order-confirmation/${orderNumber}`"
                  class="px-6 py-3 border border-gray-300 hover:bg-gray-50 text-gray-700 rounded-lg transition-colors"
                >
                  {{ t('view_order_details') }}
                </router-link>

                <router-link
                  to="/products"
                  class="px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors"
                >
                  {{ t('continue_shopping') }}
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </home-layout>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useStore } from 'vuex';
import { useToast } from "vue-toastification";
import HomeLayout from "../components/HomeLayout.vue";
import { useLanguage } from '../composables/useLanguage';

const route = useRoute();
const router = useRouter();
const store = useStore();
const toast = useToast();
const { t, formatPrice, formatDate,currentLanguage, currentDirection } = useLanguage();

const orderNumber = ref(route.params.orderNumber);
const trackingInfo = ref(null);
const loading = ref(false);
const error = ref(null);

// Getter helpers
const formattedPaymentStatus = computed(() => store.getters['formattedPaymentStatus']);
const paymentStatusClass = computed(() => store.getters['paymentStatusClass']);

// Timeline steps
const timeline = ref([]);
const currentStepIndex = ref(0);
const progressPercentage = ref(0);

// Format order status
const formatOrderStatus = (status) => {
    const statuses = {   
        'pending': currentLanguage.value === 'ar' ? 'قيد الانتظار' : 'Pending',
        'processing': currentLanguage.value === 'ar' ? 'قيد المعالجة' : 'Processing',
        'shipped': currentLanguage.value === 'ar' ? 'تم الشحن' : 'Shipped',
        'delivered': currentLanguage.value === 'ar' ? 'تم التسليم' : 'Delivered',
        'cancelled': currentLanguage.value === 'ar' ? 'ملغي' : 'Cancelled',
        'refunded': currentLanguage.value === 'ar' ? 'مسترد' : 'Refunded'
    };
    return statuses[status] || status;
};

// Update progress based on timeline
const updateProgress = () => {
    if (!timeline.value.length) return;

    const completedCount = timeline.value.filter(step => step.completed).length;
    progressPercentage.value = (completedCount / timeline.value.length) * 100;

    // Find current step index
    currentStepIndex.value = timeline.value.findIndex(step => !step.completed);
    if (currentStepIndex.value === -1) {
        currentStepIndex.value = timeline.value.length - 1;
    }
};

// Fetch tracking information
const fetchTrackingInfo = async () => {
    if (!orderNumber.value) {
        error.value = 'Order number is required';
        return;
    }

    loading.value = true;
    error.value = null;

    try {
        const response = await store.dispatch('orders/trackOrder', orderNumber.value);
        trackingInfo.value = response.data;

        // Set timeline from response or create default
        if (response.data.timeline && response.data.timeline.length) {
            timeline.value = response.data.timeline;
        } else {
            // Create default timeline based on status
            createDefaultTimeline(response.data);
        }

        updateProgress();

    } catch (err) {
        console.error('Failed to fetch tracking:', err);
        error.value = err.response?.data?.message || t('tracking_error');

        if (err.response?.status === 404) {
            toast.error(t('order_not_found'));
        } else {
            toast.error(error.value);
        }
    } finally {
        loading.value = false;
    }
};

// Create default timeline if not provided by API
const createDefaultTimeline = (data) => {
    const steps = [
        {
            status: 'order_placed',
            label: 'order_placed',
            date: data.created_at,
            completed: true
        },
        {
            status: 'payment_confirmed',
            label: 'payment_confirmed',
            date: data.payment_status === 'paid' ? data.updated_at : null,
            completed: data.payment_status === 'paid'
        },
        {
            status: 'processing',
            label: 'processing',
            date: ['processing', 'shipped', 'delivered'].includes(data.current_status) ? data.updated_at : null,
            completed: ['processing', 'shipped', 'delivered'].includes(data.current_status)
        },
        {
            status: 'shipped',
            label: 'shipped',
            date: ['shipped', 'delivered'].includes(data.current_status) ? data.shipped_at || data.updated_at : null,
            completed: ['shipped', 'delivered'].includes(data.current_status)
        },
        {
            status: 'delivered',
            label: 'delivered',
            date: data.current_status === 'delivered' ? data.delivered_at || data.updated_at : null,
            completed: data.current_status === 'delivered'
        }
    ];

    timeline.value = steps;
};

// Handle manual refresh
const handleRefresh = () => {
    fetchTrackingInfo();
};

// Lifecycle
onMounted(() => {
    fetchTrackingInfo();
});
</script>

<style scoped>
/* Pulse animation for current step */
@keyframes pulse {
    0%, 100% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.2);
        opacity: 0.7;
    }
}

.animate-pulse {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
