<template>
  <div class="max-w-4xl mx-auto bg-white p-8 rounded-xl shadow-lg mt-10">
    <h1 class="text-2xl font-bold mb-6 text-gray-800">
      {{ isEditMode ? t('edit_service') : t('create_new_service') }}
    </h1>

    <form @submit.prevent="submitForm" class="space-y-6">
      <!-- Title (English) -->
      <div>
        <label for="title" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('title_english') }}
        </label>
        <input
          id="title"
          v-model="form.title"
          type="text"
          required
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="e.g. Web Development, Digital Marketing..."
        />
        <p v-if="errors.title" class="mt-1 text-sm text-red-600">{{ errors.title[0] }}</p>
      </div>

      <!-- Title (Arabic) -->
      <div>
        <label for="title_ar" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('title_arabic') }}
        </label>
        <input
          id="title_ar"
          v-model="form.title_ar"
          type="text"
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="e.g. تطوير الويب, التسويق الرقمي..."
          dir="rtl"
        />
        <p v-if="errors.title_ar" class="mt-1 text-sm text-red-600">{{ errors.title_ar[0] }}</p>
      </div>

      <!-- Description (English) -->
      <div>
        <label for="description" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('description_english') }}
        </label>
        <textarea
          id="description"
          v-model="form.description"
          rows="4"
          required
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="Describe the service in detail..."
        ></textarea>
        <p v-if="errors.description" class="mt-1 text-sm text-red-600">{{ errors.description[0] }}</p>
      </div>

      <!-- Description (Arabic) -->
      <div>
        <label for="description_ar" class="block text-sm font-medium text-gray-700 mb-1">
          {{ t('description_arabic') }}
        </label>
        <textarea
          id="description_ar"
          v-model="form.description_ar"
          rows="4"
          class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2.5 px-4"
          placeholder="وصف الخدمة بالتفصيل..."
          dir="rtl"
        ></textarea>
        <p v-if="errors.description_ar" class="mt-1 text-sm text-red-600">{{ errors.description_ar[0] }}</p>
      </div>

      <!-- Image -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          {{ t('service_image') }}
        </label>

        <!-- Current / Preview Image -->
        <div v-if="imagePreview" class="mb-4">
          <img
            :src="imagePreview"
            alt="Service preview"
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
            <span>{{ newImageSelected ? t('change_image') : t('select_image') }}</span>
            <input
              type="file"
              accept="image/*"
              class="hidden"
              @change="handleImageChange"
            />
          </label>

          <span v-if="hasNewFile" class="text-sm text-gray-600">
            {{ form.image.name }} {{ t('selected') }}
          </span>
        </div>

        <p v-if="errors.image" class="mt-1 text-sm text-red-600">{{ errors.image[0] }}</p>
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
          {{ isEditMode ? t('update_service') : t('create_service') }}
        </button>

        <router-link
          to="/services"
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
import { useStore } from 'vuex'
import { useLanguage } from '../../composables/useLanguage';

const {
  currentLanguage,
  t,

} = useLanguage()
const route = useRoute()
const router = useRouter()
const store = useStore()

const isEditMode = computed(() => !!route.params.id)
const serviceId = computed(() => route.params.id)

const loading = ref(false)
const errors = ref({})

const form = ref({
  id: null,
  title: '',
  title_ar: '',
  description: '',
  description_ar: '',
  image: null
})

const imagePreview = ref(null)
const newImageSelected = ref(false)

const hasNewFile = computed(() => form.value.image instanceof File)

onMounted(async () => {
  if (isEditMode.value) {
    await fetchService()
  }
})

async function fetchService() {
  try {
    loading.value = true
    const res = await store.dispatch('services/getService', serviceId.value)

    const service = res.data?.data || res.data || res

    // Fill form
    form.value.id = service.id
    form.value.title = service.title
    form.value.title_ar = service.title_ar || ''
    form.value.description = service.description
    form.value.description_ar = service.description_ar || ''

    imagePreview.value = service.image
      ? `${import.meta.env.VITE_STORAGE_URL || 'http://localhost:8000/storage'}/${service.image}`
      : null

  } catch (err) {
    console.error(err)
    alert(t('Failed to load service'))
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
    let response

    if (form.value.id) {
      // UPDATE
      response = await store.dispatch('services/updateService', {
        id: form.value.id,
        serviceData: {
          title: form.value.title,
          title_ar: form.value.title_ar,
          description: form.value.description,
          description_ar: form.value.description_ar,
          image: form.value.image
        }
      })
    } else {
      // CREATE
      response = await store.dispatch('services/createService', {
        title: form.value.title,
        title_ar: form.value.title_ar,
        description: form.value.description,
        description_ar: form.value.description_ar,
        image: form.value.image
      })
    }

    if ([200, 201].includes(response?.status || response)) {
      alert(form.value.id ? t('service_updated_successfully') : t('service_created_successfully'))
      await store.dispatch('getServices')
      router.push('/app/services')

    }

  } catch (err) {
    if (err.response?.status === 422) {
      errors.value = err.response.data.errors || {}
      const errorMessages = Object.values(errors.value).flat().join('\n')
      alert(errorMessages)
    } else {
      console.error('Error:', err)
      alert(err.response?.data?.message || t('Server error – please try again'))
    }
  } finally {
    loading.value = false
  }
}
</script>
