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
                // Fix: Use function syntax instead of object
                manualChunks(id) {
                    if (id.includes('node_modules')) {
                        // Group Vue related packages
                        if (id.includes('vue') || id.includes('vuex')) {
                            return 'vendor';
                        }
                        // Group Axios
                        if (id.includes('axios')) {
                            return 'vendor';
                        }
                        // You can add more conditions for other libraries
                        // if (id.includes('lodash')) {
                        //     return 'utils';
                        // }
                        // if (id.includes('chart.js')) {
                        //     return 'charts';
                        // }
                    }
                }
            }
        }
    }
});


