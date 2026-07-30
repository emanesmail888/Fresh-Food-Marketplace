<!-- views/MyAccount.vue -->
<template>
    <home-layout>
        <div class="container mx-auto px-4 py-8" :dir="currentDirection">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">
                {{ t('my_account') }}
            </h1>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <!-- Sidebar -->
                <div class="lg:col-span-1">
                    <div class="bg-white rounded-xl shadow-md overflow-hidden">
                        <!-- User Info -->
                        <div class="p-6 text-center border-b border-gray-200">
                            <div class="w-24 h-24 rounded-full bg-green-100 mx-auto flex items-center justify-center text-4xl font-bold text-green-700 mb-3">
                                {{ getUserInitials() }}
                            </div>
                            <h3 class="text-lg font-semibold text-gray-800">{{ user?.name }}</h3>
                            <p class="text-sm text-gray-500">{{ user?.email }}</p>
                            <span v-if="user?.email_verified_at" class="text-xs text-green-600 mt-1 inline-block">
                                ✅ {{ t('verified_email') }}
                            </span>
                        </div>

                        <!-- Navigation -->
                        <nav class="p-2">
                            <button v-for="tab in tabs" :key="tab.key"
                                @click="activeTab = tab.key"
                                class="w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all duration-200"
                                :class="[
                                    activeTab === tab.key
                                        ? 'bg-green-50 text-green-700 font-semibold'
                                        : 'text-gray-600 hover:bg-gray-50'
                                ]">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="tab.icon" />
                                </svg>
                                <span>{{ t(tab.label) }}</span>
                                <span v-if="tab.badge" class="ml-auto bg-green-100 text-green-700 text-xs px-2 py-1 rounded-full">
                                    {{ tab.badge }}
                                </span>
                            </button>

                            <!-- Logout Button -->
                            <button @click="logout"
                                class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition-all duration-200 mt-2">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                </svg>
                                <span>{{ t('logout') }}</span>
                            </button>
                        </nav>
                    </div>
                </div>

                <!-- Content -->
                <div class="lg:col-span-3">
                    <div class="bg-white rounded-xl shadow-md p-6">
                        <!-- Profile Tab -->
                        <div v-if="activeTab === 'profile'">
                            <ProfileForm :user="user" @updated="fetchUser" />
                        </div>

                        <!-- Orders Tab -->
                        <div v-if="activeTab === 'orders'">
                            <OrdersList
                                :orders="orders"
                                :loading="ordersLoading"
                                :pagination="ordersPagination"
                                @refresh="fetchOrders"
                                @page-change="handleOrdersPageChange"
                            />
                        </div>

                        <!-- Reviews Tab -->
                        <div v-if="activeTab === 'reviews'">
                            <ReviewsList
                                :reviews="userReviews"
                                :loading="reviewsLoading"
                                :pagination="reviewsPagination"
                                @refresh="fetchUserReviews"
                                @page-change="handleReviewsPageChange"
                            />
                        </div>

                        <!-- Wishlist Tab -->
                        <div v-if="activeTab === 'wishlist'">
                            <WishlistList :items="wishlist" :loading="wishlistLoading" @refresh="fetchWishlist" />
                        </div>

                        <!-- Address Tab -->
                        <div v-if="activeTab === 'address'">
                            <AddressForm :address="userAddress" @updated="fetchAddress" />
                        </div>

                        <!-- Password Tab -->
                        <div v-if="activeTab === 'password'">
                            <ChangePassword @updated="handlePasswordUpdated" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </home-layout>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useStore } from 'vuex';
import { useRouter ,useRoute} from 'vue-router';
import { useToast } from 'vue-toastification';
import { useLanguage } from '../composables/useLanguage.js';
import HomeLayout from '../components/HomeLayout.vue';
import ProfileForm from '../components/account/ProfileForm.vue';
import OrdersList from '../components/account/OrdersList.vue';
import ReviewsList from '../components/account/ReviewsList.vue';
import WishlistList from '../components/account/Wishlist.vue';
import AddressForm from '../components/account/AddressForm.vue';
import ChangePassword from '../components/account/ChangePassword.vue';

const store = useStore();
const router = useRouter();
const route = useRoute();        // ← New
const toast = useToast();
const { currentLanguage, currentDirection, t } = useLanguage();

// ============ STATE ============
const activeTab = ref('profile');
const user = ref(null);
const orders = ref([]);
const userReviews = ref([]);
const wishlist = ref([]);
const userAddress = ref(null);

// Loading states
const ordersLoading = ref(false);
const reviewsLoading = ref(false);
const wishlistLoading = ref(false);

// ✅ تعريف Pagination objects
const ordersPagination = ref({
    current_page: 1,
    last_page: 1,
    per_page: 10,
    total: 0
});

const reviewsPagination = ref({
    current_page: 1,
    last_page: 1,
    per_page: 10,
    total: 0
});

