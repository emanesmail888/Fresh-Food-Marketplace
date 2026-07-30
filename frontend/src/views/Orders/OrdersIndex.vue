<template>
  <div class="bg-white p-4 rounded-lg shadow animate-fade-in-down sm:w-full">
    <div class="md:flex justify-between border-b-2 pb-3 mb-4">
      <div class="flex items-center pb-2">
        <span class="whitespace-nowrap mr-3">{{ t('PerPage') }}</span>
        <select
          v-model="perPage"
          @change="getOrders()"
          class="appearance-none block w-16 px-3 py-2 border border-gray-300 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        >
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="50">50</option>
          <option value="100">100</option>
        </select>
        <span class="ml-4">{{ t('Found') }} {{ orders.total }} {{ t('orders') }}</span>
      </div>

      <div class="flex items-center gap-4">
        <input
          v-model="search"
          @input="debounceGetOrders"
          :placeholder="t('search_orders')"
          class="appearance-none block px-4 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm w-64"
        />
      </div>
    </div>

    <!-- Status Filter -->
    <div class="flex flex-wrap gap-2 mb-4">
      <button
        v-for="status in statusFilters"
        :key="status.value"
        @click="filterByStatus(status.value)"
        :class="[
          'px-3 py-1 text-sm rounded-full transition-colors',
          selectedStatus === status.value
            ? status.color + ' text-white'
            : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
        ]"
      >
        {{ status.label }}
      </button>
    </div>

    <table class="table-auto w-full">
      <thead>
        <tr class="bg-gray-50">
          <TableHeaderCell
            field="order_number"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('order_number')"
          >
            {{ t('order #') }}
          </TableHeaderCell>

          <TableHeaderCell
            field="created_at"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('created_at')"
          >
            {{ t('date') }}
          </TableHeaderCell>

          <TableHeaderCell field="items">{{ t('items') }}</TableHeaderCell>

          <TableHeaderCell
            field="total"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('total')"
          >
            {{ t('total') }}
          </TableHeaderCell>

          <TableHeaderCell
            field="status"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('status')"
          >
            {{ t('status') }}
          </TableHeaderCell>

          <TableHeaderCell
            field="payment_status"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('payment_status')"
          >
            {{ t('payment') }}
          </TableHeaderCell>

          <TableHeaderCell
            field="shipping_status"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortOrders('shipping_status')"
          >
            {{ t('shipping') }}
          </TableHeaderCell>

          <TableHeaderCell field="actions">{{ t('Actions') }}</TableHeaderCell>
        </tr>
      </thead>

      <tbody v-if="orders.loading || !orders?.data?.length">
        <tr>
          <td colspan="8" class="text-center py-12 text-gray-500">
            <Spinner v-if="orders.loading" />
            <p v-else>{{ t('no_orders_found') }}</p>
          </td>
        </tr>
      </tbody>

      <tbody v-else>
        <tr v-for="order in orders.data" :key="order.id" class="hover:bg-gray-50">
          <td class="border-b p-3 font-medium text-gray-800">
            <router-link
              :to="`/orders/${order.order_number}`"
              class="text-indigo-600 hover:text-indigo-800 hover:underline"
            >
              {{ order.order_number }}
            </router-link>
          </td>

          <td class="border-b p-3 text-gray-600">
            {{ formatDate(order.created_at) }}
          </td>

          <td class="border-b p-3 text-gray-600">
            <div class="flex flex-col">
              <span>{{ order.items?.length || 0 }} {{ t('items') }}</span>
              <span v-if="order.items && order.items.length" class="text-xs text-gray-400">
                {{ getFirstItemName(order.items) }}
                <span v-if="order.items.length > 1">+{{ order.items.length - 1 }} {{ t('more') }}</span>
              </span>
            </div>
          </td>

          <td class="border-b p-3 font-medium text-gray-800">
            {{ formatCurrency(order.total, order.currency_symbol) }}
          </td>

          <td class="border-b p-3">
            <span :class="getStatusBadgeClass(order.status)">
              {{ getStatusLabel(order.status) }}
            </span>
          </td>

          <td class="border-b p-3">
            <span :class="getPaymentStatusBadgeClass(order.payment_status)">
              {{ getPaymentStatusLabel(order.payment_status) }}
            </span>
          </td>

          <td class="border-b p-3">
            <span :class="getShippingStatusBadgeClass(order.shipping_status)">
              {{ getShippingStatusLabel(order.shipping_status) }}
            </span>
          </td>

          <td class="border-b p-3">
            <div class="flex items-center gap-2">
              <!-- View Order -->
              <router-link
                :to="`/orders/${order.order_number}/show`"
                :title="t('view_order')"
                class="text-blue-600 hover:text-blue-800 p-1 rounded hover:bg-blue-50 transition-colors"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </router-link>

              <!-- Update Status Dropdown -->
              <div class="relative" @click.stop>
                <button
                  @click="toggleStatusDropdown(order.id)"
                  :title="t('update_status')"
                  class="text-green-600 hover:text-green-800 p-1 rounded hover:bg-green-50 transition-colors"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                  </svg>
                </button>

                <!-- Dropdown -->
                <div
                  v-if="activeDropdown === order.id"
                  class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg z-10 border border-gray-200"
                >
                  <div class="py-1">
                    <button
                      v-for="status in getAvailableStatuses(order)"
                      :key="status.value"
                      @click="updateOrderStatus(order, status.value)"
                      class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                      :class="status.value === order.status ? 'bg-gray-50 font-medium' : ''"
                    >
                      <span :class="getStatusBadgeClass(status.value)">
                        {{ getStatusLabel(status.value) }}
                      </span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Pagination -->
    <div v-if="!orders.loading && orders.data.length" class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4">
      <div class="text-sm text-gray-600">
        {{ t('Showing') }} {{ orders.from || 0 }} {{ t('to') }} {{ orders.to || 0 }} {{ t('of') }} {{ orders.total || 0 }} {{ t('orders') }}
      </div>

      <nav v-if="orders.total > perPage" class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
        <a
          v-for="(link, index) in orders.links"
          :key="index"
          :href="link.url"
          @click.prevent="getOrders(link.url)"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            index === 0 ? 'rounded-l-md' : '',
            index === orders.links.length - 1 ? 'rounded-r-md' : '',
            !link.url ? 'opacity-50 cursor-not-allowed' : ''
          ]"
          class="relative inline-flex items-center px-4 py-2 border text-sm font-medium"
          v-html="link.label"
        ></a>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import store from "../../store/index.js";
