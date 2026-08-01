<template>
  <home-layout>
    <div :dir="currentDirection">
      <section class="py-16 bg-gray-50 min-h-screen">
        <div class="container mx-auto px-4">
          <div class="max-w-3xl mx-auto">
            <!-- Loading State -->
            <div v-if="loading" class="text-center py-16">
              <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-green-600 border-t-transparent"></div>
              <p class="text-xl text-gray-600 mt-4">{{ t('loading_order') }}</p>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="text-center py-16">
              <div class="inline-flex items-center justify-center w-20 h-20 bg-red-100 rounded-full mb-4">
                <svg class="w-10 h-10 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </div>
              <h1 class="text-3xl font-bold text-gray-800 mb-2">{{ t('order_not_found') }}</h1>
              <p class="text-gray-600 mb-6">{{ error }}</p>
              <router-link
                to="/products"
                class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg transition-colors"
              >
                {{ t('continue_shopping') }}
              </router-link>
            </div>

            <!-- Order Details -->
            <div v-else-if="orderDetails" class="bg-white rounded-lg shadow-sm overflow-hidden">
              <!-- Success Icon -->
              <div class="text-center pt-8 pb-4 bg-green-50">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-green-100 rounded-full mb-4">
                  <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                  </svg>
                </div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">{{ t('order_confirmed') }}</h1>
                <p class="text-gray-600">{{ t('thank_you_order') }}</p>
              </div>

              <!-- Order Header -->
              <div class="bg-gray-50 p-6 border-b border-gray-200">
                <div class="flex flex-wrap justify-between items-center">
                  <div>
                    <p class="text-sm text-gray-600">{{ t('order_number') }}:</p>
                    <p class="text-lg font-bold text-gray-800">{{ orderDetails.order_number }}</p>
                  </div>
                  <div class="text-right">
                    <p class="text-sm text-gray-600">{{ t('order_date') }}:</p>
                    <p class="text-lg font-bold text-gray-800">{{ formatDate(orderDetails.created_at) }}</p>
                  </div>
                </div>
              </div>

              <!-- Order Status -->
              <div class="p-6 border-b border-gray-200 bg-blue-50">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-sm text-gray-600">{{ t('order_status') }}:</p>
                    <p class="text-lg font-bold" :class="orderStatusClass(orderDetails.status)">
                      {{ formatOrderStatus(orderDetails.status) }}
                    </p>
                  </div>
                  <div class="text-right">
                    <p class="text-sm text-gray-600">{{ t('payment_status') }}:</p>
                    <p class="text-lg font-bold" :class="paymentStatusClass(orderDetails.payment_status)">
                      {{ formattedPaymentStatus(orderDetails.payment_status) }}
                    </p>
                  </div>
                </div>
              </div>

              <!-- Order Items -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('order_items') }}</h3>
                <div class="space-y-4">
                  <div v-for="item in orderDetails.items" :key="item.id" class="flex items-center justify-between">
                    <div class="flex items-center">
                      <div class="w-16 h-16 bg-gray-100 rounded overflow-hidden mr-4">
                        <img
                          v-if="item.product_image"
                          :src="`${storageBase}/${item.product_image}`"
                          :alt="item.product_name"
                          class="w-full h-full object-cover"
                        />
                        <div v-else class="w-full h-full flex items-center justify-center text-gray-400">
                          {{ t('no_image') }}
                        </div>
                      </div>
                      <div>
                        <h4 class="font-medium text-gray-800">{{ item.product_name }}</h4>
                        <p class="text-sm text-gray-600">{{ getItemQuantityDisplay(item) }}</p>
                        <p v-if="item.unit && item.unit !== 'kg'" class="text-xs text-gray-500 mt-1">
                          {{ t('unit_type') }}: {{ getUnitLabel(item.unit) }}
                        </p>
                      </div>
                    </div>
                    <div class="text-right">
                      <p class="font-bold text-gray-800">{{ formatPrice(item.total) }}</p>
                      <p class="text-sm text-gray-600">{{ formatPrice(item.unit_price) }}/{{ getPriceUnitLabel(item.unit) }}</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Order Summary -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('order_summary') }}</h3>
                <div class="space-y-2">
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('subtotal') }}:</span>
                    <span class="text-gray-800">{{ formatPrice(orderDetails.subtotal) }}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('shipping') }}:</span>
                    <span class="text-gray-800">{{ formatPrice(orderDetails.shipping_cost) }}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('tax') }} (14% VAT):</span>
                    <span class="text-gray-800">{{ formatPrice(orderDetails.tax) }}</span>
                  </div>
                  <div v-if="orderDetails.discount > 0" class="flex justify-between text-sm text-green-600">
                    <span>{{ t('discount') }}:</span>
                    <span>-{{ formatPrice(orderDetails.discount) }}</span>
                  </div>
                  <div class="flex justify-between text-lg font-bold pt-2 border-t border-gray-200">
                    <span>{{ t('total') }}:</span>
                    <span class="text-green-600">{{ formatPrice(orderDetails.total) }}</span>
                  </div>
                </div>
              </div>

              <!-- Shipping Address -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('shipping_address') }}</h3>
                <p class="text-gray-600">{{ orderDetails.shipping_address.name }}</p>
                <p class="text-gray-600">{{ orderDetails.shipping_address.address_line1 }}</p>
                <p v-if="orderDetails.shipping_address.address_line2" class="text-gray-600">
                  {{ orderDetails.shipping_address.address_line2 }}
                </p>
                <p class="text-gray-600">
                  {{ orderDetails.shipping_address.city }}, {{ orderDetails.shipping_address.state }} {{ orderDetails.shipping_address.postal_code }}
                </p>
                <p class="text-gray-600">{{ orderDetails.shipping_address.country }}</p>
                <p class="text-gray-600 mt-2">{{ t('phone') }}: {{ orderDetails.shipping_address.phone }}</p>
                <p class="text-gray-600">{{ t('email') }}: {{ orderDetails.shipping_address.email }}</p>
              </div>

              <!-- Payment Method -->
              <div class="p-6">
                <h3 class="font-bold text-gray-800 mb-4">{{ t('payment_method') }}</h3>
                <p class="text-gray-600 capitalize">{{ formattedPaymentMethod(orderDetails.payment_method) }}</p>

                <!-- COD Due Date -->
                <div v-if="orderDetails.payment_method === 'cash_on_delivery' && orderDetails.cod_due_date" class="mt-2 p-3 bg-yellow-50 rounded-lg">
                  <p class="text-sm text-yellow-800">
                    <span class="font-medium">{{ t('cod_due_date') }}:</span>
                    {{ formatDate(orderDetails.cod_due_date) }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div v-if="orderDetails" class="mt-8 flex flex-wrap justify-center gap-4">
              <router-link
                to="/products"
                class="px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors"
              >
                {{ t('continue_shopping') }}
              </router-link>

              <button
                v-if="canReorder"
                @click="handleReorder"
                class="px-6 py-3 border border-green-600 text-green-600 hover:bg-green-50 rounded-lg transition-colors"
                :disabled="reordering"
              >
                <span v-if="reordering" class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-green-600 border-t-transparent mr-2"></span>
                {{ t('reorder') }}
              </button>

              <button
                v-if="canCancel"
                @click="handleCancelOrder"
                class="px-6 py-3 border border-red-300 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                :disabled="cancelling"
              >
                <span v-if="cancelling" class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-red-600 border-t-transparent mr-2"></span>
                {{ t('cancel_order') }}
              </button>

              <button
                @click="handleTrackOrder"
                class="px-6 py-3 border border-gray-300 hover:bg-gray-50 text-gray-700 rounded-lg transition-colors"
              >
                {{ t('track_order') }}
              </button>
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
const { t, formatPrice, formatDate, currentDirection ,currentLanguage} = useLanguage();

const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";
const reordering = ref(false);
const cancelling = ref(false);

// Unit labels
const unitLabels = {
  kg: { en: "kg", ar: "كجم", priceLabel: "kg" },
  g: { en: "g", ar: "جم", priceLabel: "g" },
  piece: { en: "piece", ar: "قطعة", priceLabel: "piece" },
  liter: { en: "liter", ar: "لتر", priceLabel: "L" },
  pack: { en: "pack", ar: "حزمة", priceLabel: "pack" },
  bunch: { en: "bunch", ar: "حزمة", priceLabel: "bunch" }
};

// Helper functions
const getUnitLabel = (unit) => {
  const config = unitLabels[unit] || unitLabels.kg;
  return currentDirection.value === 'rtl' ? config.ar : config.en;
};

const getPriceUnitLabel = (unit) => {
  const config = unitLabels[unit] || unitLabels.kg;
  return config.priceLabel;
};

// Format weight/quantity based on unit
const getItemQuantityDisplay = (item) => {
  const unit = item.unit || 'kg';
  const quantityInGrams = item.quantity_grams;

  // If there's a pre-formatted quantity display, use it
  if (item.quantity_display) {
    return item.quantity_display;
  }

  // Calculate quantity based on unit
  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    // For pack/piece items, quantity_grams is the number of units
    const quantity = Math.round(quantityInGrams);
    const label = getUnitLabel(unit);
    return `${quantity} ${label}${quantity !== 1 ? (unit === 'piece' ? 's' : '') : ''}`;
  }

  if (unit === 'kg') {
    const kgValue = quantityInGrams / 1000;
    return `${kgValue.toFixed(2)} ${getUnitLabel(unit)}`;
  }

  if (unit === 'g') {
    return `${Math.round(quantityInGrams)} ${getUnitLabel(unit)}`;
  }

  if (unit === 'liter') {
    const literValue = quantityInGrams / 1000;
    return `${literValue.toFixed(2)} ${getUnitLabel(unit)}`;
  }

  // Default to kg
  const kgValue = quantityInGrams / 1000;
  return `${kgValue.toFixed(2)} kg`;
};

