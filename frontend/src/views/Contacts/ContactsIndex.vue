<template>
  <div class="bg-white p-4 rounded-lg shadow animate-fade-in-down sm:w-full">

    <!-- ==================== TOP BAR ==================== -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b pb-4 mb-4">
      <!-- Left -->
      <div class="flex flex-wrap items-center gap-3">
        <div class="flex items-center gap-2">
          <span class="text-sm text-gray-600 whitespace-nowrap">{{ t('PerPage') }}</span>
          <select
            v-model="perPage"
            @change="getContacts()"
            class="border border-gray-300 rounded-md px-2 py-1.5 text-sm focus:ring-indigo-500 focus:border-indigo-500"
          >
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="20">20</option>
            <option value="50">50</option>
            <option value="100">100</option>
          </select>
        </div>
        <span class="text-sm text-gray-500">
          {{ t('Found') }} {{ contacts.total || 0 }} {{ t('messages') }}
        </span>
      </div>

      <!-- Right -->
      <div class="flex flex-col sm:flex-row gap-3">
        <input
          v-model="search"
          @input="debounceGetContacts"
          :placeholder="t('search_messages')"
          class="border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-indigo-500 focus:border-indigo-500 w-full sm:w-64"
        />
        <button
          @click="refreshContacts"
          class="inline-flex items-center justify-center px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-200 whitespace-nowrap"
        >
          <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          {{ t('refresh') }}
        </button>
      </div>
    </div>

    <!-- ==================== STATS CARDS ==================== -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
      <div class="bg-blue-50 p-3 sm:p-4 rounded-lg">
        <p class="text-xs sm:text-sm text-blue-600">{{ t('total_messages') }}</p>
        <p class="text-xl sm:text-2xl font-bold text-blue-700">{{ stats?.total || 0 }}</p>
      </div>
      <div class="bg-yellow-50 p-3 sm:p-4 rounded-lg">
        <p class="text-xs sm:text-sm text-yellow-600">{{ t('pending') }}</p>
        <p class="text-xl sm:text-2xl font-bold text-yellow-700">{{ stats?.pending || 0 }}</p>
      </div>
      <div class="bg-green-50 p-3 sm:p-4 rounded-lg">
        <p class="text-xs sm:text-sm text-green-600">{{ t('replied') }}</p>
        <p class="text-xl sm:text-2xl font-bold text-green-700">{{ stats?.replied || 0 }}</p>
      </div>
      <div class="bg-purple-50 p-3 sm:p-4 rounded-lg">
        <p class="text-xs sm:text-sm text-purple-600">{{ t('archived') }}</p>
        <p class="text-xl sm:text-2xl font-bold text-purple-700">{{ stats?.archived || 0 }}</p>
      </div>
    </div>

    <!-- ==================== STATUS FILTER ==================== -->
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
        <span v-if="status.value !== 'all'" class="ml-1 text-xs opacity-75">
          ({{ getStatusCount(status.value) }})
        </span>
      </button>
    </div>

    <!-- ==================== DESKTOP TABLE ==================== -->
    <div class="hidden lg:block overflow-x-auto">
      <table class="table-auto w-full">
        <thead>
          <tr class="bg-gray-50">
            <th class="border-b p-3 text-left">
              <input
                type="checkbox"
                @change="toggleAllSelection"
                :checked="isAllSelected"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
            </th>
            <TableHeaderCell field="id" :sort-field="sortField" :sort-direction="sortDirection" @click="sortContacts('id')">
              {{ t('ID') }}
            </TableHeaderCell>
            <TableHeaderCell field="name" :sort-field="sortField" :sort-direction="sortDirection" @click="sortContacts('name')">
              {{ t('name') }}
            </TableHeaderCell>
            <TableHeaderCell field="email" :sort-field="sortField" :sort-direction="sortDirection" @click="sortContacts('email')">
              {{ t('email') }}
            </TableHeaderCell>
            <TableHeaderCell field="subject">{{ t('subject') }}</TableHeaderCell>
            <TableHeaderCell field="message">{{ t('message') }}</TableHeaderCell>
            <TableHeaderCell field="status" :sort-field="sortField" :sort-direction="sortDirection" @click="sortContacts('status')">
              {{ t('status') }}
            </TableHeaderCell>
            <TableHeaderCell field="created_at" :sort-field="sortField" :sort-direction="sortDirection" @click="sortContacts('created_at')">
              {{ t('date') }}
            </TableHeaderCell>
            <TableHeaderCell field="actions">{{ t('Actions') }}</TableHeaderCell>
          </tr>
        </thead>

        <tbody v-if="contacts.loading">
          <tr>
            <td colspan="9" class="text-center py-12">
              <div class="flex justify-center">
                <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-indigo-600 border-t-transparent"></div>
              </div>
              <p class="text-gray-500 mt-2">{{ t('loading') }}...</p>
            </td>
          </tr>
        </tbody>

        <tbody v-else-if="!contacts?.data?.length">
          <tr>
            <td colspan="9" class="text-center py-12 text-gray-500">
              <p>{{ t('no_messages_found') }}</p>
            </td>
          </tr>
        </tbody>

        <tbody v-else>
          <tr v-for="contact in contacts.data" :key="contact.id" class="hover:bg-gray-50">
            <td class="border-b p-3">
              <input type="checkbox" v-model="selectedIds" :value="contact.id"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500" />
            </td>
            <td class="border-b p-3 text-gray-700">{{ contact.id }}</td>
            <td class="border-b p-3">
              <div class="flex items-center">
                <div class="w-8 h-8 bg-indigo-100 rounded-full flex items-center justify-center text-indigo-600 font-semibold text-sm">
                  {{ contact.name.charAt(0).toUpperCase() }}
                </div>
                <span class="ml-2 font-medium text-gray-800">{{ contact.name }}</span>
              </div>
            </td>
            <td class="border-b p-3 text-gray-600">
              <a :href="`mailto:${contact.email}`" class="text-indigo-600 hover:text-indigo-800">{{ contact.email }}</a>
              <span v-if="contact.phone" class="block text-xs text-gray-400">{{ contact.phone }}</span>
            </td>
            <td class="border-b p-3 text-gray-600 max-w-xs">
              <div class="truncate">{{ contact.subject || '-' }}</div>
            </td>
            <td class="border-b p-3 text-gray-600 max-w-sm">
              <div class="truncate">{{ contact.message }}</div>
            </td>
            <td class="border-b p-3">
              <span :class="getStatusBadgeClass(contact.status)">
                {{ getStatusLabel(contact.status) }}
              </span>
            </td>
            <td class="border-b p-3 text-gray-600">
              <div>
                <span>{{ formatDate(contact.created_at) }}</span>
                <span v-if="!contact.read_at && contact.status === 'pending'"
                  class="ml-2 inline-block w-2 h-2 bg-red-500 rounded-full"></span>
              </div>
            </td>
            <td class="border-b p-3">
              <div class="flex items-center gap-1">
                <button @click="viewContact(contact)" class="text-blue-600 hover:text-blue-800 p-1.5 rounded hover:bg-blue-50">
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </button>
                <button v-if="contact.status !== 'replied' && contact.status !== 'archived'"
                  @click="replyContact(contact)"
                  class="text-green-600 hover:text-green-800 p-1.5 rounded hover:bg-green-50">
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                  </svg>
                </button>
                <button v-if="contact.status !== 'archived'"
                  @click="archiveContact(contact)"
                  class="text-gray-600 hover:text-gray-800 p-1.5 rounded hover:bg-gray-50">
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                  </svg>
                </button>
                <button @click="deleteContact(contact)" class="text-red-600 hover:text-red-800 p-1.5 rounded hover:bg-red-50">
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- ==================== MOBILE / TABLET CARDS ==================== -->
    <div class="lg:hidden space-y-4">
      <!-- Loading -->
      <div v-if="contacts.loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-indigo-600 border-t-transparent"></div>
        <p class="text-gray-500 mt-2">{{ t('loading') }}...</p>
      </div>

      <!-- Empty -->
      <div v-else-if="!contacts?.data?.length" class="text-center py-12 text-gray-500">
        <p>{{ t('no_messages_found') }}</p>
      </div>

      <!-- Cards -->
      <div
        v-else
        v-for="contact in contacts.data"
        :key="contact.id"
        class="bg-white border border-gray-200 rounded-xl p-4 shadow-sm"
      >
        <!-- Header: Avatar + Name + Status -->
        <div class="flex items-start justify-between gap-3 mb-3">
          <div class="flex items-center gap-3 min-w-0">
            <input type="checkbox" v-model="selectedIds" :value="contact.id"
              class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 mt-1" />
            <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center text-indigo-600 font-semibold shrink-0">
              {{ contact.name.charAt(0).toUpperCase() }}
            </div>
            <div class="min-w-0">
              <p class="font-semibold text-gray-800 truncate">{{ contact.name }}</p>
              <a :href="`mailto:${contact.email}`" class="text-sm text-indigo-600 truncate block">
                {{ contact.email }}
              </a>
            </div>
          </div>
          <span :class="getStatusBadgeClass(contact.status)" class="shrink-0">
            {{ getStatusLabel(contact.status) }}
          </span>
        </div>

        <!-- Subject & Message -->
        <div class="mb-3">
          <p class="text-sm font-medium text-gray-700 truncate">
            {{ contact.subject || '-' }}
          </p>
          <p class="text-sm text-gray-500 line-clamp-2 mt-1">
            {{ contact.message }}
          </p>
        </div>

        <!-- Footer: Date + Actions -->
        <div class="flex items-center justify-between pt-3 border-t border-gray-100">
          <p class="text-xs text-gray-400">
            {{ formatDate(contact.created_at) }}
            <span v-if="!contact.read_at && contact.status === 'pending'"
              class="ml-1 inline-block w-2 h-2 bg-red-500 rounded-full"></span>
          </p>

          <div class="flex items-center gap-1">
            <button @click="viewContact(contact)" class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
            </button>
            <button v-if="contact.status !== 'replied' && contact.status !== 'archived'"
              @click="replyContact(contact)"
              class="p-2 text-green-600 hover:bg-green-50 rounded-lg">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
              </svg>
            </button>
            <button v-if="contact.status !== 'archived'"
              @click="archiveContact(contact)"
              class="p-2 text-gray-600 hover:bg-gray-50 rounded-lg">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
              </svg>
            </button>
            <button @click="deleteContact(contact)" class="p-2 text-red-600 hover:bg-red-50 rounded-lg">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ==================== PAGINATION ==================== -->
    <div
      v-if="!contacts.loading && contacts.data?.length"
      class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4"
    >
      <div class="text-sm text-gray-600">
        {{ t('Showing') }} {{ contacts.from || 0 }} {{ t('to') }} {{ contacts.to || 0 }}
        {{ t('of') }} {{ contacts.total || 0 }} {{ t('messages') }}
      </div>

      <nav v-if="contacts.total > perPage" class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
        <a
          v-for="(link, index) in contacts.links"
          :key="index"
          :href="link.url"
          @click.prevent="getContacts(link.url)"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            index === 0 ? 'rounded-l-md' : '',
            index === contacts.links.length - 1 ? 'rounded-r-md' : '',
            !link.url ? 'opacity-50 cursor-not-allowed' : ''
          ]"
          class="relative inline-flex items-center px-4 py-2 border text-sm font-medium"
          v-html="link.label"
        ></a>
      </nav>
    </div>

    <!-- ==================== MODAL (kept as is, already responsive) ==================== -->
    <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" @click.self="closeModal">
      <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-xl font-bold text-gray-800">
              {{ isReplyMode ? t('reply_message') : t('view_message') }}
            </h3>
            <button @click="closeModal" class="text-gray-500 hover:text-gray-700 p-1 rounded-full hover:bg-gray-100">
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <div v-if="selectedContact" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 bg-gray-50 p-4 rounded-lg">
              <div>
                <p class="text-sm text-gray-500">{{ t('name') }}</p>
                <p class="font-medium text-gray-800">{{ selectedContact.name }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-500">{{ t('email') }}</p>
                <a :href="`mailto:${selectedContact.email}`" class="text-indigo-600 hover:text-indigo-800">
                  {{ selectedContact.email }}
                </a>
              </div>
              <div v-if="selectedContact.phone">
                <p class="text-sm text-gray-500">{{ t('phone') }}</p>
                <p class="font-medium text-gray-800">{{ selectedContact.phone }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-500">{{ t('date') }}</p>
                <p class="font-medium text-gray-800">{{ formatDate(selectedContact.created_at) }}</p>
              </div>
              <div class="md:col-span-2">
                <p class="text-sm text-gray-500">{{ t('subject') }}</p>
                <p class="font-medium text-gray-800">{{ selectedContact.subject || '-' }}</p>
              </div>
              <div class="md:col-span-2">
                <p class="text-sm text-gray-500">{{ t('status') }}</p>
                <span :class="getStatusBadgeClass(selectedContact.status)" class="inline-block mt-1">
                  {{ getStatusLabel(selectedContact.status) }}
                </span>
              </div>
            </div>

            <div>
              <p class="text-sm text-gray-500 mb-2">{{ t('message') }}</p>
              <div class="bg-gray-50 p-4 rounded-lg whitespace-pre-wrap text-gray-700 max-h-60 overflow-y-auto">
                {{ selectedContact.message }}
              </div>
            </div>

            <div v-if="isReplyMode" class="border-t pt-4">
              <label for="reply" class="block text-sm font-medium text-gray-700 mb-2">{{ t('your_reply') }}</label>
              <textarea
                id="reply"
                v-model="replyText"
                rows="4"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                :placeholder="t('enter_your_reply')"
              ></textarea>
            </div>

            <div v-if="!isReplyMode && selectedContact.status !== 'archived'" class="border-t pt-4">
              <label class="block text-sm font-medium text-gray-700 mb-2">{{ t('update_status') }}</label>
              <select
                v-model="selectedStatusUpdate"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              >
                <option value="pending">{{ t('pending') }}</option>
                <option value="read">{{ t('read') }}</option>
                <option value="replied">{{ t('replied') }}</option>
                <option value="archived">{{ t('archived') }}</option>
              </select>
            </div>

            <div class="flex flex-wrap gap-3 pt-4 border-t">
              <button
                v-if="isReplyMode"
                @click="sendReply"
                :disabled="!replyText.trim()"
                class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 disabled:opacity-50"
              >
                {{ t('send_reply') }}
              </button>
              <button
                v-if="!isReplyMode && selectedContact.status !== 'replied' && selectedContact.status !== 'archived'"
                @click="toggleReplyMode"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
              >
                {{ t('reply') }}
              </button>
              <button
                v-if="!isReplyMode"
                @click="updateStatus"
                class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
              >
                {{ t('update_status') }}
              </button>
              <button @click="closeModal" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300">
                {{ t('close') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useToast } from 'vue-toastification'
import TableHeaderCell from "../../components/core/Table/TableHeaderCell.vue"
import { useLanguage } from '../../composables/useLanguage'

const store = useStore()
const toast = useToast()
const { t } = useLanguage()

// State
const perPage = ref(10)
const search = ref('')
const sortField = ref('created_at')
const sortDirection = ref('desc')
const selectedStatus = ref('all')
const selectedIds = ref([])
const selectedContact = ref(null)
const showModal = ref(false)
const isReplyMode = ref(false)
const replyText = ref('')
const selectedStatusUpdate = ref('')

// Computed
const contacts = computed(() => store.state.contact?.contacts || { data: [], loading: false, total: 0 })
const stats = computed(() => store.state.contact?.stats || null)

const isAllSelected = computed(() => {
  return contacts.value.data?.length > 0 &&
         selectedIds.value.length === contacts.value.data?.length
})

// Status Filters
const statusFilters = [
  { value: 'all', label: t('all'), color: 'bg-gray-500' },
  { value: 'pending', label: t('pending'), color: 'bg-yellow-500' },
  { value: 'read', label: t('read'), color: 'bg-blue-500' },
  { value: 'replied', label: t('replied'), color: 'bg-green-500' },
  { value: 'archived', label: t('archived'), color: 'bg-purple-500' },
]

const getStatusCount = (status) => {
  if (!stats.value) return 0
  return stats.value[status] || 0
}

// Methods
const getContacts = (url = null) => {
  const params = {
    url,
    search: search.value,
    per_page: perPage.value,
    sort_field: sortField.value,
    sort_direction: sortDirection.value,
  }
  if (selectedStatus.value !== 'all') {
    params.status = selectedStatus.value
  }
  store.dispatch('contact/getContacts', params)
}

const debounceGetContacts = () => {
  getContacts()
}

const refreshContacts = () => {
  getContacts()
  loadStats()
}

const sortContacts = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'desc' ? 'asc' : 'desc'
  } else {
    sortField.value = field
    sortDirection.value = 'asc'
  }
  getContacts()
}

const filterByStatus = (status) => {
  selectedStatus.value = status
  getContacts()
}

const loadStats = async () => {
  try {
    await store.dispatch('contact/getContactStats')
  } catch (error) {
    console.error('Failed to load stats:', error)
  }
}

const toggleAllSelection = () => {
  if (isAllSelected.value) {
    selectedIds.value = []
  } else {
    selectedIds.value = contacts.value.data.map(c => c.id)
  }
}

const viewContact = (contact) => {
  selectedContact.value = contact
  selectedStatusUpdate.value = contact.status
  isReplyMode.value = false
  replyText.value = ''
  showModal.value = true

  if (contact.status === 'pending') {
    store.dispatch('contact/updateContact', {
      id: contact.id,
      data: { status: 'read' }
    }).then(() => {
      getContacts()
      loadStats()
    })
  }
}

const replyContact = (contact) => {
  viewContact(contact)
  isReplyMode.value = true
}

const toggleReplyMode = () => {
  isReplyMode.value = !isReplyMode.value
}

const sendReply = async () => {
  if (!replyText.value.trim()) return
  try {
    const response = await store.dispatch('contact/updateContact', {
      id: selectedContact.value.id,
      data: { status: 'replied', reply: replyText.value }
    })
    if (response.success) {
      toast.success(t('reply_sent_successfully'))
      closeModal()
      getContacts()
      loadStats()
    } else {
      toast.error(response.message || t('failed_to_send_reply'))
    }
  } catch (error) {
    toast.error(t('failed_to_send_reply'))
  }
}

const updateStatus = async () => {
  if (!selectedContact.value) return
  try {
    const response = await store.dispatch('contact/updateContact', {
      id: selectedContact.value.id,
      data: { status: selectedStatusUpdate.value }
    })
    if (response.success) {
      toast.success(t('status_updated_successfully'))
      closeModal()
      getContacts()
      loadStats()
    } else {
      toast.error(response.message || t('failed_to_update_status'))
    }
  } catch (error) {
    toast.error(t('failed_to_update_status'))
  }
}

const archiveContact = async (contact) => {
  if (!confirm(t('confirm_archive'))) return
  try {
    const response = await store.dispatch('contact/updateContact', {
      id: contact.id,
      data: { status: 'archived' }
    })
    if (response.success) {
      toast.success(t('archived_successfully'))
      getContacts()
      loadStats()
    } else {
      toast.error(response.message || t('failed_to_archive'))
    }
  } catch (error) {
    toast.error(t('failed_to_archive'))
  }
}

const deleteContact = async (contact) => {
  if (!confirm(t('confirm_delete'))) return
  try {
    const response = await store.dispatch('contacts/deleteContact', contact.id)
    if (response.success) {
      toast.success(t('deleted_successfully'))
      getContacts()
      loadStats()
    } else {
      toast.error(response.message || t('failed_to_delete'))
    }
  } catch (error) {
    toast.error(t('failed_to_delete'))
  }
}

const closeModal = () => {
  showModal.value = false
  selectedContact.value = null
  isReplyMode.value = false
  replyText.value = ''
}

const getStatusBadgeClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    read: 'bg-blue-100 text-blue-800',
    replied: 'bg-green-100 text-green-800',
    archived: 'bg-gray-100 text-gray-800',
  }
  return `px-2 py-1 text-xs rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`
}

const getStatusLabel = (status) => {
  const labels = {
    pending: t('Pending'),
    read: t('Read'),
    replied: t('Replied'),
    archived: t('Archived'),
  }
  return labels[status] || status
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(() => {
  getContacts()
  loadStats()
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
