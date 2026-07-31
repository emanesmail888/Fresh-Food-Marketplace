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
        'https://fresh-food-marketplace-cfd0evrn4-emanzidanelgmal-9945s-projects.vercel.app',
        'https://fresh-food-marketplace-fjxdz8nr6-emanzidanelgmal-9945s-projects.vercel.app',
        'https://fresh-food-marketplace.vercel.app', // Your main domain
        'http://localhost:5173', // For local development
        'http://localhost:3000', // Common Vue dev port
    ],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];
