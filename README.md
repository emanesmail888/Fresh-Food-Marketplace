📋 Project Overview
A full-featured e-commerce API for selling plants online, built with Laravel (backend) and Vue.js (frontend). It supports browsing plants, cart management, checkout with Stripe, order tracking, reviews, wishlists, and a complete admin dashboard.

🎯 Core Features
Authentication & User Management
User registration & login (/register, /login)

Email verification system with resend capability (rate-limited: 3 attempts/minute)

Sanctum-based token authentication

Password change functionality

Profile management (name, email, phone, avatar)

Address management for shipping

2. Product Catalog (Plants)
Browse all products with categories

Shop page with filters

Product details by slug (SEO-friendly URLs)

Related products suggestions

Category-based product filtering

Product reviews and ratings with statistics

3. Shopping Cart
Add/update/remove items (works for guests too)

Persistent cart per user

Merge guest cart with user cart on login

Clear cart functionality

4. Checkout & Payments
Checkout summary with totals

Stripe payment integration

Discount code application

Session verification after payment

Stripe webhook handling for payment events

5. Order Management
User order history

Order details & tracking

Cancel orders

Reorder from past orders

Refund status checking

6. Wishlist
Add/remove products to wishlist

Toggle wishlist status

Check if product is in wishlist

7. Reviews System
Post reviews on purchased products

Update/delete own reviews

Review statistics (average rating, count)

8. Contact System
Public contact form submission

Admin contact management (list, view, update, delete, bulk delete)

9. Admin Dashboard
Statistics overview (sales, orders, users, etc.)

Full CRUD for Products, Categories, Services

Order management with status updates

Contact message management

Settings Management (the file you were working on) - manage site-wide settings by groups (text, image, video, multi-images)

10. File Upload
Large file chunk upload (for videos)

Multi-image uploads for galleries

Image/video storage with deletion handling

🏗️ Architecture
text
┌─────────────────────────────────────────┐
│         Vue.js Frontend (SPA)           │
│  - Vuex store   - Axios client          │
│  - Components: Shop, Cart, Admin Panel  │
└──────────────────┬──────────────────────┘
                   │ REST API
┌──────────────────▼──────────────────────┐
│         Laravel 10+ Backend             │
│                                         │
│  Controllers:                           │
│  ├─ AuthController                      │
│  ├─ ProductController                   │
│  ├─ CategoryController                  │
│  ├─ CartController                      │
│  ├─ CheckoutController (Stripe)         │
│  ├─ OrderController                     │
│  ├─ ReviewController                    │
│  ├─ WishlistController                  │
│  ├─ UserController                      │
│  ├─ ContactController                   │
│  ├─ DashboardController                 │
│  ├─ SettingController                   │
│  └─ EmailVerificationController         │
│                                         │
│  Models: User, Product, Category,       │
│          Order, Review, Setting, etc.   │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│  MySQL DB  +  Storage (public disk)     │
│  + Stripe API                           │
└─────────────────────────────────────────┘
🔐 Route Access Levels
Level	Routes
Public	/home, /shop, /about, /product/{slug}, /category, /contact, /cart/*
Authenticated	Cart merge, checkout, orders, profile, wishlist, reviews, email verification
Admin only	Products/Categories/Services CRUD, Orders, Contacts, Dashboard, Settings
🛠️ Tech Stack
Backend:

Laravel (latest)

Laravel Sanctum (auth)

Pion Laravel Chunk Upload (large files)

Stripe PHP SDK

MySQL

Frontend:

Vue 3 (Composition API)

Vuex (state management)

Axios

Tailwind CSS



🧪 Postman collection structure?