// Format number for weight display
const formatWeight = (grams) => {
  if (!grams || grams <= 0) return currentDirection.value === 'rtl' ? '٠ جم' : '0 g';

  const kg = grams / 1000;

  if (kg < 0.1) {
    return currentDirection.value === 'rtl'
      ? `${new Intl.NumberFormat('ar-EG').format(Math.round(grams))} جم`
      : `${Math.round(grams)} g`;
  }
  if (kg < 1) {
    return currentDirection.value === 'rtl'
      ? `${new Intl.NumberFormat('ar-EG').format(kg)} كجم`
      : `${kg.toFixed(2)} kg`;
  }
  return currentDirection.value === 'rtl'
    ? `${new Intl.NumberFormat('ar-EG').format(kg)} كجم`
    : `${kg.toFixed(kg % 1 === 0 ? 0 : 2)} kg`;
};

// Computed properties from store
const orderDetails = computed(() => store.state.orders.order?.orderDetails);
const loading = computed(() => store.state.orders.order?.orderLoading);
const error = computed(() => store.state.orders.order?.orderError);

// Getter helpers
const formattedPaymentMethod = computed(() => store.getters['formattedPaymentMethod']);
const formattedPaymentStatus = computed(() => store.getters['formattedPaymentStatus']);
const paymentStatusClass = computed(() => store.getters['paymentStatusClass']);
const orderStatusClass = computed(() => store.getters['orderStatusClass']);

