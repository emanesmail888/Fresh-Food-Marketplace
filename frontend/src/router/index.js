import { createRouter, createWebHistory } from "vue-router";
import { defineAsyncComponent } from 'vue'

import AppLayout from '../components/AppLayout.vue'
import Dashboard from "../views/Admin/Dashboard.vue";
import Login from "../views/Login.vue";
import Register from "../views/Register.vue";
import RequestPassword from "../views/RequestPassword.vue";
import ResetPassword from "../views/ResetPassword.vue";
import Products from "../views/Products/Products.vue";
import Categories from "../views/Categories/Categories.vue";
import Services from "../views/Services/Services.vue";
import ServiceForm from "../views/Services/ServiceForm.vue";
import CategoryForm from "../views/Categories/CategoryForm.vue";
import Cart from "../views/Cart.vue";
import store from "../store";
import NotFound from "../views/NotFound.vue";
import Home from "../views/HomePage.vue";
import OrderConfirmation from "../components/OrderConfirmation.vue";
import ProductsPage from "../views/ProductsPage.vue";

import OrderTracking from "../components/OrderTracking.vue";
import Contact from "../views/Contact.vue";
import OurServices from "../views/OurServices.vue";
import ProductDetails from "../views/ProductDetails.vue";
import OrdersIndex from '../views/Orders/OrdersIndex.vue';
import ContactsIndex from '../views/Contacts/ContactsIndex.vue';
import OrderShow from '../views/Orders/Show.vue';
import MyAccount from "../views/MyAccount.vue";
import Faq from "../views/Faq.vue";
import About from "../views/About.vue";
import Shop from "../views/Shop.vue";
import Checkout from "../views/Checkout.vue";

// Lazy loaded components
// const Shop = defineAsyncComponent(() => import('../views/Shop.vue'))
// const Checkout = defineAsyncComponent(() => import('../views/Checkout.vue'))
const SettingsManager = defineAsyncComponent(() => import('../views/SettingsManager.vue'))

const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,
  },
  {
    path: '/shop',
    name: 'shop',
    component: Shop
  },
  {
    path: '/category',
    name: 'category-products',
    component: ProductsPage
  },
  {
    path: '/contact',
    name: 'contact',
    component: Contact
  },
  {
    path: '/product/:slug',
    name: 'product-details',
    component: ProductDetails,
    meta: { title: 'Product Details' }
  },
  {
    path: '/our_services',
    name: 'our_services',
    component: OurServices
  },
  {
    path: '/faq',
    name: 'faq',
    component: Faq,

  },
  {
    path: '/about',
    name: 'about',
    component: About,

  },
  {
    path: '/account',
    name: 'my-account',
    component: MyAccount,
    meta: {
      requiresAuth: true,
      title: 'My Account'
    }
  },
  {
    path: '/cart',
    name: 'cart',
    component: Cart,
    meta: {
      requiresAuth: false
    }
  },
  {
    path: '/checkout',
    name: 'checkout',
    component: Checkout,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/checkout/success',
    name: 'checkout-success',
    component: Checkout,
    meta: { requiresAuth: true }
  },
  {
    path: '/order-confirmation/:orderNumber',
    name: 'order-confirmation',
    component: OrderConfirmation,
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/orders/:orderNumber/track',
    name: 'order-tracking',
    component: OrderTracking,
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/order-confirmation',
    redirect: '/orders'
  },
  {
    path: '/orders/:orderNumber',
    name: 'order-details',
    component: OrderConfirmation,
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/app',
    name: 'app',
    redirect: '/app/dashboard',
    component: AppLayout,
    meta: {
      requiresAdmin: true,
    },
    children: [
      {
        path: 'dashboard',
        name: 'app.dashboard',
        component: Dashboard,
        meta: { requiresAdmin: true }
      },
      {
        path: 'orders',
        name: 'app.orders.index',
        component: OrdersIndex,
        meta: { requiresAdmin: true }
      },
      {
        path: '/orders/:orderNumber/show',
        name: 'orders.show',
        component: OrderShow,
        meta: { requiresAdmin: true }
      },
      {
        path: 'contacts',
        name: 'app.contacts',
        component: ContactsIndex,
        meta: { requiresAdmin: true }
      },
      {
        path: 'products',
        name: 'app.products',
        component: Products,
        meta: { requiresAdmin: true }
      },
      {
        path: 'services',
        name: 'app.services',
        component: Services,
        meta: { requiresAdmin: true }
      },
      {
        path: '/services/create',
        component: ServiceForm,
        name: 'services.create',
        meta: { requiresAdmin: true }
      },
      {
        path: '/services/:id/edit',
        component: ServiceForm,
        name: 'services.edit',
        props: true,
        meta: { requiresAdmin: true }
      },
      {
        path: 'settings',
        name: 'app.settings.groups',
        component: SettingsManager,
        meta: { requiresAdmin: true }
      },
      {
        path: 'categories',
        name: 'app.categories',
        component: Categories,
        meta: { requiresAdmin: true }
      },
      {
        path: '/categories/create',
        component: CategoryForm,
        name: 'categories.create',
        meta: { requiresAdmin: true }
      },
      {
        path: '/categories/:id/edit',
        component: CategoryForm,
        name: 'categories.edit',
        props: true,
        meta: { requiresAdmin: true }
      },
    ]
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: {
      requiresGuest: true
    }
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
    meta: { requiresGuest: true }
  },
  {
    path: '/request-password',
    name: 'requestPassword',
    component: RequestPassword,
    meta: {
      requiresGuest: true
    }
  },
  {
    path: '/reset-password/:token',
    name: 'resetPassword',
    component: ResetPassword,
    meta: {
      requiresGuest: true
    }
  },
  {
    path: '/:pathMatch(.*)',
    name: 'notfound',
    component: NotFound,
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

// ✅ FIXED ROUTER GUARD
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!store.state.user?.token;
  const isAdmin = store.state.user?.data?.is_admin === 1 ||store.state.user?.data?.is_admin === true;
  // If route requires authentication
  if (to.meta.requiresAuth && !isAuthenticated) {
    return next({ name: 'login' });
  }

  // If route requires admin access
  if (to.meta.requiresAdmin) {
    if (!isAuthenticated) {
      return next({ name: 'login' });
    }
    if (!isAdmin) {
      // Redirect non-admin users to account page or home
      return next({ name: 'my-account' });
    }
    // Admin user - allow access
    return next();
  }

  // If route requires guest (non-authenticated)
  if (to.meta.requiresGuest && isAuthenticated) {
    return next({ name: 'my-account' });
  }

  // All other routes - allow access
  next();
});

export default router;
