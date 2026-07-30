<template>
    <!-- ==================== TOP BAR ==================== -->
    <section class="bg-gray-900 text-white">
        <div class="container mx-auto px-4 md:px-8 lg:px-16">
            <div class="flex flex-col md:flex-row items-center justify-between py-2 text-sm">
                <!-- Social icons -->
                <div class="flex items-center gap-4 mb-3 md:mb-0">
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="hover:text-emerald-500 transition-colors"><i class="fab fa-whatsapp"></i></a>
                </div>

                <!-- Free shipping text -->
                <div class="text-center mb-3 md:mb-0">
                    <p>{{ t('discount_welcome_short') }}</p>
                </div>

                <!-- Language dropdown -->
                <div class="relative" ref="languageWrapper">
                    <button @click="toggleDropdown('language')"
                        class="flex items-center gap-2 hover:text-emerald-500 transition-colors focus:outline-none px-2 py-1 rounded-lg">
                        <span class="text-base">{{ currentLanguageFlag }}</span>
                        <span class="hidden sm:inline">{{ currentLanguageName }}</span>
                        <i class="fas fa-chevron-down text-xs ml-1" :class="{ 'rotate-180': dropdowns.language }"></i>
                    </button>

                    <!-- Language Dropdown -->
                    <div v-if="dropdowns.language"
                        class="absolute right-0 mt-2 w-56 bg-white text-gray-800 rounded-lg shadow-xl py-2 z-50 border border-gray-200">
                        <button v-for="(lang, code) in languages" :key="code" @click="changeLanguage(code)"
                            class="w-full text-left px-4 py-3 hover:bg-emerald-50 transition-colors flex items-center gap-3"
                            :class="{ 'bg-emerald-50 text-emerald-700': currentLanguage === code }">
                            <span class="text-xl">{{ lang.flag }}</span>
                            <span class="flex-1 font-medium">{{ lang.name }}</span>
                            <i v-if="currentLanguage === code" class="fas fa-check text-emerald-600"></i>
                        </button>

                        <div class="border-t border-gray-100 my-2"></div>

                        <router-link to="/language-settings"
                            class="flex items-center gap-3 px-4 py-3 text-gray-700 hover:bg-gray-50 transition-colors text-sm">
                            <i class="fas fa-cog text-gray-500"></i>
                            <span>{{ t('language_settings') }}</span>
                        </router-link>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== MAIN NAVBAR ==================== -->
    <nav class="sticky top-0 z-50 bg-white border-b border-amber-300 shadow-sm" :dir="currentDirection">
        <div class="container mx-auto px-4 md:px-8 lg:px-16">
            <div class="flex items-center justify-between h-16 md:h-20">

                <!-- Logo -->
                <a href="/" class="text-2xl md:text-3xl font-bold text-black flex items-center gap-2">
                    Plants
                    <i class="fas fa-leaf text-emerald-600"></i>
                    <span class="text-amber-700 font-medium">Shop</span>
                </a>

                <!-- Mobile menu toggle -->
                <button class="md:hidden text-2xl text-gray-700 focus:outline-none" @click="toggleMobileMenu"
                    :aria-expanded="mobileOpen" aria-label="Toggle mobile menu">
                    <i class="fas" :class="mobileOpen ? 'fa-times' : 'fa-bars'"></i>
                </button>

                <!-- Desktop Navigation + Right section -->
                <div class="hidden md:flex items-center gap-6 lg:gap-8 flex-1 justify-center ">

                    <!-- Main Links -->
                    <div class="flex items-center gap-1 lg:gap-2 mx-auto">
                        <a href="/" class="nav-link" :class="{ 'text-emerald-600 font-semibold': isActive('/') }">{{
                            t('home') }}</a>
                        <a href="/shop" class="nav-link"
                            :class="{ 'text-emerald-600 font-semibold': isActive('/shop') }">{{ t('shop') }}</a>



                        <a href="/our_services" class="nav-link">{{ t('services') }}</a>
                        <a href="/about" class="nav-link">{{ t('about_us') }}</a>
                        <a href="/contact" class="nav-link">{{ t('contact') }}</a>

                        <!-- Pages Dropdown -->
                        <!-- <div class="relative" ref="pagesWrapper">
                            <button @click="toggleDropdown('pages')" class="nav-link flex items-center gap-1">
                                {{ t('pages') }}
                                <i class="fas fa-chevron-down text-xs opacity-70"></i>
                            </button>
                            <div v-if="dropdowns.pages"
                                class="absolute left-0 top-full mt-2 w-48 bg-white rounded-lg shadow-xl py-2 border border-gray-100 z-50">
                                <a href="/cart"
                                    class="block px-5 py-2.5 text-gray-700 hover:bg-emerald-50 hover:text-emerald-700">{{
                                        t('shopping_cart') }}</a>
                                <a href="/checkout"
                                    class="block px-5 py-2.5 text-gray-700 hover:bg-emerald-50 hover:text-emerald-700">{{
                                        t('checkout') }}</a>
                            </div>
                        </div> -->
                    </div>

                    <!-- Search + Icons -->
                    <div class="flex items-center gap-5 lg:gap-6">
                        <!-- <div class="relative hidden lg:block">
                            <input type="text" :placeholder="t('search_products')" :class="[
                                'w-56 py-2.5 rounded-full bg-gray-50 border border-gray-300 text-sm focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500',
                                currentDirection === 'rtl' ? 'pr-7 pl-10' : 'pl-4 pr-10'
                            ]" />
                            <button
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-emerald-600">
                                <i class="fas fa-search"></i>
                            </button>
                        </div> -->

                        <a href="/account" class="text-xl text-gray-700 hover:text-emerald-600 transition"><i
                                class="fas fa-user"></i></a>
                        <a href="/account?tab=wishlist" class="text-xl text-gray-700 hover:text-emerald-600 transition"><i
                                class="far fa-star"></i></a>

                        <!-- Cart Dropdown -->
                        <div class="relative" ref="cartWrapper">
                            <button @click="toggleDropdown('cart')"
                                class="text-xl text-gray-700 hover:text-emerald-600 transition relative">
                                <i class="fas fa-shopping-cart"></i>
                                <span v-if="cartCount > 0"
                                    class="absolute -top-1.5 -right-1.5 bg-emerald-600 text-white text-[10px] font-medium rounded-full w-5 h-5 flex items-center justify-center">
                                    {{ cartCount }}
                                </span>
                            </button>

                            <div v-if="dropdowns.cart"
                                class="absolute right-0 top-full mt-3 w-80 bg-white rounded-xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
                                <div class="p-4 border-b bg-gray-50">
                                    <div class="flex justify-between items-center">
                                        <h5 class="font-semibold text-gray-800">{{ cartCount }} ITEMS</h5>
                                        <a href="/cart"
                                            class="text-sm text-emerald-600 hover:text-emerald-700 font-medium">{{
                                                t('view_cart') }}</a>
                                    </div>
                                </div>

                                <div class="p-4 space-y-4 border-b max-h-96 overflow-y-auto">
                                    <!-- Cart items would go here -->
                                    <div v-if="cartItems.length === 0" class="text-center text-gray-500 py-4">
                                        {{ t('cart_empty') }}
                                    </div>
                                    <div v-for="item in cartItems" :key="item.id" class="flex items-center gap-3">
                                        <img
                                            v-if="item.product?.image"
                                            :src="`${storageBase}/${item.product.image}`"
                                            :alt="item.product.title"
                                            class="w-12 h-12 object-cover rounded"
                                            loading="lazy"

                                            />
                                            <div
                                            v-else
                                            class="w-20 h-20 bg-gray-100 rounded-lg flex items-center justify-center text-gray-400 text-xs"
                                            >
                                            {{ t("no_image") }}
                                            </div>
                                        <div class="flex-1">
                                            <h6 class="text-sm font-medium"> {{ item.product?.title || t("Product") }}</h6>
                                            <p class="text-xs text-gray-500">{{ item.quantity_display }} x {{
                                                formatPrice(item.product?.price) }}</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="p-4 flex justify-between items-center border-b">
                                    <span class="font-semibold text-gray-800">{{ t('total') }}</span>
                                    <span class="font-semibold text-gray-900">{{ formatPrice(cartTotal) }}</span>
                                </div>

                                <div class="p-4 flex gap-3">
                                    <router-link to="/cart"
                                        class="flex-1 text-center py-2.5 border border-gray-300 rounded-lg hover:bg-gray-50 text-sm font-medium">
                                        {{ t('view_cart') }}
                                    </router-link>
                                    <router-link to="/checkout"
                                        class="flex-1 text-center py-2.5 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 text-sm font-medium">
                                        {{ t('checkout') }}
                                    </router-link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Mobile Menu -->
            <div v-if="mobileOpen" class="md:hidden py-6 border-t bg-gray-50">
                <div class="flex flex-col gap-4 px-2">
                    <!-- Mobile navigation links -->
                    <a href="/" class="mobile-link" @click="closeMobileMenu">{{ t('home') }}</a>
                    <a href="/shop" class="mobile-link" @click="closeMobileMenu">{{ t('shop') }}</a>

                    <a href="/our_services" class="mobile-link" @click="closeMobileMenu">{{ t('our_services') }}</a>
                    <a href="/about" class="mobile-link" @click="closeMobileMenu">{{ t('about_us') }}</a>
                    <a href="/contact" class="mobile-link" @click="closeMobileMenu">{{ t('contact') }}</a>

                    <!-- Mobile Pages -->
                    <!-- <div>
                        <button @click="toggleMobileDropdown('mobilePages')"
                            class="mobile-link w-full flex justify-between items-center">
                            {{ t('pages') }}
                            <i :class="mobilePages ? 'fa-chevron-up' : 'fa-chevron-down'" class="fas text-xs"></i>
                        </button>
                        <div v-if="mobilePages" class="pl-6 mt-2 space-y-3">
                            <a href="/cart" class="block text-gray-700 hover:text-emerald-600"
                                @click="closeMobileMenu">{{ t('shopping_cart') }}</a>
                            <a href="/checkout" class="block text-gray-700 hover:text-emerald-600"
                                @click="closeMobileMenu">{{ t('checkout') }}</a>
                        </div>
                    </div> -->

                    <!-- Mobile Language Selector -->
                    <div class="border-t border-gray-200 pt-4 mt-2">
                        <h5 class="text-sm font-semibold text-gray-500 mb-3">{{ t('select_language') }}</h5>
                        <div class="grid grid-cols-2 gap-2">
                            <button v-for="(lang, code) in languages" :key="code" @click="changeLanguage(code)"
                                class="flex items-center gap-2 p-2 rounded-lg border"
                                :class="currentLanguage === code ? 'border-emerald-600 bg-emerald-50' : 'border-gray-200'">
                                <span class="text-xl">{{ lang.flag }}</span>
                                <span class="text-sm">{{ lang.name }}</span>
                                <i v-if="currentLanguage === code" class="fas fa-check text-emerald-600 ml-auto"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Mobile search -->
                <div class="mt-8 px-2 pt-6 border-t">
                    <div class="relative mb-6">
                        <input type="text" :placeholder="t(' search_products')"
                            class="w-full px-4 py-3 rounded-full border border-gray-300 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500" />
                        <button class="absolute right-4   top-1/2 -translate-y-1/2 text-gray-500">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>

                    <div class="flex justify-around text-2xl text-gray-700">
                        <a href="/account" class="hover:text-emerald-600" @click="closeMobileMenu"><i
                                class="fas fa-user"></i></a>
                        <a href="/account?tab=wishlist" class="hover:text-emerald-600" @click="closeMobileMenu"><i
                                class="far fa-star"></i></a>
                        <div class="relative">
                            <button @click="toggleMobileDropdown('mobileCart')" class="relative hover:text-emerald-600">
                                <i class="fas fa-shopping-cart"></i>
                                <span v-if="cartCount > 0"
                                    class="absolute -top-2 -right-2 bg-emerald-600 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                                    {{ cartCount }}
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <main>
        <slot></slot>
    </main>
    <Footer  />
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useStore } from 'vuex'
import { useLanguage } from '../composables/useLanguage'
import Footer from '../components/Footer.vue';