// Additional computed properties
const canCancel = computed(() => {
    if (!orderDetails.value) return false;
    const cancelableStatuses = ['pending', 'processing'];
    return cancelableStatuses.includes(orderDetails.value.status);
});

const canReorder = computed(() => {
    if (!orderDetails.value) return false;
    return true;
});

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

// Load order on mount
onMounted(async () => {
    const orderNumber = route.params.orderNumber;

    if (!orderNumber) {
        toast.error(t('order_number_required'));
        router.push('/');
        return;
    }

    try {
        await store.dispatch('orders/fetchOrderByNumber', orderNumber);
    } catch (error) {
        console.error('Failed to fetch order:', error);
    }
});

// Handle reorder
const handleReorder = async () => {
    reordering.value = true;
    try {
        const response = await store.dispatch('orders/reorder', orderDetails.value.order_number);
        toast.success(t('items_added_to_cart'));
        router.push('/cart');
    } catch (error) {
        toast.error(error.response?.data?.message || t('reorder_failed'));
    } finally {
        reordering.value = false;
    }
};

// Handle cancel order
const handleCancelOrder = async () => {
    if (!confirm(t('confirm_cancel_order'))) return;

    cancelling.value = true;
    try {
        await store.dispatch('orders/cancelOrder', {
            orderNumber: orderDetails.value.order_number,
            reason: 'Cancelled by customer'
        });
        toast.success(t('order_cancelled'));
        // Refresh order details
        await store.dispatch('orders/fetchOrderByNumber', orderDetails.value.order_number);
    } catch (error) {
        toast.error(error.response?.data?.message || t('cancel_failed'));
    } finally {
        cancelling.value = false;
    }
};

// Handle track order
const handleTrackOrder = () => {
    router.push(`/orders/${orderDetails.value.order_number}/track`);
};
</script>
