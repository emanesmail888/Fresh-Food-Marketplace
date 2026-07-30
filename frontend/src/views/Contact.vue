<template>
  <home-layout>
    <div class="min-h-screen bg-gray-50">
      <!-- Hero Section -->
      <section class="relative bg-linear-to-r from-green-700 to-green-800 py-20 md:py-28 overflow-hidden">
        <!-- Background Pattern -->
        <div class="absolute inset-0 opacity-10">
          <div class="absolute top-0 left-0 w-64 h-64 bg-white rounded-full -translate-x-1/2 -translate-y-1/2"></div>
          <div class="absolute bottom-0 right-0 w-96 h-96 bg-white rounded-full translate-x-1/2 translate-y-1/2"></div>
        </div>

        <div class="relative container mx-auto px-4 text-center text-white">
          <h1
            data-aos="fade-up"
            data-aos-duration="1000"
            class="text-4xl md:text-5xl lg:text-6xl font-bold mb-4"
          >
            <span class="border-b-4 border-yellow-400 pb-2">{{ t('contact_us') }}</span>
          </h1>
          <p
            data-aos="fade-up"
            data-aos-duration="1000"
            data-aos-delay="200"
            class="text-lg md:text-xl text-green-100 max-w-3xl mx-auto mt-6"
          >
            {{ t('contact_hero_description') }}
          </p>
        </div>
      </section>

      <!-- Contact Section -->
      <section class="container mx-auto px-4 mt-10 relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
          <!-- Contact Info Card -->
          <div
            data-aos="fade-right"
            data-aos-duration="1000"
            class="lg:col-span-5 bg-linear-to-br from-green-700 to-green-800 rounded-2xl p-6 md:p-8 text-white shadow-xl"
          >
            <div class="mb-6">
              <h3 class="text-2xl md:text-3xl font-bold mb-3">{{ t('get_in_touch') }}</h3>
              <p class="text-green-100">
                {{ t('get_in_touch_description') }}
              </p>
            </div>

            <!-- Contact Details -->
            <div class="space-y-4">
              <!-- Phone -->
              <a
                href="tel:+20100547555"
                class="flex items-start gap-4 p-3 rounded-lg hover:bg-white/10 transition-colors group"
                :class="{ 'flex-row-reverse': currentLanguage === 'ar' }"
              >
                <div class="shrink-0 w-12 h-12 bg-white/10 rounded-full flex items-center justify-center group-hover:bg-white/20 transition-colors">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                </div>
                <div >
                  <h5 class="font-semibold text-sm">{{ t('call_us') }}</h5>
                  <p class="text-green-100 text-sm">+20 100547555</p>
                </div>
              </a>

              <!-- Email -->
              <a
                href="mailto:info@shop_plants.com"
                class="flex items-start gap-4 p-3 rounded-lg hover:bg-white/10 transition-colors group"
                :class="{ 'flex-row-reverse': currentLanguage === 'ar' }"
              >
                <div class="shrink-0 w-12 h-12 bg-white/10 rounded-full flex items-center justify-center group-hover:bg-white/20 transition-colors">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                </div>
                <div >
                  <h5 class="font-semibold text-sm">{{ t('email_address') }}</h5>
                  <p class="text-green-100 text-sm">info@shop_plants.com</p>
                </div>
              </a>

              <!-- Working Hours -->
              <div class="flex items-start gap-4 p-3 rounded-lg" :class="{ 'flex-row-reverse': currentLanguage === 'ar' }">
                <div class="shrink-0 w-12 h-12 bg-white/10 rounded-full flex items-center justify-center">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6l4 2" />
                  </svg>
                </div>
                <div >
                  <h5 class="font-semibold text-sm">{{ t('working_hours') }}</h5>
                  <p class="text-green-100 text-sm">{{ t('working_hours_time') }}</p>
                </div>
              </div>

              <!-- Location -->
              <a
                href="https://maps.app.goo.gl/WBLB5w2nFc1kxicU9"
                target="_blank"
                class="flex items-start gap-4 p-3 rounded-lg hover:bg-white/10 transition-colors group"
                :class="{ 'flex-row-reverse': currentLanguage === 'ar' }"
              >
                <div class="shrink-0 w-12 h-12 bg-white/10 rounded-full flex items-center justify-center group-hover:bg-white/20 transition-colors">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </div>
                <div >
                  <h5 class="font-semibold text-sm">{{ t('location') }}</h5>
                  <p class="text-green-100 text-sm">{{ t('cairo_egypt') }}</p>
                </div>
              </a>
            </div>

            <!-- Social Links -->
            <div class="mt-8 pt-6 border-t border-white/20">
              <p class="text-sm text-green-100 mb-3">{{ t('follow_us') }}</p>
              <div class="flex gap-3" >
                <a href="#" class="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-white/20 transition-colors">
                  <i class="fab fa-facebook-f"></i>
                </a>
                <a href="#" class="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-white/20 transition-colors">
                  <i class="fab fa-x-twitter"></i>
                </a>
                <a href="#" class="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-white/20 transition-colors">
                  <i class="fab fa-instagram"></i>
                </a>
                <a href="#" class="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-white/20 transition-colors">
                  <i class="fab fa-linkedin-in"></i>
                </a>
              </div>
            </div>
          </div>

          <!-- Contact Form -->
          <div
            data-aos="fade-left"
            data-aos-duration="1000"
            class="lg:col-span-7 bg-white rounded-2xl p-6 md:p-8 shadow-lg"
          >
            <div class="mb-6">
              <h3 class="text-2xl md:text-3xl font-bold text-gray-800 mb-3">
                {{ t('contact_form_title') }}
              </h3>
              <p class="text-gray-600">
                {{ t('contact_form_description') }}
              </p>
            </div>

            <form @submit.prevent="handleSubmit" class="space-y-4">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label for="name" class="block text-sm font-semibold text-gray-700 mb-2">
                    {{ t('full_name') }} <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="name"
                    v-model="form.name"
                    type="text"
                    :placeholder="t('enter_full_name')"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                    :class="{ 'border-red-500': errors.name }"
                    :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
                    required
                  />
                  <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
                </div>

                <div>
                  <label for="email" class="block text-sm font-semibold text-gray-700 mb-2">
                    {{ t('email_address') }} <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="email"
                    v-model="form.email"
                    type="email"
                    :placeholder="t('enter_email')"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                    :class="{ 'border-red-500': errors.email }"
                    :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
                    required
                  />
                  <p v-if="errors.email" class="text-red-500 text-sm mt-1">{{ errors.email }}</p>
                </div>
              </div>

              <div>
                <label for="phone" class="block text-sm font-semibold text-gray-700 mb-2">
                  {{ t('phone_number') }}
                </label>
                <input
                  id="phone"
                  v-model="form.phone"
                  type="tel"
                  :placeholder="t('enter_phone')"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                  :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
                />
              </div>

              <div>
                <label for="subject" class="block text-sm font-semibold text-gray-700 mb-2">
                  {{ t('subject') }}
                </label>
                <input
                  id="subject"
                  v-model="form.subject"
                  type="text"
                  :placeholder="t('enter_subject')"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                  :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
                />
              </div>

              <div>
                <label for="message" class="block text-sm font-semibold text-gray-700 mb-2">
                  {{ t('message') }} <span class="text-red-500">*</span>
                </label>
                <textarea
                  id="message"
                  v-model="form.message"
                  rows="5"
                  :placeholder="t('enter_message')"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition resize-none"
                  :class="{ 'border-red-500': errors.message }"
                  :dir="currentLanguage === 'ar' ? 'rtl' : 'ltr'"
                  required
                ></textarea>
                <p v-if="errors.message" class="text-red-500 text-sm mt-1">{{ errors.message }}</p>
              </div>

              <button
                type="submit"
                :disabled="isSubmitting"
                class="w-full md:w-auto px-8 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 focus:ring-4 focus:ring-green-300 transition-all disabled:opacity-70 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                :class="{ 'flex-row-reverse': currentLanguage === 'ar' }"
              >
                <span v-if="!isSubmitting">{{ t('send_message') }}</span>
                <span v-else class="flex items-center gap-2" :class="{ 'flex-row-reverse': currentLanguage === 'ar' }">
                  <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  {{ t('sending') }}
                </span>
              </button>
            </form>
          </div>
        </div>
      </section>

      <!-- Map Section -->
      <section
        data-aos="fade-up"
        data-aos-duration="1000"
        class="container mx-auto px-4 mt-12 mb-16"
      >
        <div class="rounded-2xl overflow-hidden shadow-lg h-64 md:h-96">
            <iframe src="https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d54670.368305785945!2d31.282652950000003!3d31.0847636!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sar!2seg!4v1781847765849!5m2!1sar!2seg" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>

        </div>
      </section>

      <!-- Toast Notification -->
      <div
        v-if="toast.show"
        :class="[
          'fixed bottom-4 right-4 z-50 px-6 py-4 rounded-lg shadow-lg flex items-center gap-3 transition-all duration-500',
          toast.type === 'success' ? 'bg-green-500' : 'bg-red-500'
        ]"
        :style="{ [currentLanguage === 'ar' ? 'left' : 'right']: '1rem', [currentLanguage === 'ar' ? 'right' : 'left']: 'auto' }"
        data-aos="fade-up"
        data-aos-duration="500"
      >
        <svg v-if="toast.type === 'success'" class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
        <svg v-else class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
        <p class="text-white font-medium">{{ toast.message }}</p>
        <button @click="toast.show = false" class="text-white hover:text-gray-200 transition">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  </home-layout>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import AOS from 'aos'
