<script setup>
// import { ref, computed } from 'vue'
import {computed, onMounted, ref} from "vue";
import store from "../../store";
import ProductModal from "./ProductModal.vue";
import ProductsTable from "./ProductsTable.vue";
import { useLanguage } from '../../composables/useLanguage';

const {
  currentLanguage,
  t,

} = useLanguage()

const DEFAULT_PRODUCT = {
  id: '',
  title: '',
  slug: '',
  description: '',
  image: '',
  images: '',
  price: '',
  stock: '',
  sale_price: '',
  new_arrival: '',
}

const showProductModal = ref(false)
const productModel = ref({ ...DEFAULT_PRODUCT })

const products = computed(() => store.state.products)

function showAddNewModal() {
  productModel.value = { ...DEFAULT_PRODUCT }
  showProductModal.value = true
}

function editProduct(p) {
  store.dispatch('getProduct', p.id)
    .then(response => {
      // Most likely fix:
      productModel.value = response.data.data || response.data
      showProductModal.value = true
    })
    .catch(err => {
      console.error('Load product error:', err)
      alert('Failed to load product')
    })
}

function onModalClose() {
  productModel.value = { ...DEFAULT_PRODUCT }
}
</script>

<template>
  <div class="relative p-6">
    <div :class="{ 'opacity-40 pointer-events-none blur-sm': showProductModal }">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-semibold"> {{ t('products') }}</h1>
        <button
          @click="showAddNewModal"
          :disabled="showProductModal"
          class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 disabled:opacity-50"
        >
          {{ t('add_new_product') }}
        </button>
      </div>

      <ProductsTable @clickEdit="editProduct" />
    </div>

    <ProductModal
      v-model="showProductModal"
      :product="productModel"
      @close="onModalClose"
    />
  </div>
</template>