// Tabs configuration
const tabs = [
    { key: 'profile', label: 'profile', icon: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z' },
    { key: 'orders', label: 'orders', icon: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z' },
    { key: 'reviews', label: 'my_reviews', icon: 'M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z' },
    { key: 'wishlist', label: 'wishlist', icon: 'M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z' },
    { key: 'address', label: 'address', icon: 'M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z M15 11a3 3 0 11-6 0 3 3 0 016 0z' },
    { key: 'password', label: 'change_password', icon: 'M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z' }
];

// Computed
const isAuthenticated = computed(() => store.getters.isAuthenticated);


// ============ URL SYNC ============

// Set activeTab from URL on mount + when query changes
const syncTabFromUrl = () => {
    const tabFromUrl = route.query.tab;
    if (tabFromUrl && tabs.some(t => t.key === tabFromUrl)) {
        activeTab.value = tabFromUrl;
    }
};

// Update URL when tab changes
const updateUrl = (tab) => {
    router.replace({
        query: { ...route.query, tab: tab }
    }).catch(err => {
        // Ignore navigation duplicate errors
        if (err.name !== 'NavigationDuplicated') console.error(err);
    });
};

// Watch for route changes (back/forward browser buttons)
watch(() => route.query.tab, syncTabFromUrl);

// Watch activeTab and update URL
watch(activeTab, (newTab) => {
    updateUrl(newTab);
    loadTabData(newTab);
});

// Methods
const getUserInitials = () => {
    if (!user.value?.name) return '?';
    return user.value.name
        .split(' ')
        .map(word => word.charAt(0))
        .join('')
        .toUpperCase()
        .slice(0, 2);
};




// ============ FETCH METHODS ============

const fetchUser = async () => {
    try {
        const response = await store.dispatch('users/fetchProfile');
        user.value = response;
    } catch (error) {
        console.error('Error fetching user:', error);
        toast.error(t('error_fetching_profile'));
    }
};

const fetchOrders = async (page = 1) => {
    ordersLoading.value = true;
    try {
        const response = await store.dispatch('users/fetchOrders', { page });
        console.log('Orders response:', response);

        if (response) {
            // Extract orders data
            orders.value = response.data || [];

            // ✅ Update pagination
            ordersPagination.value = {
                current_page: response.current_page || 1,
                last_page: response.last_page || 1,
                per_page: response.per_page || 10,
                total: response.total || 0
            };
        } else {
            orders.value = [];
        }
    } catch (error) {
        console.error('Error fetching orders:', error);
        toast.error(t('error_fetching_orders'));
        orders.value = [];
    } finally {
        ordersLoading.value = false;
    }
};

const fetchUserReviews = async (page = 1) => {
    reviewsLoading.value = true;
    try {
        const response = await store.dispatch('users/fetchReviews', { page });
        console.log('Reviews response:', response);

        if (response) {
            userReviews.value = response.data || [];

            // ✅ Update pagination
            reviewsPagination.value = {
                current_page: response.current_page || 1,
                last_page: response.last_page || 1,
                per_page: response.per_page || 10,
                total: response.total || 0
            };
        } else {
            userReviews.value = [];
        }
    } catch (error) {
        console.error('Error fetching reviews:', error);
        toast.error(t('error_fetching_reviews'));
        userReviews.value = [];
    } finally {
        reviewsLoading.value = false;
    }
};

const fetchWishlist = async () => {
    wishlistLoading.value = true;
    try {
        const response = await store.dispatch('wishlist/fetchWishlist');
        wishlist.value = response.data || [];
    } catch (error) {
        console.error('Error fetching wishlist:', error);
        toast.error(t('error_fetching_wishlist'));
        wishlist.value = [];
    } finally {
        wishlistLoading.value = false;
    }
};

const fetchAddress = async () => {
    try {
        const response = await store.dispatch('users/fetchAddress');
        userAddress.value = response;
    } catch (error) {
        console.error('Error fetching address:', error);
    }
};

// ============ HANDLERS ============

const handleOrdersPageChange = (page) => {
    fetchOrders(page);
};

const handleReviewsPageChange = (page) => {
    fetchUserReviews(page);
};

const handlePasswordUpdated = () => {
    toast.success(t('password_updated_success'));
};

const logout = async () => {
    if (confirm(t('confirm_logout'))) {
        try {
            await store.dispatch('logout');
            toast.success(t('logged_out'));
            router.push({ name: 'home' });
        } catch (error) {
            console.error('Error logging out:', error);
            toast.error(t('error_logging_out'));
        }
    }
};

// ============ LOAD DATA ============

const loadTabData = (tab) => {
    switch (tab) {
        case 'profile':
            fetchUser();
            break;
        case 'orders':
            fetchOrders();
            break;
        case 'reviews':
            fetchUserReviews();
            break;
        case 'wishlist':
            fetchWishlist();
            break;
        case 'address':
            fetchAddress();
            break;
    }
};

// ============ WATCHERS ============

// watch(activeTab, (newTab) => {
//     loadTabData(newTab);
// });



// ============ LIFECYCLE ============

onMounted(() => {
    if (!isAuthenticated.value) {
        router.push({ name: 'login' });
        return;
    }

    // Register user module if not registered
    if (!store.state.users) {
        store.registerModule('users', require('../store/modules/users').default);
    }
     fetchUser();


  // Sync from URL first
    syncTabFromUrl();

    // Load data for current tab
    loadTabData(activeTab.value);});

// Expose for debugging
defineExpose({
    fetchOrders,
    fetchUserReviews
});
</script>
