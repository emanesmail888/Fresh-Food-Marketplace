import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    build: {
    minify: 'terser',
    rollupOptions: {
      output: {
       manualChunks(id) {
          if (id.includes('node_modules')) {
            // Group all vendor dependencies into a single chunk
            return 'vendor'
          }
          
          // Or split into specific chunks
          if (id.includes('vue') || id.includes('pinia')) {
            return 'vendor-vue'
          }
          if (id.includes('element-plus') || id.includes('ant-design-vue')) {
            return 'vendor-ui'
          }
        }
      }
    }
  }
});