// Get language functions
const {
    currentLanguage,
    currentDirection,
    currentLanguageName,
    currentLanguageFlag,
    languages,
    t,
    changeLanguage,
    formatPrice
} = useLanguage()

// Get store
const store = useStore()
const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";
const homeSettings = computed(() => store.state.homeSettings || {})


// Mobile menu state
const mobileOpen = ref(false)
const mobileBlog = ref(false)
const mobilePages = ref(false)
const mobileCart = ref(false)

// Dropdowns state
const dropdowns = ref({
    blog: false,
    pages: false,
    language: false,
    cart: false,
})

// Refs for click outside detection
const languageWrapper = ref(null)
const cartWrapper = ref(null)
const blogWrapper = ref(null)
const pagesWrapper = ref(null)

// Cart data from store
const cartCount = computed(() => {
    try {
        return store.getters['cartCount'] || 0
    } catch (error) {
        console.error('Error getting cart count:', error)
        return 0
    }
})

const cartItems = computed(() => {
    try {
        return store.getters.cartItems || []
    } catch (error) {
        console.error('Error getting cart items:', error)
        return []
    }
})


const cartTotal = computed(() => {
    try {
        return store.getters['cartTotal'] || 0
    } catch (error) {
        console.error('Error getting cart total:', error)
        return 0
    }
})

