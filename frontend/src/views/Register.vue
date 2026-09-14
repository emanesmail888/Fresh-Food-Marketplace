<template>
    <GuestLayout :title="t('title')">
        <form class="space-y-6" method="POST" @submit.prevent="register">
            <!-- Error Message -->
            <div v-if="errorMsg" class="flex items-center justify-between py-3 px-5 bg-red-500 text-white rounded">
                {{ errorMsg }}
                <span @click="errorMsg = ''"
                    class="w-8 h-8 flex items-center justify-center rounded-full transition-colors cursor-pointer hover:bg-[rgba(0,0,0,0.2)]">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </span>
            </div>

            <!-- Success Message -->
            <div v-if="successMsg" class="flex items-center justify-between py-3 px-5 bg-green-500 text-white rounded">
                {{ successMsg }}
                <span @click="successMsg = ''"
                    class="w-8 h-8 flex items-center justify-center rounded-full transition-colors cursor-pointer hover:bg-[rgba(0,0,0,0.2)]">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </span>
            </div>

            <!-- Name Field -->
            <div>
                <label for="name" class="block text-sm/6 font-medium text-gray-900">
                    {{ t('name') }}
                </label>
                <div class="mt-2">
                    <input
                        type="text"
                        name="name"
                        id="name"
                        :autocomplete="t('autocomplete.name')"
                        required=""
                        v-model="user.name"
                        :placeholder="t('placeholders.name')"
                        class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-green-600 sm:text-sm/6"
                        :class="{ 'border-red-500': errors.name }"
                    />
                </div>
                <div v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name[0] }}</div>
            </div>

            <!-- Email Field -->
            <div>
                <label for="email" class="block text-sm/6 font-medium text-gray-900">
                    {{ t('email') }}
                </label>
                <div class="mt-2">
                    <input
                        type="email"
                        name="email"
                        id="email"
                        :autocomplete="t('autocomplete.email')"
                        required=""
                        v-model="user.email"
                        :placeholder="t('placeholders.email')"
                        class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-green-600 sm:text-sm/6"
                        :class="{ 'border-red-500': errors.email }"
                    />
                </div>
                <div v-if="errors.email" class="mt-1 text-sm text-red-600">{{ errors.email[0] }}</div>
            </div>

            <!-- Password Field -->
            <div>
                <div class="flex items-center justify-between">
                    <label for="password" class="block text-sm/6 font-medium text-gray-900">
                        {{ t('password') }}
                    </label>
                    <div class="text-sm">
                        <span class="text-gray-500">{{ t('password_hint') }}</span>
                    </div>
                </div>
                <div class="mt-2">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        name="password"
                        id="password"
                        :autocomplete="t('autocomplete.password')"
                        required=""
                        v-model="user.password"
                        :placeholder="t('placeholders.password')"
                        class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-green-600 sm:text-sm/6"
                        :class="{ 'border-red-500': errors.password }"
                    />
                </div>
                <div v-if="errors.password" class="mt-1 text-sm text-red-600">{{ errors.password[0] }}</div>

                <!-- Show/Hide Password Toggle -->
                <button
                    type="button"
                    @click="showPassword = !showPassword"
                    class="mt-1 text-sm text-green-600 hover:text-green-500"
                >
                    {{ showPassword ? t('hide_password') : t('show_password') }}
                </button>
            </div>

            <!-- Password Confirmation Field -->
            <div>
                <label for="password_confirmation" class="block text-sm/6 font-medium text-gray-900">
                    {{ t('confirm_password') }}
                </label>
                <div class="mt-2">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        name="password_confirmation"
                        id="password_confirmation"
                        required=""
                        v-model="user.password_confirmation"
                        :placeholder="t('placeholders.confirm_password')"
                        class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-green-600 sm:text-sm/6"
                        :class="{ 'border-red-500': errors.password_confirmation }"
                    />
                </div>
                <div v-if="errors.password_confirmation" class="mt-1 text-sm text-red-600">{{ errors.password_confirmation[0] }}</div>
            </div>

            <!-- Terms Checkbox -->
            <div class="flex items-start">
                <div class="flex items-center h-5">
                    <input
                        id="terms"
                        name="terms"
                        type="checkbox"
                        v-model="user.terms"
                        class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded"
                        required
                    />
                </div>
                <div class="ml-2 text-sm">
                    <label for="terms" class="text-gray-900">
                        {{ t('terms_text') }}
                        <a href="#" class="text-green-600 hover:text-green-500">{{ t('terms_link') }}</a>
                        {{ t('and') }}
                        <a href="#" class="text-green-600 hover:text-green-500">{{ t('privacy_link') }}</a>
                    </label>
                </div>
            </div>
            <div v-if="errors.terms" class="mt-1 text-sm text-red-600">{{ errors.terms[0] }}</div>

            <!-- Submit Button -->
            <div>
                <button
                    type="submit"
                    :disabled="loading"
                    :class="{
                        'cursor-not-allowed opacity-75': loading,
                    }"
                    class="flex w-full justify-center rounded-md bg-green-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-green-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600"
                >
                    <span v-if="!loading">{{ t('submit') }}</span>
                    <span v-else>{{ t('submitting') }}</span>
                    <svg v-if="loading" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                        xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
                        </circle>
                        <path class="opacity-75" fill="currentColor"
                            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                        </path>
                    </svg>
                </button>
            </div>

            <!-- Login Link -->
            <div class="text-sm text-center">
                <span class="text-gray-600">{{ t('already_have_account') }}</span>
                <router-link :to="{ name: 'login' }" class="font-semibold text-green-600 hover:text-green-500 ml-1">
                    {{ t('sign_in') }}
                </router-link>
            </div>
        </form>
    </GuestLayout>
</template>

<script setup>
import GuestLayout from '../components/GuestLayout.vue';
import { ref, reactive } from 'vue';
import store from "../store";
import router from "../router";
import { useLanguage } from '../composables/useLanguage';

const {
  currentLanguage,
  t,
} = useLanguage();

let loading = ref(false);
let errorMsg = ref("");
let successMsg = ref("");
let errors = ref({});
let showPassword = ref(false);

const user = reactive({
    name: '',
    email: '',
    password: '',
    password_confirmation: '',
    terms: false
});

function register() {
    loading.value = true;
    errorMsg.value = "";
    successMsg.value = "";
    errors.value = {};

    store.dispatch('register', user)
        .then(() => {
            loading.value = false;
            successMsg.value = t('success_message');

            setTimeout(() => {
                router.push({ name: 'my-account' });
            }, 2000);
        })
        .catch(({ response }) => {
            loading.value = false;

            if (response?.status === 422) {
                errors.value = response.data.errors || {};
                errorMsg.value = response.data.message || t('errors.validation');
            } else if (response?.status === 409) {
                errorMsg.value = response.data.message || t('errors.email_exists');
            } else {
                errorMsg.value = response?.data?.message || t('errors.general');
            }
        });
}
</script>

<style scoped>
/* Add any component-specific styles here */
</style>