import Spinner from "../../components/core/Spinner.vue";
import { ORDERS_PER_PAGE } from "../../constants.js";
import TableHeaderCell from "../../components/core/Table/TableHeaderCell.vue";
import { useLanguage } from '../../composables/useLanguage';
import { useToast } from 'vue-toastification';

const {
  currentLanguage,
  t,
} = useLanguage()

const toast = useToast();
const router = useRouter();

const perPage = ref(ORDERS_PER_PAGE || 10);
const search = ref('');
const sortField = ref('created_at');
const sortDirection = ref('desc');
const selectedStatus = ref('all');
const activeDropdown = ref(null);

const orders = computed(() => store.state.orders.orders);

const statusFilters = [
  { value: 'all', label: t('all_orders'), color: 'bg-gray-500' },
  { value: 'pending', label: t('pending'), color: 'bg-yellow-500' },
  { value: 'processing', label: t('processing'), color: 'bg-blue-500' },
  { value: 'completed', label: t('completed'), color: 'bg-green-500' },
  { value: 'cancelled', label: t('cancelled'), color: 'bg-red-500' },
  { value: 'refunded', label: t('refunded'), color: 'bg-purple-500' },
];

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (activeDropdown.value && !event.target.closest('.relative')) {
    activeDropdown.value = null;
  }
};