// ✅ FIXED: Toggle mobile menu with error handling
const toggleMobileMenu = () => {
    try {
        mobileOpen.value = !mobileOpen.value

        // Prevent body scroll when mobile menu is open
        if (mobileOpen.value) {
            document.body.style.overflow = 'hidden'

            // Close all mobile submenus when opening main menu
            mobileBlog.value = false
            mobilePages.value = false
            mobileCart.value = false
        } else {
            document.body.style.overflow = ''
        }
    } catch (error) {
        console.error('Error toggling mobile menu:', error)
        // Fallback
        mobileOpen.value = false
        document.body.style.overflow = ''
    }
}

// Close mobile menu and reset body scroll
const closeMobileMenu = () => {
    try {
        mobileOpen.value = false
        mobileBlog.value = false
        mobilePages.value = false
        mobileCart.value = false
        document.body.style.overflow = ''
    } catch (error) {
        console.error('Error closing mobile menu:', error)
    }
}

// Toggle desktop dropdowns
const toggleDropdown = (dropdown) => {
    try {
        // Close all other dropdowns
        Object.keys(dropdowns.value).forEach(key => {
            if (key !== dropdown) {
                dropdowns.value[key] = false
            }
        })
        // Toggle the selected dropdown
        dropdowns.value[dropdown] = !dropdowns.value[dropdown]
    } catch (error) {
        console.error('Error toggling dropdown:', error)
    }
}

