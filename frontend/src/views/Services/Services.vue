<template>
  <div class="bg-white p-4 rounded-lg shadow animate-fade-in-down sm:w-full">
    <div class="md:flex justify-between border-b-2 pb-3 mb-4">
      <div class="flex items-center pb-2">
        <span class="whitespace-nowrap mr-3">{{ t('PerPage') }}</span>
        <select
          v-model="perPage"
          @change="getServices()"
          class="appearance-none block w-16 px-3 py-2 border border-gray-300 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        >
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="50">50</option>
          <option value="100">100</option>
        </select>
        <span class="ml-4">{{ t('Found') }} {{ services.total }} {{ t('services') }}</span>
      </div>

      <div class="flex items-center gap-4">
        <input
          v-model="search"
          @input="debounceGetServices"
          placeholder="Search services..."
          class="appearance-none block px-4 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm w-64"
        />

        <router-link
          to="/services/create"
          class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        >
          + {{ t('new_service') }}
        </router-link>
      </div>
    </div>

    <table class="table-auto w-full">
      <thead>
        <tr class="bg-gray-50">
          <TableHeaderCell
            field="id"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortServices('id')"
          >
            {{ t('ID') }}
          </TableHeaderCell>

          <TableHeaderCell field="image">{{ t('Image') }}</TableHeaderCell>

          <TableHeaderCell
            field="title"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortServices('title')"
          >
            {{ t('Title') }}
          </TableHeaderCell>

          <TableHeaderCell field="description">{{ t('Description') }}</TableHeaderCell>

          <TableHeaderCell
            field="created_at"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortServices('created_at')"
          >
            {{ t('created_at') }}
          </TableHeaderCell>

          <TableHeaderCell field="actions">{{ t('Actions') }}</TableHeaderCell>
        </tr>
      </thead>

      <tbody v-if="services.loading || !services?.data?.length">
        <tr>
          <td colspan="6" class="text-center py-12 text-gray-500">
            <Spinner v-if="services.loading" />
            <p v-else>{{ t('no_services_found') }}</p>
          </td>
        </tr>
      </tbody>

      <tbody v-else>
        <tr v-for="service in services.data" :key="service.id" class="hover:bg-gray-50">
          <td class="border-b p-3 text-gray-700">{{ service.id }}</td>

          <td class="border-b p-3">
            <img
              v-if="service.image"
              :src="`${storageBase}/${service.image}`"
              :alt="currentLanguage === 'ar' && service.title_ar ? service.title_ar : service.title"
              class="w-16 h-16 object-cover rounded-md ring-1 ring-gray-200"
              loading="lazy"
            />
            <div v-else class="w-16 h-16 bg-gray-100 rounded-md flex items-center justify-center text-gray-400 text-xs">
              {{ t('no_image') }}
            </div>
          </td>

          <td class="border-b p-3 font-medium text-gray-800">
            {{ currentLanguage === 'ar' && service.title_ar ? service.title_ar : service.title }}
          </td>

          <td class="border-b p-3 text-gray-600 max-w-md">
            <div class="truncate">
              {{ currentLanguage === 'ar' && service.description_ar ? service.description_ar : service.description }}
            </div>
          </td>

          <td class="border-b p-3 text-gray-600">
            {{ formatDate(service.created_at) }}
          </td>

          <td class="border-b p-3">
            <div class="flex items-center gap-2">
              <router-link
                :to="`/services/${service.id}/edit`"
                title="Edit service"
                class="text-indigo-600 hover:text-indigo-800 p-1 rounded hover:bg-indigo-50 transition-colors"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                </svg>
              </router-link>

              <button
                @click="deleteService(service)"
                title="Delete service"
                class="text-red-600 hover:text-red-800 p-1 rounded hover:bg-red-50 transition-colors"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Pagination -->
    <div v-if="!services.loading && services.data.length" class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4">
      <div class="text-sm text-gray-600">
        {{ t('Showing') }} {{ services.from || services.meta?.from || 0 }} {{ t('to') }} {{ services.to || services.meta?.to || 0 }} {{ t('of') }} {{ services.total || services.meta?.total || 0 }} {{ t('services') }}

      </div>

      <nav v-if="services.total > perPage" class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
        <a
          v-for="(link, index) in services.links"
          :key="index"
          :href="link.url"
          @click.prevent="getServices(link.url)"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            index === 0 ? 'rounded-l-md' : '',
            index === services.links.length - 1 ? 'rounded-r-md' : '',
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import store from "../../store/index.js";
import Spinner from "../../components/core/Spinner.vue";
import { PRODUCTS_PER_PAGE } from "../../constants.js";
import TableHeaderCell from "../../components/core/Table/TableHeaderCell.vue";
// import { debounce } from 'lodash';
import { useLanguage } from '../../composables/useLanguage';

const {
  currentLanguage,
  t,

} = useLanguage()
const router = useRouter();

const perPage = ref(PRODUCTS_PER_PAGE);
const search = ref('');
const sortField = ref('created_at');
const sortDirection = ref('desc');

const services = computed(() => store.state.services.services);
const storageBase = import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/storage';

onMounted(() => {
  getServices();
});

const getServices = (url = null) => {
  store.dispatch('services/getServices', {
    url,
    search: search.value,
    per_page: perPage.value,
    sort_field: sortField.value,
    sort_direction: sortDirection.value
  });
};


const debounceGetServices = () => {
  getServices();
};
const sortServices = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'desc' ? 'asc' : 'desc';
  } else {
    sortField.value = field;
    sortDirection.value = 'asc';
  }
  getServices();
};

const deleteService = async (service) => {
  if (!confirm(`Delete service "${service.title}"?`)) return;

  try {
    await store.dispatch('services/deleteService', service.id);
    getServices();
    // You can add a toast notification here
  } catch (error) {
    console.error('Failed to delete service:', error);
    alert('Failed to delete service');
  }
};

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
};
</script>
