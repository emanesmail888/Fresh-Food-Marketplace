<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    // 'allowed_origins' => ['*'],
     'allowed_origins' => [
        // Add ALL your current and future Vercel preview URLs
        'https://foodmarketplace.byethost16.com/',

        'https://fresh-food-marketplace.vercel.app', // Your production domain
        'http://localhost:5173',
        'http://localhost:3000',
        'http://127.0.0.1:5173',
        'http://127.0.0.1:3000',
    ],
    //  'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [
        // This pattern allows ANY Vercel preview deployment
        '/^https:\/\/fresh-food-marketplace-.*\.vercel\.app$/',
    ],

    // 'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];
