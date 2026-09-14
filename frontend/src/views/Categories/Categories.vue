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
            @change="getCategories()"
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
          {{ t('Found') }} {{ categories.total || 0 }} {{ t('categories') }}
        </span>
      </div>

      <!-- Right -->
      <div class="flex flex-col sm:flex-row gap-3">
        <input
          v-model="search"
          @input="getCategories()"
          :placeholder="t('Search categories...') || 'Search categories...'"
          class="border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-indigo-500 focus:border-indigo-500 w-full sm:w-64"
        />

        <router-link
          to="/categories/create"
          class="inline-flex items-center justify-center px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-md hover:bg-indigo-700 whitespace-nowrap"
        >
          + {{ t('new_category') }}
        </router-link>
      </div>
    </div>

    <!-- ==================== DESKTOP TABLE ==================== -->
    <div class="hidden md:block overflow-x-auto">
      <table class="table-auto w-full">
        <thead>
          <tr class="bg-gray-50">
            <TableHeaderCell
              field="id"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortCategories('id')"
            >
              {{ t('ID') }}
            </TableHeaderCell>

            <TableHeaderCell field="image">{{ t('Image') }}</TableHeaderCell>

            <TableHeaderCell
              field="name"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortCategories('name')"
            >
              {{ t('name') }}
            </TableHeaderCell>

            <TableHeaderCell
              field="created_at"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortCategories('created_at')"
            >
              {{ t('created_at') }}
            </TableHeaderCell>

            <TableHeaderCell field="actions">{{ t('Actions') }}</TableHeaderCell>
          </tr>
        </thead>

        <tbody v-if="categories.loading || !categories?.data?.length">
          <tr>
            <td colspan="5" class="text-center py-12 text-gray-500">
              <Spinner v-if="categories.loading" />
              <p v-else>{{ t('No categories found.') }}</p>
            </td>
          </tr>
        </tbody>

        <tbody v-else>
          <tr
            v-for="category in categories.data"
            :key="category.id"
            class="hover:bg-gray-50"
          >
            <td class="border-b p-3 text-gray-700">{{ category.id }}</td>

            <td class="border-b p-3">
              <img
                v-if="category.image"
                :src="`${storageBase}/${category.image}`"
                :alt="category.name"
                class="w-16 h-16 object-cover rounded-md ring-1 ring-gray-200"
                loading="lazy"
              />
              <div
                v-else
                class="w-16 h-16 bg-gray-100 rounded-md flex items-center justify-center text-gray-400 text-xs"
              >
                {{ t('no_image') }}
              </div>
            </td>

            <td class="border-b p-3 font-medium text-gray-800">
              {{ currentLanguage === 'ar' && category.name_ar ? category.name_ar : category.name }}
            </td>

            <td class="border-b p-3 text-gray-600">
              {{ formatDate(category.created_at) }}
            </td>

            <td class="border-b p-3">
              <div class="flex items-center gap-2">
                <router-link
                  :to="`/categories/${category.id}/edit`"
                  class="text-indigo-600 hover:text-indigo-800 p-1 rounded hover:bg-indigo-50 transition-colors"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                  </svg>
                </router-link>

                <button
                  @click="deleteCategory(category)"
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
    </div>

    <!-- ==================== MOBILE CARDS ==================== -->
    <div class="md:hidden space-y-4">
      <!-- Loading / Empty -->
      <div
        v-if="categories.loading || !categories?.data?.length"
        class="text-center py-12 text-gray-500"
      >
        <Spinner v-if="categories.loading" />
        <p v-else>{{ t('No categories found.') }}</p>
      </div>

      <!-- Cards -->
      <div
        v-else
        v-for="category in categories.data"
        :key="category.id"
        class="bg-white border border-gray-200 rounded-xl p-4 shadow-sm"
      >
        <div class="flex gap-4">
          <!-- Image -->
          <div class="shrink-0">
            <img
              v-if="category.image"
              :src="`${storageBase}/${category.image}`"
              :alt="category.name"
              class="w-16 h-16 object-cover rounded-lg ring-1 ring-gray-200"
            />
            <div
              v-else
              class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center text-gray-400 text-xs"
            >
              {{ t('no_image') }}
            </div>
          </div>

          <!-- Info + Actions -->
          <div class="flex-1 min-w-0">
            <div class="flex justify-between items-start gap-2">
              <div>
                <h3 class="font-semibold text-gray-800 truncate">
                  {{ currentLanguage === 'ar' && category.name_ar ? category.name_ar : category.name }}
                </h3>
                <p class="text-xs text-gray-500 mt-1">ID: {{ category.id }}</p>
                <p class="text-xs text-gray-500 mt-0.5">{{ formatDate(category.created_at) }}</p>
              </div>

              <!-- Actions -->
              <div class="flex items-center gap-1 shrink-0">
                <router-link
                  :to="`/categories/${category.id}/edit`"
                  class="p-2 text-indigo-600 hover:bg-indigo-50 rounded-lg"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                  </svg>
                </router-link>

                <button
                  @click="deleteCategory(category)"
                  class="p-2 text-red-600 hover:bg-red-50 rounded-lg"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ==================== PAGINATION ==================== -->
    <div
      v-if="!categories.loading && categories?.data?.length"
      class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4"
    >
      <div class="text-sm text-gray-600">
        {{ t('Showing') }} {{ categories.from }} {{ t('to') }} {{ categories.to }}
        {{ t('of') }} {{ categories.total }} {{ t('categories') }}
      </div>

      <nav
        v-if="categories.total > perPage"
        class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
      >
        <a
          v-for="(link, index) in categories.links"
          :key="index"
          :href="link.url"
          @click.prevent="getCategories(link.url)"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            index === 0 ? 'rounded-l-md' : '',
            index === categories.links.length - 1 ? 'rounded-r-md' : '',
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
import { useLanguage } from '../../composables/useLanguage';

const { currentLanguage, t } = useLanguage()

const router = useRouter()

const perPage = ref(PRODUCTS_PER_PAGE)
const search = ref('')
const sortField = ref('id')
const sortDirection = ref('desc')

const categories = computed(() => store.state.categories)

const storageBase = import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/'

onMounted(() => {
  getCategories()
})

const getCategories = (url = null) => {
  store.dispatch('getCategories', {
    url,
    search: search.value,
    per_page: perPage.value,
    sort_field: sortField.value,
    sort_direction: sortDirection.value
  })
}

const sortCategories = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'desc' ? 'asc' : 'desc'
  } else {
    sortField.value = field
    sortDirection.value = 'asc'
  }
  getCategories()
}

const deleteCategory = (category) => {
  if (!confirm(`Delete category "${category.name}"?`)) return

  store.dispatch('deleteCategory', category.id)
    .then(() => {
      getCategories()
    })
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}
</script>
