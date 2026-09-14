<!-- components/account/AddressForm.vue -->
<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-800">{{ t('shipping_address') }}</h2>
            <button v-if="hasAddress" @click="editing = !editing"
                    class="text-green-600 hover:text-green-700 font-medium text-sm">
                {{ editing ? t('cancel') : t('edit_address') }}
            </button>
        </div>

        <div v-if="loading" class="flex justify-center py-10">
            <div class="animate-spin rounded-full h-10 w-10 border-4 border-green-500 border-t-transparent"></div>
        </div>

        <div v-else-if="hasAddress && !editing" class="bg-gray-50 rounded-lg p-6">
            <div class="space-y-2 text-gray-700">
                <p class="font-semibold">{{ address?.address_line1 }}</p>
                <p v-if="address?.address_line2">{{ address.address_line2 }}</p>
                <p>{{ address?.city }}, {{ address?.state }} {{ address?.postal_code }}</p>
                <p>{{ address?.country }}</p>
                <p v-if="address?.phone" class="text-sm text-gray-500">
                    {{ t('phone') }}: {{ address.phone }}
                </p>
            </div>
            <button @click="editing = true"
                    class="mt-4 text-green-600 hover:text-green-700 font-medium text-sm">
                {{ t('edit_address') }}
            </button>
        </div>

        <form v-else @submit.prevent="submitForm" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('address_line1') }} *
                    </label>
                    <input v-model="form.address_line1" type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                        :class="{ 'border-red-500': errors.address_line1 }"
                        required />
                    <p v-if="errors.address_line1" class="text-red-600 text-sm mt-1">{{ errors.address_line1[0] }}</p>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('address_line2') }}
                    </label>
                    <input v-model="form.address_line2" type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" />
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('city') }} *
                    </label>
                    <input v-model="form.city" type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                        :class="{ 'border-red-500': errors.city }"
                        required />
                    <p v-if="errors.city" class="text-red-600 text-sm mt-1">{{ errors.city[0] }}</p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('state') }}
                    </label>
                    <input v-model="form.state" type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" />
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('postal_code') }}
                    </label>
                    <input v-model="form.postal_code" type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" />
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('country') }} *
                    </label>
                    <select v-model="form.country"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                        :class="{ 'border-red-500': errors.country }"
                        required>
                        <option value="">{{ t('select_country') }}</option>
                        <option v-for="country in countries" :key="country.code" :value="country.name">
                            {{ country.name }}
                        </option>
                    </select>
                    <p v-if="errors.country" class="text-red-600 text-sm mt-1">{{ errors.country[0] }}</p>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('phone_number') }}
                    </label>
                    <input v-model="form.phone" type="tel"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                        placeholder="+20 123 456 7890" />
                </div>
            </div>

            <div class="flex gap-4 pt-4">
                <button type="submit" :disabled="submitting"
                    class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-3 rounded-lg transition-all disabled:opacity-60 flex items-center gap-2">
                    <span v-if="submitting" class="animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent"></span>
                    {{ hasAddress ? t('update_address') : t('save_address') }}
                </button>
                <button v-if="editing && hasAddress" type="button" @click="cancelEdit"
                    class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold px-6 py-3 rounded-lg transition-all">
                    {{ t('cancel') }}
                </button>
            </div>
        </form>

        <!-- Map or Location Picker (Optional) -->
        <div v-if="showMap" class="mt-6">
            <div class="bg-gray-100 rounded-lg h-64 flex items-center justify-center">
                <p class="text-gray-500">{{ t('map_placeholder') }}</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../../composables/useLanguage.js';

const props = defineProps({
    address: {
        type: Object,
        default: null
    }
});

const emit = defineEmits(['updated']);

const store = useStore();
const toast = useToast();
const { t } = useLanguage();

// State
const form = ref({
    address_line1: '',
    address_line2: '',
    city: '',
    state: '',
    postal_code: '',
    country: '',
    phone: ''
});

