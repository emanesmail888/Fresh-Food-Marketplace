<template>
  <div class="bg-white p-4 rounded-lg shadow animate-fade-in-down w-full">

    <!-- ==================== TOP BAR ==================== -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b pb-4 mb-4">
      <!-- Left -->
      <div class="flex flex-wrap items-center gap-3">
        <div class="flex items-center gap-2">
          <span class="text-sm text-gray-600 whitespace-nowrap">{{ t('PerPage') }}</span>
          <select
            v-model="perPage"
            @change="getProducts(null)"
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
          {{ t('Found') }} {{ products.total || 0 }} {{ t('products') }}
        </span>
      </div>

      <!-- Right -->
      <div>
        <input
          v-model="search"
          @change="getProducts(null)"
          class="border border-gray-300 rounded-md px-3 py-2 text-sm focus:ring-indigo-500 focus:border-indigo-500 w-full sm:w-64"
          :placeholder="t('Type to Search products') || 'Type to Search products'"
        />
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
              @click="sortProducts('id')"
            >
              {{ t('ID') }}
            </TableHeaderCell>

            <TableHeaderCell field="image">
              {{ t('Image') }}
            </TableHeaderCell>

            <TableHeaderCell
              field="title"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortProducts('title')"
            >
              {{ t('Title') }}
            </TableHeaderCell>

            <TableHeaderCell
              field="price"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortProducts('price')"
            >
              {{ t('price') }}
            </TableHeaderCell>

            <TableHeaderCell
              field="updated_at"
              :sort-field="sortField"
              :sort-direction="sortDirection"
              @click="sortProducts('updated_at')"
            >
              {{ t('created_at') }}
            </TableHeaderCell>

            <TableHeaderCell field="actions">
              {{ t('Actions') }}
            </TableHeaderCell>
          </tr>
        </thead>

        <tbody v-if="products.loading || !products.data?.length">
          <tr>
            <td colspan="6" class="text-center py-12 text-gray-500">
              <Spinner v-if="products.loading" />
              <p v-else>{{ t('No products found.') }}</p>
            </td>
          </tr>
        </tbody>

        <tbody v-else>
          <tr
            v-for="product in products.data"
            :key="product.id"
            class="hover:bg-gray-50"
          >
            <td class="border-b p-3 text-gray-700">{{ product.id }}</td>

            <td class="border-b p-3">
              <img
                v-if="product.image"
                :src="`${storageBase}/${product.image}`"
                :alt="product.title"
                class="w-14 h-14 object-cover rounded-md ring-1 ring-gray-200"
                loading="lazy"
              />
              <div
                v-else
                class="w-14 h-14 bg-gray-100 rounded-md flex items-center justify-center text-gray-400 text-xs"
              >
                {{ t('no_image') }}
              </div>
            </td>

            <td class="border-b p-3 font-medium text-gray-800 max-w-[200px] truncate">
              {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}
            </td>

            <td class="border-b p-3 text-gray-700">
              {{ product.price }}
            </td>

            <td class="border-b p-3 text-gray-600">
              {{ product.created_at }}
            </td>

            <td class="border-b p-3">
              <div class="flex items-center gap-1">
                <button
                  @click="editProduct(product)"
                  class="text-indigo-600 hover:text-indigo-800 p-1.5 rounded-full hover:bg-indigo-50 transition-colors"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                  </svg>
                </button>

                <button
                  @click="deleteProduct(product)"
                  class="text-red-600 hover:text-red-800 p-1.5 rounded-full hover:bg-red-50 transition-colors"
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
        v-if="products.loading || !products.data?.length"
        class="text-center py-12 text-gray-500"
      >
        <Spinner v-if="products.loading" />
        <p v-else>{{ t('No products found.') }}</p>
      </div>

      <!-- Cards -->
      <div
        v-else
        v-for="product in products.data"
        :key="product.id"
        class="bg-white border border-gray-200 rounded-xl p-4 shadow-sm"
      >
        <div class="flex gap-4">
          <!-- Image -->
          <div class="shrink-0">
            <img
              v-if="product.image"
              :src="`${storageBase}/${product.image}`"
              :alt="product.title"
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
              <div class="min-w-0">
                <h3 class="font-semibold text-gray-800 truncate">
                  {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}
                </h3>
                <p class="text-sm text-green-700 font-medium mt-1">
                  {{ product.price }}
                </p>
                <p class="text-xs text-gray-500 mt-1">
                  ID: {{ product.id }} • {{ product.created_at }}
                </p>
              </div>

              <!-- Actions -->
              <div class="flex items-center gap-1 shrink-0">
                <button
                  @click="editProduct(product)"
                  class="p-2 text-indigo-600 hover:bg-indigo-50 rounded-lg"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                  </svg>
                </button>

                <button
                  @click="deleteProduct(product)"
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
      v-if="!products.loading"
      class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4"
    >
      <div v-if="products.data?.length" class="text-sm text-gray-600">
        {{ t('Showing') }} {{ products.from }} {{ t('to') }} {{ products.to }}
        {{ t('of') }} {{ products.total }} {{ t('products') }}
      </div>

      <nav
        v-if="products.total > products.limit"
        class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px"
        aria-label="Pagination"
      >
        <a
          v-for="(link, i) of products.links"
          :key="i"
          href="#"
          @click="getForPage($event, link)"
          class="relative inline-flex items-center px-4 py-2 border text-sm font-medium whitespace-nowrap"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            i === 0 ? 'rounded-l-md' : '',
            i === products.links.length - 1 ? 'rounded-r-md' : '',
            !link.url ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : ''
          ]"
          v-html="link.label"
        ></a>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import store from "../../store";
import Spinner from "../../components/core/Spinner.vue";
import { PRODUCTS_PER_PAGE } from "../../constants";
import TableHeaderCell from "../../components/core/Table/TableHeaderCell.vue";
import { useLanguage } from '../../composables/useLanguage';

const { currentLanguage, t } = useLanguage()

const perPage = ref(PRODUCTS_PER_PAGE);
const search = ref("");
const products = computed(() => store.state.products);
const sortField = ref("updated_at");
const sortDirection = ref("desc");

const emit = defineEmits(["clickEdit"]);
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";

onMounted(() => {
  getProducts();
});

function getForPage(ev, link) {
  ev.preventDefault();
  if (!link.url || link.active) return;
  getProducts(link.url);
}

function getProducts(url = null) {
  store.dispatch("getProducts", {
    url,
    search: search.value,
    per_page: perPage.value,
    sort_field: sortField.value,
    sort_direction: sortDirection.value,
  });
}

function sortProducts(field) {
  if (field === sortField.value) {
    sortDirection.value = sortDirection.value === "desc" ? "asc" : "desc";
  } else {
    sortField.value = field;
    sortDirection.value = "asc";
  }
  getProducts();
}

function deleteProduct(product) {
  if (!confirm(`Are you sure you want to delete the product?`)) return;

  store.dispatch("deleteProduct", product.id).then(() => {
    store.dispatch("getProducts");
  });
}

function editProduct(p) {
  emit("clickEdit", p);
}
</script>
