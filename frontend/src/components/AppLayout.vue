<!-- AppLayout.vue -->
<template>
  <div class="min-h-screen bg-gray-50 flex flex-col" :dir="currentDirection">
    <!-- Sidebar -->
    <Sidebar
      :sidebar-open="sidebarOpen"
      :sidebar-width="sidebarWidth"
      @close="sidebarOpen = false"
    />

    <!-- Main Content Area -->
    <div
      class="flex-1 flex flex-col transition-all duration-300"
      :class="mainContentClasses"
    >
      <!-- Navbar -->
      <Navbar @toggle-sidebar="toggleSidebar" />

      <!-- Page Content -->
      <main class="flex-1 p-5 sm:p-6 lg:p-8 overflow-auto">
        <router-view></router-view>
      </main>
    </div>

    <!-- Mobile Backdrop -->
    <div
      v-if="sidebarOpen && isMobile"
      class="fixed inset-0 bg-black/50 z-30 lg:hidden transition-opacity"
      @click="sidebarOpen = false"
    ></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from "vue";
import Navbar from "./Navbar.vue";
import Sidebar from "./Sidebar.vue";
import { useLanguage } from "../composables/useLanguage";   // ← Import this

const { currentDirection } = useLanguage();

const sidebarOpen = ref(false);
const sidebarWidth = 256;
const isMobile = ref(false);

const mainContentClasses = computed(() => {
  if (!isMobile.value) {
    // Desktop: always shift content
    return currentDirection.value === 'rtl'
      ? 'lg:mr-64'   // Right margin for RTL
      : 'lg:ml-64';  // Left margin for LTR
  }
  return ''; // Mobile: no permanent shift
});

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value;
};


const updateScreenSize = () => {
  const mobile = window.innerWidth < 1024;
  isMobile.value = mobile;

  if (!mobile) {
    sidebarOpen.value = true;   // Forces translate-x-0 on desktop
  } else {
    sidebarOpen.value = false;  // Forces off-screen translation on mobile
  }
};

onMounted(() => {
  updateScreenSize();
  window.addEventListener("resize", updateScreenSize);
});

onUnmounted(() => {
  window.removeEventListener("resize", updateScreenSize);
});
</script>