// Toggle mobile dropdowns
const toggleMobileDropdown = (dropdown) => {
    try {
        if (dropdown === 'mobileBlog') {
            mobileBlog.value = !mobileBlog.value
            mobilePages.value = false
            mobileCart.value = false
        } else if (dropdown === 'mobilePages') {
            mobilePages.value = !mobilePages.value
            mobileBlog.value = false
            mobileCart.value = false
        } else if (dropdown === 'mobileCart') {
            mobileCart.value = !mobileCart.value
            mobileBlog.value = false
            mobilePages.value = false
        }
    } catch (error) {
        console.error('Error toggling mobile dropdown:', error)
    }
}

// Handle clicks outside dropdowns
const handleClickOutside = (event) => {
    try {
        // Check language dropdown
        if (languageWrapper.value && !languageWrapper.value.contains(event.target)) {
            dropdowns.value.language = false
        }

        // Check cart dropdown
        if (cartWrapper.value && !cartWrapper.value.contains(event.target)) {
            dropdowns.value.cart = false
        }

        // Check blog dropdown
        if (blogWrapper.value && !blogWrapper.value.contains(event.target)) {
            dropdowns.value.blog = false
        }

        // Check pages dropdown
        if (pagesWrapper.value && !pagesWrapper.value.contains(event.target)) {
            dropdowns.value.pages = false
        }
    } catch (error) {
        console.error('Error handling click outside:', error)
    }
}

// Handle escape key
const handleEscapeKey = (event) => {
    try {
        if (event.key === 'Escape') {
            // Close all dropdowns
            dropdowns.value.blog = false
            dropdowns.value.pages = false
            dropdowns.value.language = false
            dropdowns.value.cart = false

            // Close mobile menu
            if (mobileOpen.value) {
                closeMobileMenu()
            }
        }
    } catch (error) {
        console.error('Error handling escape key:', error)
    }
}

// Handle window resize
const handleResize = () => {
    try {
        if (window.innerWidth >= 768) {
            // Close mobile menu on larger screens
            if (mobileOpen.value) {
                closeMobileMenu()
            }
        }
    } catch (error) {
        console.error('Error handling resize:', error)
    }
}

// Lifecycle hooks
onMounted(() => {
    document.addEventListener('click', handleClickOutside)
    document.addEventListener('keydown', handleEscapeKey)
    window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
    document.removeEventListener('keydown', handleEscapeKey)
    window.removeEventListener('resize', handleResize)
    // Reset body overflow on unmount
    document.body.style.overflow = ''
})

const route = useRoute();
const isActive = (path) => route?.path === path;
</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

.rotate-180 {
    transform: rotate(180deg);
}

[dir="rtl"] .ml-auto {
    margin-left: 0;
    margin-right: auto;
}

[dir="rtl"] .right-0 {
    right: auto;
    left: 0;
}

[dir="rtl"] .left-0 {
    left: auto;
    right: 0;
}

.relative {
    position: relative;
    z-index: 100;
}



:global(body.menu-open) {
    overflow: hidden;
}
</style>