onMounted(() => {
  getOrders();
  document.addEventListener('click', handleClickOutside);
});

// Cleanup event listener
import { onBeforeUnmount } from 'vue';
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});

const getOrders = (url = null) => {
  const params = {
    url,
    search: search.value,
    per_page: perPage.value,
    sort_field: sortField.value,
    sort_direction: sortDirection.value,
  };

  if (selectedStatus.value !== 'all') {
    params.status = selectedStatus.value;
  }
  store.dispatch('orders/getOrders', params);
};

const debounceGetOrders = () => {
  getOrders();
};

const sortOrders = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'desc' ? 'asc' : 'desc';
  } else {
    sortField.value = field;
    sortDirection.value = 'asc';
  }
  getOrders();
};

const filterByStatus = (status) => {
      console.log('Filtering by status:', status);

  selectedStatus.value = status;
  getOrders();
};

const toggleStatusDropdown = (orderId) => {
  activeDropdown.value = activeDropdown.value === orderId ? null : orderId;
};

const getAvailableStatuses = (order) => {
  const statuses = [];

  // Define status transitions based on current status
  const transitions = {
    pending: [
      { value: 'processing', label: t('Processing') },
      { value: 'completed', label: t('Completed') },
    ],
    processing: [
      { value: 'completed', label: t('Completed') },
    ],
    completed: [], // No transitions from completed
    cancelled: [], // No transitions from cancelled
    refunded: [], // No transitions from refunded
  };

  const available = transitions[order.status] || [];

  // Add current status as an option (to show it's selected)
  statuses.push({ value: order.status, label: t('Current: ') + getStatusLabel(order.status) });
  statuses.push(...available);

  return statuses;
};

const updateOrderStatus = async (order, newStatus) => {
  try {
    // Close dropdown
    activeDropdown.value = null;
    // Get the status label for the new status
    const statusLabel = getStatusLabel(newStatus);

    // Build confirmation message with proper translation
    const confirmationMessage = t('update_status_confirmation', {
      order: order.order_number,
      status: statusLabel
    });

      // Confirm the status change
    const confirmed = confirm(confirmationMessage);


    // Confirm the status change
    // const confirmed = confirm(
    //   t('update_status_confirmation', {
    //     order: order.order_number,
    //     status: getStatusLabel(newStatus)
    //   }) ||
    //   `Are you sure you want to change order ${order.order_number} status to ${getStatusLabel(newStatus)}?`
    // );

    if (!confirmed) return;

    // Call API to update status
    const result = await store.dispatch('orders/updateOrderStatus', {
      orderNumber: order.order_number,
      status: newStatus
    });

    if (result.success) {
      toast.success(result.message || t('order_status_updated'));
      // Refresh the orders list
      getOrders();
    } else {
      toast.error(result.message || t('failed_to_update_status'));
    }
  } catch (error) {
    console.error('Failed to update order status:', error);
    toast.error(t('failed_to_update_status'));
  }
};

const getFirstItemName = (items) => {
  if (!items || !items.length) return '';
  const firstItem = items[0];
  return firstItem.product_name || firstItem.name || '';
};

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
    pending: t('Pending'),
    processing: t('Processing'),
    completed: t('Completed'),
    cancelled: t('Cancelled'),
    refunded: t('Refunded'),
    partially_refunded: t('Partially Refunded'),
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
    unpaid: t('Unpaid'),
    paid: t('Paid'),
    failed: t('Failed'),
    refunded: t('Refunded'),
    partially_refunded: t('Partially Refunded'),
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
    pending: t('Pending'),
    processing: t('Processing'),
    shipped: t('Shipped'),
    delivered: t('Delivered'),
  };
  return labels[status] || status;
};

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
</script>

<style scoped>
/* Dropdown animation */
.relative .absolute {
  animation: dropdownFade 0.15s ease-out;
}

@keyframes dropdownFade {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
