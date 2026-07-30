<template>
  <div class="max-w-2xl mx-auto bg-white p-8 rounded-xl shadow-lg mt-10">
    <h1 class="text-2xl font-bold mb-6 text-gray-800">
      {{ isEditMode ? t('edit_category') : t('create_new_category') }}
    </h1>

    <form @submit.prevent="submitForm" class="space-y-6">
      <!-- Name -->
      <div>
        <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('name_english') }}
        </label>
        <input
          id="name"
          v-model="form.name"
          type="text"
          required
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="e.g. Tomatoes, Flowers..."
        />
        <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name }}</p>
      </div>
      <div>
        <label for="name_ar" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('name_arabic') }}
        </label>
        <input
          id="name_ar"
          v-model="form.name_ar"
          type="text"
          required
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="e.g. طماطم, زهور..."
        />
        <p v-if="errors.name_ar" class="mt-1 text-sm text-red-600">{{ errors.name_ar }}</p>
      </div>


      <!-- Image -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
         {{ t('category_image') }}
        </label>

        <!-- Current / Preview Image -->
        <div v-if="imagePreview" class="mb-4">
          <img
            :src="imagePreview"
            alt="Category preview"
            class="h-48 w-48 object-cover rounded-lg border border-gray-200 shadow-sm"
          />
          <p v-if="isEditMode && !newImageSelected" class="mt-1 text-xs text-gray-500">
                {{ t('replace_image') }}
          </p>
        </div>

        <!-- File Input -->
        <div class="flex items-center gap-4">
          <label
            class="cursor-pointer bg-indigo-50 hover:bg-indigo-100 text-indigo-700 px-5 py-2.5 rounded-md border border-indigo-200 transition"
          >
            <span>{{ newImageSelected ? t('Change Image') : t('Select Image') }}</span>
            <input
              type="file"
              accept="image/*"
              class="hidden"
              @change="handleImageChange"
            />
          </label>

          <span v-if="hasNewFile" class="text-sm text-gray-600">
            {{ form.image.name }} selected
          </span>
        </div>

        <p v-if="errors.image" class="mt-1 text-sm text-red-600">{{ errors.image }}</p>
      </div>

      <!-- Submit / Cancel -->
      <div class="flex items-center gap-4 pt-6">
        <button
          type="submit"
          :disabled="loading"
          class="inline-flex items-center px-6 py-3 bg-indigo-600 text-white font-medium rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-60 transition"
        >
          <span v-if="loading" class="mr-2">
            <svg class="animate-spin h-5 w-5" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8h8a8 8 0 01-16 0z"/>
            </svg>
          </span>
          {{ isEditMode ? t('Update Category') : t('Create Category') }}
        </button>

        <router-link
          to="/categories"
          class="px-6 py-3 bg-gray-100 text-gray-700 font-medium rounded-md hover:bg-gray-200 transition"
        >
          {{ t('Cancel') }}
        </router-link>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import store from "../../store/index.js"
import { useLanguage } from '../../composables/useLanguage';

const {
  currentLanguage,
  t,

} = useLanguage()

const route = useRoute()
const router = useRouter()

const isEditMode = computed(() => !!route.params.id)
const categoryId = computed(() => route.params.id)

const loading = ref(false)
const errors = ref({})

const form = ref({
  id: null,           
  name: '',
  name_ar: '',
  image: null         // File object or null
})

const imagePreview = ref(null)
const newImageSelected = ref(false)

const hasNewFile = computed(() => form.value.image instanceof File)

onMounted(async () => {
  if (isEditMode.value) {
    await fetchCategory()
  }
})

async function fetchCategory() {
  try {
    loading.value = true
    const res = await store.dispatch('getCategory', categoryId.value)
    // or if you don't have getCategory → use axios directly here

    const cat = res.data?.data || res.data || res

    // Fill form completely
    form.value.id    = cat.id
    form.value.name  = cat.name
    form.value.name_ar  = cat.name_ar
    imagePreview.value = cat.image
      ? `${import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/storage'}/${cat.image}`
      : null

  } catch (err) {
    console.error(err)
    alert(t('Failed to load category'))
  } finally {
    loading.value = false
  }
}

function handleImageChange(e) {
  const file = e.target.files?.[0]
  if (!file) return

  if (!file.type.startsWith('image/')) {
    alert(t('Please select an image file'))
    return
  }

  form.value.image = file
  newImageSelected.value = true

  const reader = new FileReader()
  reader.onload = (ev) => {
    imagePreview.value = ev.target.result
  }
  reader.readAsDataURL(file)
}

async function submitForm() {
  errors.value = {}
  loading.value = true

  try {
    let actionName
    let payload

    if (form.value.id) {
      // UPDATE
      actionName = 'updateCategory'
      payload = {
        id: form.value.id,
        category: {
          name: form.value.name,
          name_ar: form.value.name_ar,
          image: form.value.image,          // File or null
        }
      }
    } else {
      // CREATE
      actionName = 'createCategory'
      payload = {
        name: form.value.name,
        name_ar: form.value.name_ar,
        image: form.value.image           // File or null
      }
    }

    const res = await store.dispatch(actionName, payload)

    if ([200, 201].includes(res?.status || res)) {
      alert(form.value.id ? t('category_updated_successfully') : t('category_created_successfully'))
      await store.dispatch('getCategories')     // refresh list
      router.push('/app/categories')
    }

  } catch (err) {
    if (err.response?.status === 422) {
      errors.value = err.response.data.errors || {}
      alert(t('Please_fix_the_errors_in_the_form'))
    } else {
      console.error(err)
      alert(t('Server error – check console'))
    }
  } finally {
    loading.value = false
  }
}
</script>