import 'aos/dist/aos.css'
import HomeLayout from "../components/HomeLayout.vue";
import { useLanguage } from '../composables/useLanguage.js';
import { useStore } from 'vuex';

const { t, currentLanguage } = useLanguage();
const store = useStore();

// Form data
const form = reactive({
  name: '',
  email: '',
  phone: '',
  subject: '',
  message: ''
})

// Form errors
const errors = reactive({
  name: '',
  email: '',
  message: ''
})

// State
const isSubmitting = ref(false)

// Toast notification
const toast = reactive({
  show: false,
  type: 'success',
  message: ''
})

// Validate form
const validateForm = () => {
  let isValid = true

  // Clear previous errors
  errors.name = ''
  errors.email = ''
  errors.message = ''

  // Validate name
  if (!form.name.trim()) {
    errors.name = t('name_required')
    isValid = false
  } else if (form.name.trim().length < 2) {
    errors.name = t('name_min_length')
    isValid = false
  }

  // Validate email
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!form.email.trim()) {
    errors.email = t('email_required')
    isValid = false
  } else if (!emailRegex.test(form.email)) {
    errors.email = t('email_valid')
    isValid = false
  }

  // Validate message
  if (!form.message.trim()) {
    errors.message = t('message_required')
    isValid = false
  } else if (form.message.trim().length < 10) {
    errors.message = t('message_min_length')
    isValid = false
  }

  return isValid
}

