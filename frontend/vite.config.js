import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [vue(), tailwindcss()],

  build: {
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    },
    rollupOptions: {
      output: {
        manualChunks(id) {
          // تقسيم المكتبات الكبيرة
          if (id.includes('node_modules')) {
            if (id.includes('vue') || id.includes('vuex') || id.includes('vue-router')) {
              return 'vendor'
            }
            if (id.includes('echarts')) {
              return 'charts'
            }
            if (id.includes('@headlessui') || id.includes('vue-toastification')) {
              return 'ui'
            }
          }
        }
      }
    }
  }
})
