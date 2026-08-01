<template>
  <TransitionRoot as="template" :show="show">
    <Dialog as="div" class="relative z-50" @close="closeModal">
      <!-- Backdrop -->
      <TransitionChild
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/70 transition-opacity" />
      </TransitionChild>

      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
        >
          <TransitionChild
            enter="ease-out duration-300"
            enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            enter-to="opacity-100 translate-y-0 sm:scale-100"
            leave="ease-in duration-200"
            leave-from="opacity-100 translate-y-0 sm:scale-100"
            leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          >
            <DialogPanel
              class="relative transform overflow-hidden rounded-xl bg-white text-left shadow-2xl transition-all sm:my-8 md:w-5xl sm:w-full sm:max-w-3xl"
            >
              <!-- Loading overlay -->
              <Spinner
                v-if="loading"
                class="absolute inset-0 z-20 flex items-center justify-center bg-white/70 backdrop-blur-sm"
              />

              <!-- Header -->
              <header
                class="flex items-center justify-between border-b border-gray-200 px-6 py-4"
              >
                <DialogTitle class="text-xl font-semibold text-gray-900">
                  {{
                    form.id
                      ? t('edit_product', { title: form.title || "..." })
                      : t('create_new_product')
                  }}
                </DialogTitle>
                <button
                  @click="closeModal"
                  class="rounded-full p-1.5 hover:bg-gray-100 transition"
                >
                  <svg
                    class="h-6 w-6 text-gray-600"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M6 18L18 6M6 6l12 12"
                    />
                  </svg>
                </button>
              </header>

              <!-- Form -->
              <form
                @submit.prevent="onSubmit"
                class="p-6 space-y-6 max-h-[70vh] overflow-y-auto"
                :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
              >
                <!-- Title + Slug -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('product_title') }} *</label
                    >
                    <input
                      v-model="form.title"
                      type="text"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                      :placeholder="t('title_placeholder')"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('product_title_ar') }} *</label
                    >
                    <input
                      v-model="form.title_ar"
                      type="text"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                      :placeholder="t('title_ar_placeholder')"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('slug') }} *</label
                    >
                    <input
                      v-model="form.slug"
                      type="text"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm disabled:bg-gray-100"
                      :placeholder="t('slug_placeholder')"
                    />
                  </div>
                </div>

                <!-- Description -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >{{ t('description') }}</label
                  >
                  <textarea
                    v-model="form.description"
                    rows="4"
                    class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    :placeholder="t('description_placeholder')"
                  ></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >{{ t('description_ar') }}</label
                  >
                  <textarea
                    v-model="form.description_ar"
                    rows="4"
                    class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    :placeholder="t('description_ar_placeholder')"
                  ></textarea>
                </div>

                <!-- Price + Sale Price -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('regular_price') }} *</label
                    >
                    <div class="relative rounded-md shadow-sm">
                      <div
                        class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
                      >
                        <span class="text-gray-500 sm:text-sm">{{ t('currency_symbol') }}</span>
                      </div>
                      <input
                        v-model.number="form.price"
                        type="number"
                        step="0.01"
                        required
                        class="block w-full p-2 rounded-md border-gray-300 pl-7 focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                        placeholder="0.00"
                      />
                    </div>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('sale_price') }}</label
                    >
                    <div class="relative rounded-md shadow-sm">
                      <div
                        class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
                      >
                        <span class="text-gray-500 sm:text-sm">{{ t('currency_symbol') }}</span>
                      </div>
                      <input
                        v-model.number="form.sale_price"
                        type="number"
                        step="0.01"
                        class="block w-full p-2 rounded-md border-gray-300 pl-7 focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                        placeholder="0.00"
                      />
                    </div>
                  </div>
                </div>

                <!-- Stock + Category -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('stock') }} *</label
                    >
                    <input
                      v-model.number="form.stock"
                      type="number"
                      min="0"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                      placeholder="0"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('category') }} *</label
                    >
                    <select
                      v-model="form.category_id"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    >
                      <option value="">{{ t('select_category') }}</option>
                      <option
                        v-for="cat in allCategories"
                        :key="cat?.id"
                        :value="cat?.id"
                      >
                        {{ cat?.name || t('unnamed_category') }}
                      </option>
                    </select>
                  </div>
                </div>

                <!-- Flags -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div class="flex flex-wrap gap-8">
                    <label class="flex items-center">
                      <input
                        v-model="form.new_arrival"
                        type="checkbox"
                        class="h-6 w-10 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                      />
                      <span class="ml-2 text-sm text-gray-700">{{ t('new_arrival') }}</span>
                    </label>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >{{ t('unit') }} *</label
                    >
                    <select
                      v-model="form.unit"
                      required
                      class="block w-full p-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    >
                      <option value="kg">{{ t('unit_kg') }}</option>
                      <option value="g">{{ t('unit_g') }}</option>
                      <option value="piece">{{ t('unit_piece') }}</option>
                      <option value="liter">{{ t('unit_liter') }}</option>
                      <option value="pack">{{ t('unit_pack') }}</option>
                      <option value="bunch">{{ t('unit_bunch') }}</option>
                    </select>
                  </div>
                </div>

                <!-- Main Image -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >{{ t('main_image') }}</label
                  >
                  <div class="mt-1 flex items-center gap-6">
                    <div class="shrink-0">
                      <img
                        v-if="mainImagePreview"
                        :src="mainImagePreview"
                        class="h-24 w-24 rounded-lg object-cover border border-gray-200 shadow-sm"
                      />
                      <div
                        v-else
                        class="h-24 w-24 rounded-lg bg-gray-100 flex items-center justify-center text-sm text-gray-400"
                      >
                        {{ t('no_image') }}
                      </div>
                    </div>
                    <input
                      type="file"
                      accept="image/*"
                      @change="handleMainImageChange"
                      class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
                    />
                  </div>
                </div>

                <!-- Gallery Images -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >{{ t('gallery_images') }}</label
                  >
                  <input
                    type="file"
                    multiple
                    accept="image/*"
                    @change="handleGalleryChange"
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-1 file:text-sm file:font-semibold file:bg-violet-50 file:text-violet-700 hover:file:bg-violet-100"
                  />

                  <div
                    v-if="galleryPreviews.length"
                    class="mt-4 grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3"
                  >
                    <div
                      v-for="(preview, idx) in galleryPreviews"
                      :key="idx"
                      class="relative group"
                    >
                      <img
                        :src="preview"
                        class="h-24 w-full object-cover rounded-md border border-gray-200 shadow-sm"
                      />
                      <button
                        @click="removeGalleryImage(idx)"
                        class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs shadow opacity-0 group-hover:opacity-100 transition"
                      >
                        ×
                      </button>
                    </div>
                  </div>
                </div>

                <!-- Submit buttons -->
                <div class="mt-8 flex justify-end gap-4 border-t pt-5">
                  <button
                    type="button"
                    @click="closeModal"
                    class="px-6 py-2.5 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
                  >
                    {{ t('cancel') }}
                  </button>
                  <button
                    type="submit"
                    :disabled="loading"
                    class="px-8 py-2.5 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 disabled:opacity-60 transition-colors"
                  >
                    {{
                      loading
                        ? t('saving')
                        : form.id
                        ? t('update_product')
                        : t('create_product')
                    }}
                  </button>
                </div>
              </form>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import { ref, watch, computed, onMounted } from "vue";
