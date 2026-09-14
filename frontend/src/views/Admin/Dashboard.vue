<template>
    <div class="space-y-6">
      <!-- Page Header -->
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-2xl font-bold text-gray-800">{{ t('dashboard') }}</h1>
          <p class="text-gray-500">{{ t('welcome_back') }}, {{ user?.name }}</p>
        </div>
        <div class="flex items-center gap-3">
          <span class="text-sm text-gray-500">{{ formatDate(new Date()) }}</span>
          <button
            @click="refreshDashboard"
            class="px-3 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors text-sm flex items-center gap-2"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
            {{ t('refresh') }}
          </button>
        </div>
      </div>

      <!-- Stats Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <!-- Total Orders -->
        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-blue-500 hover:shadow-lg transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-500">{{ t('total_orders') }}</p>
              <p class="text-2xl font-bold text-gray-800">{{ stats.total_orders || 0 }}</p>
              <div class="flex items-center mt-1">
                <span :class="stats.orders_growth >= 0 ? 'text-green-500' : 'text-red-500'" class="text-xs font-medium">
                  {{ stats.orders_growth >= 0 ? '+' : '' }}{{ stats.orders_growth || 0 }}%
                </span>
                <span class="text-xs text-gray-400 ml-1">{{ t('from_last_month') }}</span>
              </div>
            </div>
            <div class="bg-blue-100 p-3 rounded-full">
              <svg class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Products -->
        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-green-500 hover:shadow-lg transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-500">{{ t('total_products') }}</p>
              <p class="text-2xl font-bold text-gray-800">{{ stats.total_products || 0 }}</p>
              <div class="flex items-center mt-1">
                <span :class="stats.products_growth >= 0 ? 'text-green-500' : 'text-red-500'" class="text-xs font-medium">
                  {{ stats.products_growth >= 0 ? '+' : '' }}{{ stats.products_growth || 0 }}%
                </span>
                <span class="text-xs text-gray-400 ml-1">{{ t('from_last_month') }}</span>
              </div>
            </div>
            <div class="bg-green-100 p-3 rounded-full">
              <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10" />
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Users -->
        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-purple-500 hover:shadow-lg transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-500">{{ t('total_users') }}</p>
              <p class="text-2xl font-bold text-gray-800">{{ stats.total_users || 0 }}</p>
              <div class="flex items-center mt-1">
                <span :class="stats.users_growth >= 0 ? 'text-green-500' : 'text-red-500'" class="text-xs font-medium">
                  {{ stats.users_growth >= 0 ? '+' : '' }}{{ stats.users_growth || 0 }}%
                </span>
                <span class="text-xs text-gray-400 ml-1">{{ t('from_last_month') }}</span>
              </div>
            </div>
            <div class="bg-purple-100 p-3 rounded-full">
              <svg class="h-6 w-6 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Revenue -->
        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-yellow-500 hover:shadow-lg transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-500">{{ t('total_revenue') }}</p>
              <p class="text-2xl font-bold text-gray-800">{{ formatCurrency(stats.total_revenue || 0) }}</p>
              <div class="flex items-center mt-1">
                <span :class="stats.revenue_growth >= 0 ? 'text-green-500' : 'text-red-500'" class="text-xs font-medium">
                  {{ stats.revenue_growth >= 0 ? '+' : '' }}{{ stats.revenue_growth || 0 }}%
                </span>
                <span class="text-xs text-gray-400 ml-1">{{ t('from_last_month') }}</span>
              </div>
            </div>
            <div class="bg-yellow-100 p-3 rounded-full">
              <svg class="h-6 w-6 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts Row -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Revenue Chart -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-800">{{ t('revenue_overview') }}</h3>
            <select v-model="revenuePeriod" class="text-sm border rounded px-2 py-1">
              <option value="7">{{ t('last_7_days') }}</option>
              <option value="30">{{ t('last_30_days') }}</option>
              <option value="90">{{ t('last_90_days') }}</option>
            </select>
          </div>
          <div ref="revenueChartRef" class="w-full h-64"></div>
        </div>

        <!-- Orders Chart -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-800">{{ t('orders_overview') }}</h3>
            <select v-model="ordersPeriod" class="text-sm border rounded px-2 py-1">
              <option value="7">{{ t('last_7_days') }}</option>
              <option value="30">{{ t('last_30_days') }}</option>
              <option value="90">{{ t('last_90_days') }}</option>
            </select>
          </div>
          <div ref="ordersChartRef" class="w-full h-64"></div>
        </div>
      </div>

      <!-- Bottom Row -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Recent Orders -->
        <div class="lg:col-span-2 bg-white rounded-lg shadow p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-800">{{ t('recent_orders') }}</h3>
            <router-link to="/app/orders" class="text-sm text-indigo-600 hover:text-indigo-800">
              {{ t('view_all') }}
            </router-link>
          </div>
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="text-left text-xs text-gray-500 uppercase border-b">
                  <th class="pb-2">{{ t('order_number') }}</th>
                  <th class="pb-2">{{ t('customer') }}</th>
                  <th class="pb-2">{{ t('total') }}</th>
                  <th class="pb-2">{{ t('status') }}</th>
                  <th class="pb-2">{{ t('date') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="recentOrders.loading">
                  <td colspan="5" class="text-center py-4 text-gray-500">{{ t('loading') }}...</td>
                </tr>
                <tr v-else-if="!recentOrders.data || recentOrders.data.length === 0">
                  <td colspan="5" class="text-center py-4 text-gray-500">{{ t('no_recent_orders') }}</td>
                </tr>
                <tr v-else v-for="order in recentOrders.data" :key="order.id" class="border-b hover:bg-gray-50">
                  <td class="py-2">
                    <router-link :to="`/app/orders/${order.order_number}`" class="text-indigo-600 hover:underline">
                      {{ order.order_number }}
                    </router-link>
                  </td>
                  <td class="py-2">{{ getCustomerName(order) }}</td>
                  <td class="py-2 font-medium">{{ formatCurrency(order.total) }}</td>
                  <td class="py-2">
                    <span :class="getStatusBadgeClass(order.status)">
                      {{ getStatusLabel(order.status) }}
                    </span>
                  </td>
                  <td class="py-2 text-sm text-gray-500">{{ formatDate(order.created_at) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Quick Stats -->
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-semibold text-gray-800 mb-4">{{ t('quick_stats') }}</h3>
          <div class="space-y-4">
            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <div>
                <p class="text-sm text-gray-500">{{ t('pending_orders') }}</p>
                <p class="text-xl font-bold text-gray-800">{{ stats.pending_orders || 0 }}</p>
              </div>
              <span class="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded-full">
                {{ t('pending') }}
              </span>
            </div>
            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <div>
                <p class="text-sm text-gray-500">{{ t('processing_orders') }}</p>
                <p class="text-xl font-bold text-gray-800">{{ stats.processing_orders || 0 }}</p>
              </div>
              <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">
                {{ t('processing') }}
              </span>
            </div>
            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <div>
                <p class="text-sm text-gray-500">{{ t('completed_orders') }}</p>
                <p class="text-xl font-bold text-gray-800">{{ stats.completed_orders || 0 }}</p>
              </div>
              <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">
                {{ t('completed') }}
              </span>
            </div>
            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
              <div>
                <p class="text-sm text-gray-500">{{ t('cancelled_orders') }}</p>
                <p class="text-xl font-bold text-gray-800">{{ stats.cancelled_orders || 0 }}</p>
              </div>
              <span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full">
                {{ t('cancelled') }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick, onBeforeUnmount } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { useLanguage } from '../../composables/useLanguage'
import { useToast } from 'vue-toastification'
import * as echarts from 'echarts'

const store = useStore()
const router = useRouter()
const toast = useToast()
const { t } = useLanguage()

// Refs for charts
const revenueChartRef = ref(null)
const ordersChartRef = ref(null)
let revenueChart = null
let ordersChart = null

// State
const revenuePeriod = ref(30)
const ordersPeriod = ref(30)
const stats = ref({
  total_orders: 0,
  total_products: 0,
  total_users: 0,
  total_revenue: 0,
  pending_orders: 0,
  processing_orders: 0,
  completed_orders: 0,
  cancelled_orders: 0,
  orders_growth: 0,
  products_growth: 0,
  users_growth: 0,
  revenue_growth: 0
})

// Computed
const user = computed(() => store.getters['auth/user'])
const recentOrders = computed(() => store.state.orders?.recentOrders || { data: [], loading: false })

// Methods
const getCustomerName = (order) => {
  if (order.shipping_address) {
    const address = typeof order.shipping_address === 'string'
      ? JSON.parse(order.shipping_address)
      : order.shipping_address
    return address.name || 'Guest'
  }
  return 'Guest'
}

const getStatusBadgeClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    processing: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800',
    refunded: 'bg-purple-100 text-purple-800',
  }
  return `px-2 py-1 text-xs rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`
}

const getStatusLabel = (status) => {
  const labels = {
    pending: t('pending'),
    processing: t('processing'),
    completed: t('completed'),
    cancelled: t('cancelled'),
    refunded: t('refunded'),
  }
  return labels[status] || status
}

const formatCurrency = (amount) => {
  return `E£ ${parseFloat(amount).toFixed(2)}`
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  })
}

