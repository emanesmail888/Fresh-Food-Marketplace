import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),vue()
    ],
    build: {
    minify: 'terser',
    rollupOptions: {
      output: {
          manualChunks(id) {
          if (id.includes('node_modules')) {
            return 'vendor'
          }
     
      }
    }
  }
});