const editing = ref(false);
const submitting = ref(false);
const loading = ref(false);
const errors = ref({});
const showMap = ref(false);

// Computed
const hasAddress = computed(() => {
    return props.address && Object.keys(props.address).length > 0;
});

// Countries list
const countries = [
    { code: 'EG', name: 'Egypt' },
    { code: 'SA', name: 'Saudi Arabia' },
    { code: 'AE', name: 'United Arab Emirates' },
    { code: 'US', name: 'United States' },
    { code: 'GB', name: 'United Kingdom' },
    { code: 'CA', name: 'Canada' },
    { code: 'AU', name: 'Australia' },
    { code: 'DE', name: 'Germany' },
    { code: 'FR', name: 'France' },
    { code: 'IT', name: 'Italy' },
    { code: 'ES', name: 'Spain' },
    { code: 'TR', name: 'Turkey' },
    { code: 'KW', name: 'Kuwait' },
    { code: 'QA', name: 'Qatar' },
    { code: 'BH', name: 'Bahrain' },
    { code: 'OM', name: 'Oman' },
    { code: 'JO', name: 'Jordan' },
    { code: 'LB', name: 'Lebanon' },
    { code: 'MA', name: 'Morocco' },
    { code: 'TN', name: 'Tunisia' },
];

// Watch for address changes
watch(() => props.address, (newAddress) => {
    if (newAddress && Object.keys(newAddress).length > 0) {
        form.value = {
            address_line1: newAddress.address_line1 || '',
            address_line2: newAddress.address_line2 || '',
            city: newAddress.city || '',
            state: newAddress.state || '',
            postal_code: newAddress.postal_code || '',
            country: newAddress.country || '',
            phone: newAddress.phone || ''
        };
        editing.value = false;
    } else {
        // Reset form for new address
        form.value = {
            address_line1: '',
            address_line2: '',
            city: '',
            state: '',
            postal_code: '',
            country: '',
            phone: ''
        };
        editing.value = true; // Show form for new address
    }
}, { immediate: true });

// Methods
const cancelEdit = () => {
    editing.value = false;
    // Reset form to original address
    if (props.address) {
        form.value = {
            address_line1: props.address.address_line1 || '',
            address_line2: props.address.address_line2 || '',
            city: props.address.city || '',
            state: props.address.state || '',
            postal_code: props.address.postal_code || '',
            country: props.address.country || '',
            phone: props.address.phone || ''
        };
    }
};

const submitForm = async () => {
    submitting.value = true;
    errors.value = {};

    // Basic validation
    if (!form.value.address_line1) {
        errors.value.address_line1 = [t('address_line1_required')];
        submitting.value = false;
        return;
    }
    if (!form.value.city) {
        errors.value.city = [t('city_required')];
        submitting.value = false;
        return;
    }
    if (!form.value.country) {
        errors.value.country = [t('country_required')];
        submitting.value = false;
        return;
    }

    try {
        const response = await store.dispatch('user/updateAddress', form.value);

        toast.success(hasAddress.value ? t('address_updated_success') : t('address_added_success'));
        editing.value = false;
        emit('updated', response);
    } catch (error) {
        console.error('Error saving address:', error);

        if (error.response?.data?.errors) {
            errors.value = error.response.data.errors;
            toast.error(t('please_fix_errors'));
        } else {
            toast.error(error.response?.data?.message || t('error_saving_address'));
        }
    } finally {
        submitting.value = false;
    }
};

// Load address on mount
onMounted(() => {
    if (props.address && Object.keys(props.address).length > 0) {
        form.value = {
            address_line1: props.address.address_line1 || '',
            address_line2: props.address.address_line2 || '',
            city: props.address.city || '',
            state: props.address.state || '',
            postal_code: props.address.postal_code || '',
            country: props.address.country || '',
            phone: props.address.phone || ''
        };
    }
});
</script>

<style scoped>
/* Optional: Add some styling for the form */
input, select {
    transition: border-color 0.2s ease;
}

input:focus, select:focus {
    outline: none;
}
</style>