// Load dashboard data
const loadDashboardData = async () => {
  try {
    const response = await store.dispatch('dashboard/getDashboardStats')
    if (response.success) {
      stats.value = response.data
    }
  } catch (error) {
    console.error('Failed to load dashboard stats:', error)
    toast.error(t('failed_to_load_dashboard'))
  }
}

const loadRecentOrders = async () => {
  try {
    await store.dispatch('orders/getRecentOrders')
  } catch (error) {
    console.error('Failed to load recent orders:', error)
  }
}

// Initialize charts
const initCharts = () => {
  if (revenueChartRef.value) {
    revenueChart = echarts.init(revenueChartRef.value)
    updateRevenueChart()
  }
  if (ordersChartRef.value) {
    ordersChart = echarts.init(ordersChartRef.value)
    updateOrdersChart()
  }
}

// Update Revenue Chart
const updateRevenueChart = () => {
  if (!revenueChart) return

  // Sample data - replace with actual API data
  const days = Array.from({ length: revenuePeriod.value }, (_, i) => {
    const date = new Date()
    date.setDate(date.getDate() - (revenuePeriod.value - 1 - i))
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short' })
  })

  const data = Array.from({ length: revenuePeriod.value }, () =>
    Math.floor(Math.random() * 1000) + 100
  )

  revenueChart.setOption({
    tooltip: {
      trigger: 'axis',
      formatter: (params) => {
        const param = params[0]
        return `${param.name}<br/>${t('revenue')}: E£ ${param.value.toFixed(2)}`
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: days,
      axisLine: { lineStyle: { color: '#e5e7eb' } },
      axisLabel: { color: '#6b7280', fontSize: 11 }
    },
    yAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: '#f3f4f6', type: 'dashed' } },
      axisLabel: {
        color: '#6b7280',
        fontSize: 11,
        formatter: (value) => `E£ ${value}`
      }
    },
    series: [{
      data: data,
      type: 'line',
      smooth: true,
      lineStyle: {
        color: '#4F46E5',
        width: 3
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(79, 70, 229, 0.3)' },
            { offset: 1, color: 'rgba(79, 70, 229, 0.05)' }
          ]
        }
      },
      itemStyle: {
        color: '#4F46E5'
      }
    }]
  })
}