import { useLanguage } from '../../composables/useLanguage';
import store from "../../store/index.js";
import Spinner from "../../components/core/Spinner.vue";
import {
  Dialog,
  DialogPanel,
  DialogTitle,
  TransitionChild,
  TransitionRoot,
} from "@headlessui/vue";

const {
  currentLanguage,
  t,
} = useLanguage();

const storageBase =
  import.meta.env.VITE_STORAGE_URL ;

// Props & Emits
const props = defineProps({
  modelValue: Boolean,
  product: { type: Object, default: () => ({}) },
});

const emit = defineEmits(["update:modelValue", "close", "saved"]);

const show = computed({
  get: () => props.modelValue,
  set: (val) => emit("update:modelValue", val),
});

// Form state
const form = ref({
  id: null,
  title: "",
  title_ar: "",
  slug: "",
  description: "",
  description_ar: "",
  price: null,
  sale_price: null,
  stock: 0,
  category_id: null,
  new_arrival: false,
  unit: "kg",
  image: null,
  images: [],
});

const mainImagePreview = ref(null);
const galleryPreviews = ref([]);
const allCategories = computed(() => store.state.allCategories || []);

// Load categories when modal becomes visible (only if empty)
watch(
  () => show.value,
  async (isOpen) => {
    if (isOpen && store.state.allCategories.length === 0) {
      try {
        await store.dispatch("getAllCategories");
      } catch (err) {
        console.error("Failed to load categories:", err);
      }
    }
  },
  { immediate: true }
);

