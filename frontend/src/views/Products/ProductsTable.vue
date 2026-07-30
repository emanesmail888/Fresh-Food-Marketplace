<template>
  <div class="bg-white py-4 pl-1 rounded-lg shadow animate-fade-in-down w-full overflow-hidden">
    <div class="md:flex  justify-between border-b-2 pb-3">
      <div class="flex items-center pb-2">
        <span class="whitespace-nowrap mr-3">{{ t('PerPage') }}</span>
        <select
          @change="getProducts(null)"
          v-model="perPage"
          class="appearance-none relative block w-12  px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
        >
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="50">50</option>
          <option value="100">100</option>
        </select>
        <span class="ml-3 sm:ml-1 ">  {{ t('Found') }} {{ products.total }} {{ t('products') }}</span>

      </div>
      <div >
        <input
          v-model="search"
          @change="getProducts(null)"
          class=" appearance-none relative block px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm "
          placeholder="Type to Search products"
        />
      </div>
    </div>

    <table class="table-auto w-full   ">
      <thead class="overflow-hidden">
        <tr>
          <TableHeaderCell
            field="id"
            :sort-field="sortField"
            :sort-direction="sortDirection"
            @click="sortProducts('id')"
          >
             {{ t('ID') }}
          </TableHeaderCell>
          <TableHeaderCell
            field="image"
            :sort-field="sortField"
            :sort-direction="sortDirection"
          >
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
          <TableHeaderCell field="actions"> {{ t('Actions') }} </TableHeaderCell>
        </tr>
      </thead>
      <tbody v-if="products.loading || !products.data.length">
        <tr>
          <td colspan="6">
            <Spinner v-if="products.loading" />
            <p v-else class="text-center py-8 text-gray-700">
             {{ t('No products found.') }}
            </p>
          </td>
        </tr>
      </tbody>
      <tbody v-else>
        <tr v-for="product in products.data" :key="product.id">
          <td class="border-b p-2">{{ product.id }}</td>
          <td class="border-b p-2">
            <img
              v-if="product.image"
              :src="`${storageBase}/${product.image}`"
              :alt="product.title"
              class="inline-block w-14 h-14 object-cover rounded-md ring-1 ring-gray-200"
              loading="lazy"
            />
          </td>
          <td
            class="border-b p-2 max-w-50 whitespace-nowrap overflow-hidden text-ellipsis"
          >
            {{ currentLanguage === 'ar' && product.title_ar ? product.title_ar : product.title }}
          </td>
          <td class="border-b p-2">
            {{ product.price }}
          </td>
          <td class="border-b p-2">
            {{ product.created_at }}
          </td>

          <td
            class="border-b p-2 "
          >
            <div class="flex items-center ">
              <!-- Edit button -->
              <button
                @click="editProduct(product)"
                title="Edit product"
                class="text-indigo-600 hover:text-indigo-800 transition-colors p-1 rounded-full hover:bg-indigo-50"
              >
                <svg
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                  />
                </svg>
              </button>

              <!-- Delete button -->
              <button
                @click="deleteProduct(product)"
                title="Delete product"
                class="text-red-600 hover:text-red-800 transition-colors p-1 rounded-full hover:bg-red-50"
              >
                <svg
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                  />
                </svg>
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>


    <div
      v-if="!products.loading"
      class="flex justify-between items-center mt-5"
    >
      <div v-if="products.data.length">
        {{ t('Showing') }} {{ products.from }} {{ t('to') }} {{ products.to }} {{ t('of') }} {{ products.total }} {{ t('products') }}



      </div>
      <nav
        v-if="products.total > products.limit"
        class="relative z-0 inline-flex justify-center rounded-md shadow-sm -space-x-px"
        aria-label="Pagination"
      >
        <!-- Current: "z-10 bg-indigo-50 border-indigo-500 text-indigo-600", Default: "bg-white border-gray-300 text-gray-500 hover:bg-gray-50" -->
        <a
          v-for="(link, i) of products.links"
          :key="i"
          :disabled="!link.url"
          href="#"
          @click="getForPage($event, link)"
          aria-current="page"
          class="relative inline-flex items-center px-4 py-2 border text-sm font-medium whitespace-nowrap"
          :class="[
            link.active
              ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
              : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
            i === 0 ? 'rounded-l-md' : '',
            i === products.links.length - 1 ? 'rounded-r-md' : '',
            !link.url ? ' bg-gray-100 text-gray-700' : '',
          ]"
          v-html="link.label"
        >
        </a>
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
import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/vue";
import ProductModal from "./ProductModal.vue";
import { useLanguage } from '../../composables/useLanguage';

const {
  currentLanguage,
  t,

} = useLanguage()

const perPage = ref(PRODUCTS_PER_PAGE);
const search = ref("");
const products = computed(() => store.state.products);
const sortField = ref("updated_at");
const sortDirection = ref("desc");

const product = ref({});
const showProductModal = ref(false);

const emit = defineEmits(["clickEdit"]);
const storageBase =
  import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";

onMounted(() => {
  getProducts();
});

function getForPage(ev, link) {
  ev.preventDefault();
  if (!link.url || link.active) {
    return;
  }

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
    if (sortDirection.value === "desc") {
      sortDirection.value = "asc";
    } else {
      sortDirection.value = "desc";
    }
  } else {
    sortField.value = field;
    sortDirection.value = "asc";
  }

  getProducts();
}

function showAddNewModal() {
  showProductModal.value = true;
}

function deleteProduct(product) {
  if (!confirm(`Are you sure you want to delete the product?`)) {
    return;
  }
  store.dispatch("deleteProduct", product.id).then((res) => {
    // TODO Show notification
    store.dispatch("getProducts");
  });
}

function editProduct(p) {
  emit("clickEdit", p);
}
</script>

<style scoped>
</style>
