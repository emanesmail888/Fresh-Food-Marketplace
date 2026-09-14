<!-- Sidebar.vue -->
<template>
    <aside
        class="bg-gray-800 text-gray-100 fixed inset-y-0 z-40 transform transition-transform duration-300 ease-in-out"
        :class="[
            /* If sidebarOpen is true, bring it into view (0 translation) */
            sidebarOpen ? 'translate-x-0' : (isRTL ? 'translate-x-full' : '-translate-x-full')
        ]" :style="{
        width: sidebarWidth + 'px',
        [isRTL ? 'right' : 'left']: 0
    }">
        <div class="flex flex-col h-full">
            <!-- Header with close button (mobile) -->
            <div class="h-16 flex items-center justify-between px-5 border-b border-gray-800"
                :class="{ 'flex-row-reverse': isRTL }">
                <div class="text-xl font-bold tracking-tight" :class="{ 'text-right': isRTL }">
                    Admin<span class="text-green-400">Panel</span>
                </div>
                <button @click="emitClose" class="lg:hidden text-gray-300 hover:text-white focus:outline-none"
                    aria-label="Close sidebar">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <!-- Navigation links -->
            <nav class="flex-1 px-3 py-5 overflow-y-auto">
                <ul class="space-y-1.5">

                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.dashboard' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/dashboard')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-500 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                            </svg>
                            <span> {{ t("Dashboard") }}</span>
                        </router-link>
                    </li>

                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.products' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/products')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <svg class="h-5 w-5 shrink-0" fill="#fff" version="1.1" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 256 256">
                                <g>
                                    <g>
                                        <path
                                            d="M186.9,119.5H77.5V10.1h109.5V119.5z M178.9,18.1H85.5v93.4h93.4L178.9,18.1L178.9,18.1z" />
                                        <path d="M141.9,32.3h-34.1h0h-8v34.2h8V40.4h34.1V32.3L141.9,32.3z" />
                                        <path d="M119.5,245.9H10V136.5h109.5V245.9z M111.4,144.5H18v93.4h93.4V144.5z" />
                                        <path d="M74.5,158.8H40.3h0h-8v34.2h8v-26.1h34.1L74.5,158.8L74.5,158.8z" />
                                        <path
                                            d="M246,245.9H136.5V136.5H246V245.9z M238,144.5h-93.4v93.4H238V144.5L238,144.5z" />
                                        <path d="M201,158.8h-34.1h0h-8v34.2h8v-26.1H201V158.8z" />
                                    </g>
                                </g>
                            </svg>
                            <!-- <span>{{ isRTL ? 'المنتجات' : 'Products' }}</span> -->
                            <span>{{ t("Products") }}</span>
                        </router-link>
                    </li>

                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.categories' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/categories')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <svg class="h-5 w-5 shrink-0" fill="#fff" version="1.1" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 256 256">
                                <g>
                                    <g>
                                        <g>
                                            <path
                                                d="M22.4,41.6c-4.8,1-8.6,4-11.1,8.7c-1.3,2.4-1.3,2.9-1.3,15.2v12.8l1.5,3.1c1.6,3.3,3.5,5.2,7.1,7.1c2.2,1.2,2.7,1.2,24.7,1.4C69.8,90,70.1,90,74.6,85.4c4.3-4.3,4.6-5.8,4.6-20.2V53.1l-1.7-3.3c-1.7-3.5-4.3-6-7.9-7.6c-1.8-0.8-4.5-0.9-23.5-1C34.3,41.1,23.6,41.3,22.4,41.6z" />
                                            <path
                                                d="M105.8,41.6c-4.8,0.8-8.5,3.6-10.8,8.3l-1.7,3.3v12.1c0,14.4,0.3,15.9,4.6,20.2c4.6,4.6,4.8,4.6,31.3,4.4l22.4-0.2l3-1.7c3.6-2.1,6.2-5.3,7.4-9.2c1.2-4.2,0.9-25-0.4-28c-1.4-3-5.1-6.7-8.2-8.1c-2.8-1.3-3-1.3-24-1.4C117.9,41.1,107.2,41.3,105.8,41.6z" />
                                            <path
                                                d="M189.1,41.6c-5,1-9,4.2-11.1,9c-1.2,2.6-1.3,3.3-1.3,15.2c0,11.6,0.1,12.7,1.1,15c1.4,3,4.3,6,7.4,7.7c2.2,1.3,2.6,1.3,25,1.4c25.7,0.2,26,0.2,30.5-3.9c1.4-1.3,3.1-3.4,3.8-5c1.3-2.6,1.3-3.3,1.3-15c0-13.7-0.3-15.6-3.6-19.4c-1-1.3-3.3-2.9-5-3.7l-3.1-1.5l-21.5-0.1C201.1,41.1,190.4,41.3,189.1,41.6z" />
                                            <path
                                                d="M19.9,104.8c-3.5,1.3-6.5,4-8.4,7.7l-1.5,2.7v12.8v12.8l1.5,3.1c0.9,1.7,2.6,4,3.7,5c4.2,3.6,4.7,3.6,30.4,3.5c22.4-0.2,23.1-0.2,25.2-1.4c2.6-1.4,5.7-4.6,7.1-7.2c0.9-1.7,1-3.3,1-15.5c0-13-0.1-13.7-1.2-15.8c-1.7-3.1-4.3-5.6-7.5-7.1c-2.7-1.3-2.7-1.3-25.5-1.3C27.1,104.1,21.5,104.2,19.9,104.8z" />
                                            <path
                                                d="M102.3,105.3c-3.1,1.5-5.8,4-7.5,7.1c-1.1,2.1-1.2,2.9-1.2,15.8c0,15.3,0.1,15.8,4.5,19.9c4.3,4.2,3.2,4,28.9,4.2c25.7,0.2,26.2,0.1,30.4-3.5c1.2-1,2.9-3.3,3.7-5l1.5-3.1v-12.8v-12.8l-1.5-2.8c-1.7-3.1-4.6-5.9-7.7-7.3c-2.1-0.9-4-1-25.3-1C105.1,104,105.1,104,102.3,105.3z" />
                                            <path
                                                d="M186.6,104.8c-4.7,1.7-8.5,6.2-9.6,11.6c-0.4,1.8-0.5,7.1-0.4,13.6c0.2,10.4,0.2,10.8,1.7,13.8c1.7,3.5,3.8,5.5,7.8,7.3l2.8,1.3l23.2-0.2c22.8-0.2,23.3-0.2,25.5-1.4c3.1-1.7,5.6-4.3,7.1-7.6c1.3-2.8,1.3-3.1,1.1-15.8c-0.2-14.4-0.4-15.3-4.2-19.2c-4.2-4.2-3.5-4.1-29.6-4.2C193.5,104.1,188.3,104.2,186.6,104.8z" />
                                            <path
                                                d="M19.7,167.4c-3.3,1.2-6.5,4.2-8.2,7.7l-1.5,3.1v12.8v12.8l1.5,2.8c1.7,3.1,4.6,5.9,7.7,7.3c2.1,0.9,4,1,25.3,1c23.1,0,23.1,0,25.8-1.3c3.2-1.5,5.8-3.9,7.5-7.1c1.1-2.1,1.2-2.8,1.2-15.8c0-12.2-0.1-13.8-1-15.5c-1.4-2.7-4.6-5.9-7.1-7.2c-2.1-1.2-2.7-1.2-25.5-1.3C25.9,166.5,21.6,166.7,19.7,167.4z" />
                                            <path
                                                d="M104.2,167c-3.7,1.1-7.6,4.5-9.6,8.2c-0.9,1.7-1,3.3-1,15.5c0,13,0.1,13.7,1.2,15.8c1.7,3.1,4.3,5.6,7.5,7.1c2.7,1.3,2.7,1.3,25.8,1.3c21.3,0,23.2-0.1,25.3-1c3.2-1.5,6-4.2,7.7-7.3l1.5-2.8v-12.8v-12.8l-1.5-3.1c-0.9-1.7-2.5-4-3.7-5c-4.1-3.5-4.6-3.6-29.4-3.5C115.6,166.5,105,166.8,104.2,167z" />
                                            <path
                                                d="M185.3,168.1c-3.7,1.8-5.7,3.9-7.4,7.6c-1,2.3-1.1,3.4-1.1,14.9c0,11.5,0.1,12.7,1.1,14.9c1.6,3.4,3.6,5.7,6.7,7.5l2.5,1.5h24.2c27.1,0,26.2,0.1,30.4-4.1c3.9-3.9,4.1-4.7,4.2-19.2c0.2-12.7,0.1-13-1.1-15.8c-1.5-3.3-4-5.9-7.1-7.6c-2.2-1.2-2.7-1.2-25.6-1.4l-23.4-0.2L185.3,168.1z" />
                                        </g>
                                    </g>
                                </g>
                            </svg>
                            <span>{{ t("Categories") }}</span>
                        </router-link>
                    </li>
                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.services' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/services')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <svg class="h-5 w-5 shrink-0" fill="#fff" version="1.1" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 256 256">
                                <g>
                                    <g>
                                        <g>
                                            <path
                                                d="M128,20c-59.6,0-108,48.4-108,108s48.4,108,108,108s108-48.4,108-108S187.6,20,128,20z M128,224c-53,0-96-43-96-96s43-96,96-96s96,43,96,96S181,224,128,224z" />
                                            <path
                                                d="M128,44c-46.3,0-84,37.7-84,84s37.7,84,84,84s84-37.7,84-84S174.3,44,128,44z M128,200c-39.8,0-72-32.2-72-72s32.2-72,72-72s72,32.2,72,72S167.8,200,128,200z" />
                                            <path
                                                d="M171.4,84.6c-2.3-2.3-6.1-2.3-8.5,0l-34.8,34.8l-12.3-12.3c-2.3-2.3-6.1-2.3-8.5,0s-2.3,6.1,0,8.5l16.6,16.6c1.2,1.2,2.7,1.8,4.2,1.8s3.1-0.6,4.2-1.8l39.1-39.1C173.7,90.7,173.7,86.9,171.4,84.6z" />
                                        </g>
                                    </g>
                                </g>
                            </svg>
                            <span>{{ t("Services") }}</span>
                        </router-link>
                    </li>
                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.settings.groups' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/settings')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <svg class="h-5 w-5 shrink-0" fill="#fff" version="1.1" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 256 256">
                                <g>
                                    <g>
                                        <g>
                                            <path
                                                d="M226.8,104.6l-14.5-5.2c-1-3.6-2.2-7.1-3.6-10.5l8.2-13c2.7-4.3,1.7-9.9-2.2-13.1l-16.5-12.4c-3.7-2.8-9-2.1-12,1.5l-10.1,12.3c-3.2-1.8-6.5-3.3-9.9-4.5l-2.3-15.1c-0.7-4.9-4.9-8.5-9.9-8.5h-20.1c-5,0-9.1,3.6-9.9,8.5l-2.3,15.1c-3.4,1.2-6.7,2.7-9.9,4.5l-10.1-12.3c-3-3.6-8.3-4.3-12-1.5L70,65.8c-4,3.1-4.9,8.8-2.2,13.1l8.2,13c-1.4,3.4-2.6,6.9-3.6,10.5l-14.5,5.2c-4.6,1.6-7.6,6-7.6,10.9v19.1c0,4.9,3,9.3,7.6,10.9l14.5,5.2c1,3.6,2.2,7.1,3.6,10.5l-8.2,13c-2.7,4.3-1.7,9.9,2.2,13.1l16.5,12.4c3.7,2.8,9,2.1,12-1.5l10.1-12.3c3.2,1.8,6.5,3.3,9.9,4.5l2.3,15.1c0.7,4.9,4.9,8.5,9.9,8.5h20.1c5,0,9.1-3.6,9.9-8.5l2.3-15.1c3.4-1.2,6.7-2.7,9.9-4.5l10.1,12.3c3,3.6,8.3,4.3,12,1.5l16.5-12.4c4-3.1,4.9-8.8,2.2-13.1l-8.2-13c1.4-3.4,2.6-6.9,3.6-10.5l14.5-5.2c4.6-1.6,7.6-6,7.6-10.9v-19.1C234.4,110.6,231.4,106.2,226.8,104.6z M128,164c-19.9,0-36-16.1-36-36s16.1-36,36-36s36,16.1,36,36S147.9,164,128,164z" />
                                        </g>
                                    </g>
                                </g>
                            </svg>
                            <span>{{ t("Settings") }}</span>
                        </router-link>
                    </li>

                    <!-- Orders -->
                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.orders.index' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/orders')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <!-- Orders Icon -->
                            <svg class="h-5 w-5 shrink-0" fill="currentColor" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 24 24">
                                <path
                                    d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z" />
                            </svg>
                            <span>{{ t("orders") }}</span>
                        </router-link>
                    </li>

                    <!-- Contacts -->
                    <li class="mb-3" :class="{ 'pl-2': !isRTL, 'pr-2': isRTL }">
                        <router-link :to="{ name: 'app.contacts' }"
                            class="sidebar-link flex gap-3 p-2 transition-all duration-200" :class="[
                                isRTL ? 'flex-row-reverse' : '',
                                isActive('/app/contacts')
                                    ? 'bg-gray-500 border-gray-400 rounded-xl text-white'
                                    : 'text-gray-300 hover:bg-gray-700/50 rounded-lg'
                            ]" :style="{ marginRight: isRTL ? '0.25rem' : '0', marginLeft: !isRTL ? '0.25rem' : '0' }">
                            <!-- Contacts/Envelope Icon -->
                            <svg class="h-5 w-5 shrink-0" fill="currentColor" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 24 24">
                                <path
                                    d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z" />
                            </svg>
                            <span>{{ t("messages") }}</span>
                            <!-- Optional: Show unread count badge
                            <span v-if="unreadCount > 0"
                                class="ml-auto bg-red-500 text-white text-xs rounded-full px-2 py-0.5">
                                {{ unreadCount }}
                            </span> -->
                        </router-link>
                    </li>


                </ul>
            </nav>

            <!-- Bottom section -->
            <div class="p-4 border-t border-gray-800 mt-auto">
                <button @click="logout"
                    class="flex items-center gap-3 w-full px-3 py-3 text-gray-300 hover:bg-gray-700/50 rounded-lg transition-colors"
                    :class="{ 'flex-row-reverse': isRTL }">
                    <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    <span>{{ t("Logout") }}</span>
                </button>
            </div>
        </div>
    </aside>
</template>

<script setup>
import { useRoute } from "vue-router";
import store from "../store";
import router from "../router";
import { computed } from "vue";
import { useLanguage } from "../composables/useLanguage";

const route = useRoute();

const {
    currentLanguage,
    t,

} = useLanguage()

const { currentDirection } = useLanguage();
const isRTL = computed(() => currentDirection.value === 'rtl');
const isActive = (path) => route.path === path;

defineProps({
    sidebarOpen: Boolean,
    sidebarWidth: {
        type: Number,
        default: 256,
    },
    isRTL: {
        type: Boolean,
        default: false
    }
});

function logout() {
    store.dispatch("logout").then(() => {
        router.push({ name: "login" });
    });
}

const emit = defineEmits(["close"]);

const emitClose = () => {
    emit("close");
};
</script>

<style scoped>
.sidebar-link {
    transition: all 0.2s ease;
}

.sidebar-link.active {
    background-color: rgb(107 114 128);
    border-radius: 0.75rem;
}
</style>
