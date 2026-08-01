<template>
  <div class="bg-white p-4 rounded-lg shadow">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">{{ t('order_details') }} #{{ order?.order_number }}</h1>
      <router-link
        to="/app/orders"
        class="text-indigo-600 hover:text-indigo-800"
      >
        ← {{ t('back_to_orders') }}
      </router-link>
    </div>

    <div v-if="orderLoading" class="flex justify-center py-12">
      <Spinner />
    </div>

    <div v-else-if="order" class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Order Info -->
      <div class="border rounded-lg p-4">
        <h3 class="font-semibold text-lg mb-4">{{ t('order_information') }}</h3>
        <div class="space-y-2">
          <p><span class="font-medium">{{ t('order_number') }}:</span> {{ order.order_number }}</p>
          <p><span class="font-medium">{{ t('date') }}:</span> {{ formatDate(order.created_at) }}</p>
          <p><span class="font-medium">{{ t('status') }}:</span>
            <span :class="getStatusBadgeClass(order.status)">{{ getStatusLabel(order.status) }}</span>
          </p>
          <p><span class="font-medium">{{ t('payment_status') }}:</span>
            <span :class="getPaymentStatusBadgeClass(order.payment_status)">{{ getPaymentStatusLabel(order.payment_status) }}</span>
          </p>
          <p><span class="font-medium">{{ t('total') }}:</span>
            {{ formatCurrency(order.total, order.currency_symbol) }}
          </p>
        </div>
      </div>

      <!-- Shipping Info -->
      <div class="border rounded-lg p-4">
        <h3 class="font-semibold text-lg mb-4">{{ t('shipping_information') }}</h3>
        <div class="space-y-2">
          <p><span class="font-medium">{{ t('shipping_method') }}:</span> {{ order.shipping_method || '-' }}</p>
          <p><span class="font-medium">{{ t('shipping_status') }}:</span>
            <span :class="getShippingStatusBadgeClass(order.shipping_status)">{{ getShippingStatusLabel(order.shipping_status) }}</span>
          </p>
          <p><span class="font-medium">{{ t('tracking_number') }}:</span> {{ order.tracking_number || '-' }}</p>
          <div class="mt-2">
            <p class="font-medium">{{ t('shipping_address') }}</p>
            <p class="text-sm text-gray-600">{{ formatAddress(order.shipping_address) }}</p>
          </div>
        </div>
      </div>

      <!-- Order Items -->
      <div class="md:col-span-2 border rounded-lg p-4">
        <h3 class="font-semibold text-lg mb-4">{{ t('order_items') }}</h3>
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b bg-gray-50">
                <th class="text-left py-3 px-2">{{ t('product') }}</th>
                <th class="text-left py-3 px-2">{{ t('unit') }}</th>
                <th class="text-center py-3 px-2">{{ t('quantity') }}</th>
                <th class="text-right py-3 px-2">{{ t('unit_price') }}</th>
                <th class="text-right py-3 px-2">{{ t('total') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in order.items" :key="item.id" class="border-b hover:bg-gray-50">
                <td class="py-3 px-2">
                  <div class="flex items-center">
                    <div class="w-12 h-12 bg-gray-100 rounded overflow-hidden mr-3 flex-shrink-0">
                      <img
                        v-if="item.product_image"
                        :src="`${storageBase}/${item.product_image}`"
                        :alt="item.product_name"
                        class="w-full h-full object-cover"
                        @error="handleImageError"
                      />
                      <div v-else class="w-full h-full flex items-center justify-center text-gray-400 text-xs">
                        {{ t('no_image') }}
                      </div>
                    </div>
                    <div>
                      <p class="font-medium text-gray-800">{{ item.product_name }}</p>
                      <p v-if="item.options" class="text-xs text-gray-500 mt-1">
                        {{ formatOptions(item.options) }}
                      </p>
                    </div>
                  </div>
                </td>
                <td class="py-3 px-2">
                  <span class="text-sm text-gray-600">{{ getUnitLabel(item.unit) }}</span>
                </td>
                <td class="py-3 px-2 text-center">
                  <span class="text-sm font-medium text-gray-800">
                    {{ getItemQuantityDisplay(item) }}
                  </span>
                </td>
                <td class="py-3 px-2 text-right">
                  <span class="text-sm text-gray-600">
                    {{ formatCurrency(item.unit_price, order.currency_symbol) }}
                    <span class="text-xs text-gray-400">/{{ getPriceUnitLabel(item.unit) }}</span>
                  </span>
                </td>
                <td class="py-3 px-2 text-right">
                  <span class="font-medium text-gray-800">
                    {{ formatCurrency(item.total, order.currency_symbol) }}
                  </span>
                </td>
              </tr>
            </tbody>
            <tfoot class="bg-gray-50">
              <tr>
                <td colspan="4" class="text-right font-medium py-3 px-2">{{ t('subtotal') }}</td>
                <td class="text-right py-3 px-2">{{ formatCurrency(order.subtotal, order.currency_symbol) }}</td>
              </tr>
              <tr>
                <td colspan="4" class="text-right font-medium py-2 px-2">{{ t('shipping') }}</td>
                <td class="text-right py-2 px-2">{{ formatCurrency(order.shipping_cost, order.currency_symbol) }}</td>
              </tr>
              <tr>
                <td colspan="4" class="text-right font-medium py-2 px-2">{{ t('tax') }}</td>
                <td class="text-right py-2 px-2">{{ formatCurrency(order.tax, order.currency_symbol) }}</td>
              </tr>
              <tr v-if="order.discount > 0">
                <td colspan="4" class="text-right font-medium py-2 px-2 text-green-600">{{ t('discount') }}</td>
                <td class="text-right py-2 px-2 text-green-600">-{{ formatCurrency(order.discount, order.currency_symbol) }}</td>
              </tr>
              <tr class="border-t-2 border-gray-300">
                <td colspan="4" class="text-right font-bold py-3 px-2 text-lg">{{ t('total') }}</td>
                <td class="text-right font-bold py-3 px-2 text-lg text-green-600">
                  {{ formatCurrency(order.total, order.currency_symbol) }}
                </td>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>

      <!-- Additional Info -->
      <div class="md:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Payment Information -->
        <div class="border rounded-lg p-4">
          <h3 class="font-semibold text-lg mb-4">{{ t('payment_information') }}</h3>
          <div class="space-y-2">
            <p><span class="font-medium">{{ t('payment_method') }}:</span>
              <span class="capitalize">{{ formatPaymentMethod(order.payment_method) }}</span>
            </p>
            <p><span class="font-medium">{{ t('payment_status') }}:</span>
              <span :class="getPaymentStatusBadgeClass(order.payment_status)">{{ getPaymentStatusLabel(order.payment_status) }}</span>
            </p>
            <p v-if="order.paid_at"><span class="font-medium">{{ t('paid_at') }}:</span> {{ formatDate(order.paid_at) }}</p>
            <p v-if="order.refunded_at"><span class="font-medium">{{ t('refunded_at') }}:</span> {{ formatDate(order.refunded_at) }}</p>
            <p v-if="order.refund_reason"><span class="font-medium">{{ t('refund_reason') }}:</span> {{ order.refund_reason }}</p>
          </div>
        </div>

        <!-- Customer Information -->
        <div class="border rounded-lg p-4">
          <h3 class="font-semibold text-lg mb-4">{{ t('customer_information') }}</h3>
          <div class="space-y-2">
            <p><span class="font-medium">{{ t('name') }}:</span> {{ getCustomerName(order) }}</p>
            <p><span class="font-medium">{{ t('email') }}:</span> {{ getCustomerEmail(order) }}</p>
            <p><span class="font-medium">{{ t('phone') }}:</span> {{ getCustomerPhone(order) }}</p>
            <p v-if="order.customer_notes"><span class="font-medium">{{ t('customer_notes') }}:</span> {{ order.customer_notes }}</p>
          </div>
        </div>
      </div>

      <!-- Admin Actions -->
      <div class="md:col-span-2 flex gap-4 mt-4">
        <button
          v-if="canUpdateStatus(order)"
          @click="showStatusModal = true"
          class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors"
        >
          {{ t('update_status') }}
        </button>

        <button
          v-if="canCancelOrder(order)"
          @click="cancelOrder"
          class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors"
        >
          {{ t('cancel_order') }}
        </button>
      </div>
    </div>

    <!-- Status Update Modal -->
    <div v-if="showStatusModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 max-w-md w-full">
        <h3 class="text-xl font-bold mb-4">{{ t('update_order_status') }}</h3>
        <div class="space-y-3">
          <button
            v-for="status in getAvailableStatuses(order)"
            :key="status.value"
            @click="updateOrderStatus(status.value)"
            class="w-full text-left px-4 py-2 rounded hover:bg-gray-100 transition-colors"
            :class="status.value === order.status ? 'bg-gray-100 font-medium' : ''"
          >
            <span :class="getStatusBadgeClass(status.value)">
              {{ getStatusLabel(status.value) }}
            </span>
          </button>
        </div>
        <button
          @click="showStatusModal = false"
          class="mt-4 w-full px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300 transition-colors"
        >
          {{ t('close') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import store from '../../store';
import Spinner from '../../components/core/Spinner.vue';
import { useLanguage } from '../../composables/useLanguage';
import { useToast } from 'vue-toastification';

const route = useRoute();
const router = useRouter();
const toast = useToast();
const { t, currentLanguage } = useLanguage();

const showStatusModal = ref(false);
const storageBase = import.meta.env.VITE_STORAGE_URL ;

const order = computed(() => store.state.orders.order.currentOrder);
const orderLoading = computed(() => store.state.orders.order.orderLoading);

// Unit labels
const unitLabels = {
  kg: { en: "kg", ar: "كجم", priceLabel: "kg" },
  g: { en: "g", ar: "جم", priceLabel: "g" },
  piece: { en: "piece", ar: "قطعة", priceLabel: "piece" },
  liter: { en: "liter", ar: "لتر", priceLabel: "L" },
  pack: { en: "pack", ar: "حزمة", priceLabel: "pack" },
  bunch: { en: "bunch", ar: "حزمة", priceLabel: "bunch" }
};

onMounted(() => {
  fetchOrder();
});

const fetchOrder = async () => {
  const orderNumber = route.params.orderNumber;
  try {
    await store.dispatch('orders/getOrderByAdmin', orderNumber);
  } catch (error) {
    toast.error(t('failed_to_load_order'));
    router.push('/orders');
  }
};

// Helper functions for items
const getUnitLabel = (unit) => {
  const config = unitLabels[unit] || unitLabels.kg;
  return currentLanguage === 'ar' ? config.ar : config.en;
};

const getPriceUnitLabel = (unit) => {
  const config = unitLabels[unit] || unitLabels.kg;
  return config.priceLabel;
};

const getItemQuantityDisplay = (item) => {
  const unit = item.unit || 'kg';
  const quantityInGrams = parseFloat(item.quantity_grams) || 0;

  // If there's a pre-formatted quantity display in options
  if (item.options) {
    try {
      const options = typeof item.options === 'string' ? JSON.parse(item.options) : item.options;
      if (options.quantity_display) {
        return options.quantity_display;
      }
    } catch (e) {
      // Ignore parse errors
    }
  }

  // Calculate quantity based on unit
  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    const quantity = Math.round(quantityInGrams);
    const label = getUnitLabel(unit);
    return `${quantity} ${label}`;
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

const formatOptions = (options) => {
  if (!options) return '';
  try {
    const parsed = typeof options === 'string' ? JSON.parse(options) : options;
    if (parsed.quantity_display) {
      return parsed.quantity_display;
    }
    return '';
  } catch (e) {
    return '';
  }
};

const handleImageError = (e) => {
  e.target.src = '';
  e.target.alt = 'No image';
};

// Customer info helpers
const getCustomerName = (order) => {
  if (order.shipping_address) {
    const address = typeof order.shipping_address === 'string'
      ? JSON.parse(order.shipping_address)
      : order.shipping_address;
    return address.name || '-';
  }
  return order.user?.name || '-';
};

const getCustomerEmail = (order) => {
  if (order.shipping_address) {
    const address = typeof order.shipping_address === 'string'
      ? JSON.parse(order.shipping_address)
      : order.shipping_address;
    return address.email || '-';
  }
  return order.user?.email || '-';
};

const getCustomerPhone = (order) => {
  if (order.shipping_address) {
    const address = typeof order.shipping_address === 'string'
      ? JSON.parse(order.shipping_address)
      : order.shipping_address;
    return address.phone || '-';
  }
  return '-';
};

// Status helpers
const canUpdateStatus = (order) => {
  return ['pending', 'processing'].includes(order.status);
};

const canCancelOrder = (order) => {
  return ['pending', 'processing'].includes(order.status);
};

const getAvailableStatuses = (order) => {
  const statuses = [];
  const transitions = {
    pending: [
      { value: 'processing', label: t('Processing') },
      { value: 'completed', label: t('Completed') },
    ],
    processing: [
      { value: 'completed', label: t('Completed') },
    ],
    completed: [],
    cancelled: [],
    refunded: [],
  };

  const available = transitions[order.status] || [];
  statuses.push({ value: order.status, label: t('Current: ') + getStatusLabel(order.status) });
  statuses.push(...available);
  return statuses;
};

const updateOrderStatus = async (newStatus) => {
  if (newStatus === order.value.status) {
    showStatusModal.value = false;
    return;
  }

  try {
    const result = await store.dispatch('orders/updateOrderStatus', {
      orderNumber: order.value.order_number,
      status: newStatus
    });

    if (result.success) {
      toast.success(result.message || t('order_status_updated'));
      showStatusModal.value = false;
      await fetchOrder(); // Refresh order details
    } else {
      toast.error(result.message || t('failed_to_update_status'));
    }
  } catch (error) {
    console.error('Failed to update order status:', error);
    toast.error(t('failed_to_update_status'));
  }
};

const cancelOrder = async () => {
  if (!confirm(t('confirm_cancel_order'))) return;

  try {
    const result = await store.dispatch('orders/cancelOrder', {
      orderNumber: order.value.order_number,
      reason: 'Cancelled by admin'
    });

    if (result.success) {
      toast.success(result.message || t('order_cancelled_successfully'));
      await fetchOrder();
    } else {
      toast.error(result.message || t('failed_to_cancel_order'));
    }
  } catch (error) {
    console.error('Failed to cancel order:', error);
    toast.error(t('failed_to_cancel_order'));
  }
};

const formatPaymentMethod = (method) => {
  const methods = {
    stripe: 'Stripe',
    cash_on_delivery: 'Cash on Delivery',
    paypal: 'PayPal',
    bank_transfer: 'Bank Transfer'
  };
  return methods[method] || method;
};

// Formatting helpers
const formatDate = (date) => {
  if (!date) return '-';
  return new Date(date).toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const formatCurrency = (amount, symbol = 'E£') => {
  return `${symbol} ${parseFloat(amount).toFixed(2)}`;
};

const formatAddress = (address) => {
  if (!address) return '-';
  if (typeof address === 'string') {
    try {
      address = JSON.parse(address);
    } catch {
      return address;
    }
  }
  const parts = [
    address.name,
    address.address_line1,
    address.address_line2,
    address.city,
    address.state,
    address.postal_code,
    address.country
  ];
  return parts.filter(Boolean).join(', ');
};

// Badge classes
const getStatusBadgeClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    processing: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800',
    refunded: 'bg-purple-100 text-purple-800',
    partially_refunded: 'bg-orange-100 text-orange-800',
  };
  return `px-2 py-1 text-xs rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`;
};

const getStatusLabel = (status) => {
  const labels = {
    pending: 'Pending',
    processing: 'Processing',
    completed: 'Completed',
    cancelled: 'Cancelled',
    refunded: 'Refunded',
    partially_refunded: 'Partially Refunded',
  };
  return labels[status] || status;
};

const getPaymentStatusBadgeClass = (status) => {
  const classes = {
    unpaid: 'bg-gray-100 text-gray-800',
    paid: 'bg-green-100 text-green-800',
    failed: 'bg-red-100 text-red-800',
    refunded: 'bg-purple-100 text-purple-800',
    partially_refunded: 'bg-orange-100 text-orange-800',
  };
  return `px-2 py-1 text-xs rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`;
};

const getPaymentStatusLabel = (status) => {
  const labels = {
    unpaid: 'Unpaid',
    paid: 'Paid',
    failed: 'Failed',
    refunded: 'Refunded',
    partially_refunded: 'Partially Refunded',
  };
  return labels[status] || status;
};

const getShippingStatusBadgeClass = (status) => {
  const classes = {
    pending: 'bg-gray-100 text-gray-800',
    processing: 'bg-blue-100 text-blue-800',
    shipped: 'bg-indigo-100 text-indigo-800',
    delivered: 'bg-green-100 text-green-800',
  };
  return `px-2 py-1 text-xs rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`;
};

const getShippingStatusLabel = (status) => {
  const labels = {
    pending: 'Pending',
    processing: 'Processing',
    shipped: 'Shipped',
    delivered: 'Delivered',
  };
  return labels[status] || status;
};
</script>

<style scoped>
</style>