// Update Orders Chart
const updateOrdersChart = () => {
  if (!ordersChart) return

  const days = Array.from({ length: ordersPeriod.value }, (_, i) => {
    const date = new Date()
    date.setDate(date.getDate() - (ordersPeriod.value - 1 - i))
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short' })
  })

  const data = Array.from({ length: ordersPeriod.value }, () =>
    Math.floor(Math.random() * 20) + 1
  )

  ordersChart.setOption({
    tooltip: {
      trigger: 'axis',
      formatter: (params) => {
        const param = params[0]
        return `${param.name}<br/>${t('orders')}: ${param.value}`
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: days,
      axisLine: { lineStyle: { color: '#e5e7eb' } },
      axisLabel: { color: '#6b7280', fontSize: 11 }
    },
    yAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: '#f3f4f6', type: 'dashed' } },
      axisLabel: { color: '#6b7280', fontSize: 11 }
    },
    series: [{
      data: data,
      type: 'bar',
      barWidth: '50%',
      itemStyle: {
        color: '#10B981',
        borderRadius: [4, 4, 0, 0]
      },
      label: {
        show: true,
        position: 'top',
        color: '#6b7280',
        fontSize: 11
      }
    }]
  })
}

// Handle window resize
const handleResize = () => {
  if (revenueChart) revenueChart.resize()
  if (ordersChart) ordersChart.resize()
}

// Refresh dashboard
const refreshDashboard = () => {
  loadDashboardData()
  loadRecentOrders()
  toast.success(t('dashboard_refreshed'))
}

// Watch for period changes
watch(revenuePeriod, () => {
  updateRevenueChart()
})

watch(ordersPeriod, () => {
  updateOrdersChart()
})

// Lifecycle
onMounted(async () => {
  await loadDashboardData()
  await loadRecentOrders()

  nextTick(() => {
    initCharts()
    window.addEventListener('resize', handleResize)
  })
})

// Cleanup
onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  if (revenueChart) {
    revenueChart.dispose()
    revenueChart = null
  }
  if (ordersChart) {
    ordersChart.dispose()
    ordersChart = null
  }
})
</script>

<style scoped>
.h-64 {
  height: 16rem;
}
</style>