// Sync product → form
watch(
  () => props.product,
  (p) => {
    if (p?.id) {
      form.value = {
        id: p.id,
        title: p.title || "",
        title_ar: p.title_ar || "",
        slug: p.slug || "",
        description: p.description || "",
        description_ar: p.description_ar || "",
        price: p.price ?? null,
        sale_price: p.sale_price ?? null,
        stock: p.stock ?? 0,
        category_id: p.category_id ?? null,
        new_arrival: !!p.new_arrival,
        unit: p.unit || "kg",
        image: null,
        images: [],
      };
      mainImagePreview.value = p.image ? `${storageBase}/${p.image}` : null;

      if (p.images) {
        const imgs =
          typeof p.images === "string" ? JSON.parse(p.images) : p.images;
        galleryPreviews.value = imgs.map((img) => `${storageBase}/${img}`);
      }
    } else {
      Object.assign(form.value, {
        id: null,
        title: "",
        title_ar: "",
        slug: "",
        description: "",
        description_ar: "",
        price: null,
        sale_price: null,
        stock: 0,
        category_id: null,
        new_arrival: false,
        unit: "kg",
        image: null,
        images: [],
      });
      mainImagePreview.value = null;
      galleryPreviews.value = [];
    }
  },
  { immediate: true }
);

// File handlers
function handleMainImageChange(e) {
  const file = e.target.files?.[0];
  if (file) {
    form.value.image = file;
    mainImagePreview.value = URL.createObjectURL(file);
  }
}

function handleGalleryChange(e) {
  const files = Array.from(e.target.files || []);
  form.value.images = files;
  galleryPreviews.value = files.map((f) => URL.createObjectURL(f));
}

function removeGalleryImage(idx) {
  galleryPreviews.value.splice(idx, 1);
  form.value.images.splice(idx, 1);
}

// Submit logic
const loading = ref(false);

async function onSubmit() {
  loading.value = true;

  const fd = new FormData();

  if (!form.value.title?.trim()) {
    alert(t('title_required'));
    loading.value = false;
    return;
  }
  fd.append("title", form.value.title.trim());

  if (!form.value.title_ar?.trim()) {
    alert(t('title_ar_required'));
    loading.value = false;
    return;
  }
  fd.append("title_ar", form.value.title_ar.trim());

  if (!form.value.description_ar?.trim()) {
    alert(t('description_ar_required'));
    loading.value = false;
    return;
  }
  fd.append("slug", form.value.slug.trim());

  if (!form.value.category_id) {
    alert(t('category_required'));
    loading.value = false;
    return;
  }
  fd.append("category_id", form.value.category_id);
  fd.append("unit", form.value.unit ?? "kg");

  if (form.value.price == null || form.value.price === "") {
    alert(t('price_required'));
    loading.value = false;
    return;
  }
  fd.append("price", form.value.price);

  fd.append("description", form.value.description?.trim() || "");
  fd.append("sale_price", form.value.sale_price ?? "");
  fd.append("stock", form.value.stock ?? 0);
  fd.append("new_arrival", form.value.new_arrival ? "1" : "0");

  if (form.value.image instanceof File) {
    fd.append("image", form.value.image);
  }

  if (form.value.images?.length > 0) {
    form.value.images.forEach((file, i) => {
      if (file instanceof File) {
        fd.append(`images[${i}]`, file);
      }
    });
  }

  if (form.value.id) {
    fd.append("_method", "PUT");
  }

  try {
    let res;
    if (form.value.id) {
      res = await store.dispatch("updateProduct", {
        id: form.value.id,
        product: form.value,
      });
    } else {
      res = await store.dispatch("createProduct", form.value);
    }

    if ([200, 201].includes(res?.status)) {
      alert(form.value.id ? t('product_updated') : t('product_created'));
      await store.dispatch("getProducts");
      emit("saved");
      closeModal();
    }
  } catch (err) {
    if (err.response?.status === 422) {
      const errors = err.response.data.errors;
      let msg = t('validation_errors') + "\n";
      for (const field in errors) {
        msg += `• ${field}: ${errors[field][0]}\n`;
      }
      alert(msg);
    } else {
      alert(t('server_error'));
      console.error(err);
    }
  } finally {
    loading.value = false;
  }
}

function closeModal() {
  show.value = false;
  emit("close");
}
</script>
