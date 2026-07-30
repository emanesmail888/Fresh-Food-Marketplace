<!-- components/account/ChangePassword.vue -->
<template>
    <div>
        <h2 class="text-xl font-bold text-gray-800 mb-6">{{ t('change_password') }}</h2>

        <form @submit.prevent="submitForm" class="space-y-4 max-w-md">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('current_password') }} *
                </label>
                <input v-model="form.current_password" type="password"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    required />
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('new_password') }} *
                </label>
                <input v-model="form.new_password" type="password"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    required minlength="8" />
                <p class="text-xs text-gray-400 mt-1">{{ t('password_requirements') }}</p>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('confirm_password') }} *
                </label>
                <input v-model="form.new_password_confirmation" type="password"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    required />
            </div>

            <div v-if="error" class="text-red-600 text-sm">{{ error }}</div>

            <button type="submit" :disabled="loading"
                class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-3 rounded-lg transition-all disabled:opacity-60 flex items-center gap-2">
                <span v-if="loading" class="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></span>
                {{ t('update_password') }}
            </button>
        </form>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../../composables/useLanguage.js';

const emit = defineEmits(['updated']);

const store = useStore();
const toast = useToast();
const { t } = useLanguage();

const form = ref({
    current_password: '',
    new_password: '',
    new_password_confirmation: ''
});
const loading = ref(false);
const error = ref('');

const submitForm = async () => {
    error.value = '';

    // Validate
    if (form.value.new_password !== form.value.new_password_confirmation) {
        error.value = t('passwords_dont_match');
        return;
    }

    if (form.value.new_password.length < 8) {
        error.value = t('password_too_short');
        return;
    }

    loading.value = true;
    try {
        await store.dispatch('user/changePassword', {
            current_password: form.value.current_password,
            new_password: form.value.new_password,
            new_password_confirmation: form.value.new_password_confirmation
        });

        form.value = {
            current_password: '',
            new_password: '',
            new_password_confirmation: ''
        };

        emit('updated');
    } catch (error) {
        console.error('Error changing password:', error);
        error.value = error.response?.data?.message || t('error_changing_password');
    } finally {
        loading.value = false;
    }
};
</script>
