import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [vue(),
    tailwindcss(),
  ],

  build: {
    minify: 'terser', // أو 'esbuild' للسرعة
    terserOptions: {
      compress: {
        drop_console: true, // إزالة console.log
        drop_debugger: true
      }
    },
    rollupOptions: {
      output: {
        manualChunks: {
          // تقسيم المكتبات الكبيرة
          vendor: ['vue', 'vuex', 'vue-router'],
          charts: ['echarts'],
          ui: ['@headlessui/vue', 'vue-toastification']
        }
      }
    }
  }
})