// Show toast notification
const showToast = (type, message) => {
  toast.type = type
  toast.message = message
  toast.show = true

  // Auto hide after 5 seconds
  setTimeout(() => {
    toast.show = false
  }, 5000)
}

// Submit handler
// const handleSubmit = async () => {
//   if (!validateForm()) {
//     showToast('error', t('form_errors'))
//     return
//   }

//   isSubmitting.value = true

//   try {
//     // Replace with your API endpoint
//     // await axios.post('/api/contact', form)

//     // Simulate API call
//     await new Promise(resolve => setTimeout(resolve, 2000))

//     console.log('Form submitted:', form)

//     // Show success message
//     showToast('success', t('message_sent'))

//     // Reset form
//     Object.assign(form, {
//       name: '',
//       email: '',
//       phone: '',
//       subject: '',
//       message: ''
//     })

//   } catch (error) {
//     console.error('Error submitting form:', error)
//     showToast('error', t('message_failed'))
//   } finally {
//     isSubmitting.value = false
//   }
// }

const handleSubmit = async () => {
  if (!validateForm()) {
    showToast('error', t('form_errors'))
    return
  }

  isSubmitting.value = true

  try {
    const response = await store.dispatch('contact/submitContact', form)

    if (response.success) {
      showToast('success', t('message_sent'))
      // Reset form
      Object.assign(form, {
        name: '',
        email: '',
        phone: '',
        subject: '',
        message: ''
      })
    } else {
      showToast('error', response.message || t('message_failed'))
    }
  } catch (error) {
    console.error('Error submitting form:', error)

    // Handle validation errors
    if (error.response?.status === 422 && error.response?.data?.errors) {
      const validationErrors = error.response.data.errors
      // Map validation errors to form fields
      if (validationErrors.name) errors.name = validationErrors.name[0]
      if (validationErrors.email) errors.email = validationErrors.email[0]
      if (validationErrors.message) errors.message = validationErrors.message[0]
      showToast('error', t('form_errors'))
    } else {
      showToast('error', t('message_failed'))
    }
  } finally {
    isSubmitting.value = false
  }
}

// Initialize AOS
onMounted(() => {
  AOS.init({
    once: true,
    duration: 1000,
    easing: 'ease-out-cubic',
    offset: 50
  })
})
</script>

<style scoped>
/* Custom animations */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* Smooth transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

/* Focus styles */
input:focus, textarea:focus {
  outline: none;
}

/* Custom scrollbar for textarea */
textarea::-webkit-scrollbar {
  width: 6px;
}

textarea::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

textarea::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 3px;
}

textarea::-webkit-scrollbar-thumb:hover {
  background: #555;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}

/* RTL Support */
[dir="rtl"] .space-x-4 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-x-reverse: 1;
}

[dir="rtl"] .flex-row-reverse {
  flex-direction: row;
}

[dir="rtl"] .text-left {
  text-align: right;
}

[dir="rtl"] .text-right {
  text-align: left;
}
</style>
