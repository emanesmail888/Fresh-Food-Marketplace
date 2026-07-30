<!-- Navbar.vue -->
<template>
    <header class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-30">
        <div class="flex items-center justify-between h-16 px-4 sm:px-6 lg:px-8">
            <!-- Left side (changes based on RTL) -->
            <div class="flex items-center gap-4" :class="{ 'flex-row-reverse': isRTL }">
                <button @click="emitToggle"
                    class="lg:hidden text-gray-700 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-green-500 rounded p-1"
                    aria-label="Toggle sidebar">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>

                <div class="text-xl font-bold text-gray-800">
                    {{ isRTL ? 'لوحة التحكم' : 'Dashboard' }}
                </div>
            </div>

            <!-- Right side -->
            <div class="flex items-center gap-5" :class="{ 'flex-row-reverse': isRTL }">
                <!-- Language Switcher Dropdown -->
                <div class="relative" ref="languageDropdownRef">
                    <button @click="toggleDropdown"
                        class="flex items-center gap-2 px-3 py-2 rounded-md hover:bg-gray-100 transition-colors"
                        :class="{ 'flex-row-reverse': isRTL }">
                        <span class="text-xl">{{ currentLanguageFlag }}</span>
                        <span class="hidden sm:inline text-sm font-medium">{{ currentLanguageName }}</span>
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    </button>

                    <!-- Dropdown Menu -->
                    <div v-if="isDropdownOpen"
                        class="absolute mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50 border border-gray-200"
                        :class="isRTL ? 'left-0' : 'right-0'">
                        <button @click="handleLanguageChange('en')"
                            class="w-full text-left px-4 py-2 text-sm hover:bg-gray-100 flex items-center gap-3"
                            :class="{ 'flex-row-reverse justify-end': isRTL }">
                            <span class="text-xl">🇬🇧</span>
                            <span>English</span>
                            <span v-if="currentLanguage === 'en'" class="ml-auto text-green-600">✓</span>
                        </button>
                        <button @click="handleLanguageChange('ar')"
                            class="w-full text-left px-4 py-2 text-sm hover:bg-gray-100 flex items-center gap-3"
                            :class="{ 'flex-row-reverse justify-end': isRTL }">
                            <span class="text-xl">🇸🇦</span>
                            <span>العربية</span>
                            <span v-if="currentLanguage === 'ar'" class="ml-auto text-green-600">✓</span>
                        </button>
                    </div>
                </div>

                <!-- Notification Bell -->
                <button class="text-gray-600 hover:text-gray-900 relative">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6 6 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                    <span class="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-red-500 border-2 border-white"></span>
                </button>

                <!-- User Info -->
                <div class="flex items-center gap-2" :class="{ 'flex-row-reverse': isRTL }">
                    <div class="w-9 h-9 rounded-full bg-green-600 text-white flex items-center justify-center font-semibold text-sm">
                        {{ currentUser.name?.charAt(0) || 'U' }}
                    </div>
                    <span class="hidden md:inline text-sm font-medium text-gray-700">{{ currentUser.name || 'User' }}</span>
                </div>

                <!-- Logout Button -->
                <button @click="logout"
                    class="bg-green-600 text-white hover:bg-green-700 transition-colors flex items-center rounded-md px-3 py-2 text-sm"
                    :class="{ 'flex-row-reverse': isRTL }">
                    <svg class="w-5 h-5" :class="{ 'ml-2': !isRTL, 'mr-2': isRTL }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    <span>{{ isRTL ? 'تسجيل خروج' : 'Logout' }}</span>
                </button>
            </div>
        </div>
    </header>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from "vue";
import store from "../store";
import router from "../router";
import { useLanguage } from '../composables/useLanguage';

const {
    currentLanguage,
    currentLanguageFlag,
    currentLanguageName,
    changeLanguage,
    currentDirection
} = useLanguage();

const currentUser = computed(() => store.state.user.data || {});
const isRTL = computed(() => currentDirection.value === 'rtl');
const isDropdownOpen = ref(false);
const languageDropdownRef = ref(null);

const toggleDropdown = () => {
    isDropdownOpen.value = !isDropdownOpen.value;
};

const handleLanguageChange = (lang) => {
    changeLanguage(lang);
    isDropdownOpen.value = false;
};

const handleClickOutside = (event) => {
    if (languageDropdownRef.value && !languageDropdownRef.value.contains(event.target)) {
        isDropdownOpen.value = false;
    }
};

function logout() {
    store.dispatch('logout').then(() => {
        router.push({ name: 'login' });
    });
}

const emit = defineEmits(['toggle-sidebar']);
const emitToggle = () => {
    emit('toggle-sidebar');
};

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>
