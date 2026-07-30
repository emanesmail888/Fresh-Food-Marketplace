<!-- components/account/ProfileForm.vue -->
<template>
    <div>
        <h2 class="text-xl font-bold text-gray-800 mb-6">{{ t('profile_info') }}</h2>

        <form @submit.prevent="submitForm" class="space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('name') }} *
                </label>
                <input v-model="form.name" type="text"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    required />
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('email') }} *
                </label>
                <input v-model="form.email" type="email"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    required />
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('phone') }}
                </label>
                <input v-model="form.phone" type="tel"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" />
            </div>

            <div class="flex gap-4 pt-4">
                <button type="submit" :disabled="loading"
                    class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-3 rounded-lg transition-all disabled:opacity-60 flex items-center gap-2">
                    <span v-if="loading" class="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></span>
                    {{ t('update_profile') }}
                </button>
                <button type="button" @click="resetForm" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold px-6 py-3 rounded-lg transition-all">
                    {{ t('reset') }}
                </button>
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../../composables/useLanguage.js';

const props = defineProps({
    user: {
        type: Object,
        default: null
    }
});

const emit = defineEmits(['updated']);

const store = useStore();
const toast = useToast();
const { t } = useLanguage();

const form = ref({
    name: '',
    email: '',
    phone: ''
});
const loading = ref(false);

watch(() => props.user, (user) => {
    if (user) {
        form.value.name = user.name || '';
        form.value.email = user.email || '';
        form.value.phone = user.phone || '';
    }
}, { immediate: true });

const resetForm = () => {
    if (props.user) {
        form.value.name = props.user.name || '';
        form.value.email = props.user.email || '';
        form.value.phone = props.user.phone || '';
    }
};

const submitForm = async () => {
    loading.value = true;
    try {
        await store.dispatch('user/updateProfile', form.value);
        toast.success(t('profile_updated_success'));
        emit('updated');
    } catch (error) {
        console.error('Error updating profile:', error);
        toast.error(error.response?.data?.message || t('error_updating_profile'));
    } finally {
        loading.value = false;
    }
};
</script>
