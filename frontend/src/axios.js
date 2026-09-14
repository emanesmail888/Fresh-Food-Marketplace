
import axios from "axios";
import store from "./store";
import router from "./router/index.js";

const axiosClient = axios.create({

  baseURL: `${import.meta.env.VITE_API_BASE_URL}/api`,

  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  },
  withCredentials: true, // CRITICAL: This ensures cookies (sessions) are sent with requests
  withXSRFToken: true
});

// Helper functions for cart token management
const getCartToken = () => {
  return localStorage.getItem('cart_token') || null;
};

const setCartToken = (token) => {
  if (token) {
    localStorage.setItem('cart_token', token);
  }
};

const getCookie = (name) => {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
  return null;
};

// Request interceptor
axiosClient.interceptors.request.use(config => {
  // Add auth token if user is logged in
  const token = store.state.user?.token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Add CSRF token for Laravel (important for session security)
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  if (csrfToken) {
    config.headers['X-CSRF-TOKEN'] = csrfToken;
  }

  // ========== ADD CART TOKEN ==========
  // Priority: localStorage → cookie → session
  const cartToken = getCartToken() || getCookie('cart_token');
  if (cartToken) {
    config.headers['X-Cart-Token'] = cartToken;
  }

  // Also send session ID for extra tracking
  const sessionId = localStorage.getItem('session_id') || getCookie('laravel_session');
  if (sessionId) {
    config.headers['X-Session-Id'] = sessionId;
  }

  // Log request for debugging (remove in production)
  if (import.meta.env.DEV) {
    console.log('📤 Request:', {
      url: config.url,
      method: config.method,
      headers: {
        'X-Cart-Token': config.headers['X-Cart-Token'] || 'none',
        'X-Session-Id': config.headers['X-Session-Id'] || 'none',
        'Authorization': config.headers.Authorization ? 'Bearer ***' : 'none'
      }
    });
  }

  return config;
}, error => {
  return Promise.reject(error);
});

// Response interceptor
axiosClient.interceptors.response.use(response => {
  // ========== SAVE CART TOKEN FROM RESPONSE ==========
  // Check if response headers contain cart token
  const cartTokenFromHeader = response.headers['x-cart-token'];
  if (cartTokenFromHeader) {
    setCartToken(cartTokenFromHeader);
  }

  // Check if response data contains cart token
  if (response.data?.data?.cart_token) {
    setCartToken(response.data.data.cart_token);
  }

  // Also check nested cart data
  if (response.data?.data?.cart?.cart_token) {
    setCartToken(response.data.data.cart.cart_token);
  }

  // Save session ID if returned
  const sessionId = response.headers['x-session-id'];
  if (sessionId) {
    localStorage.setItem('session_id', sessionId);
  }

  return response;
}, error => {
  // ========== HANDLE UNAUTHORIZED ==========
  if (error.response?.status === 401) {
    // Clear auth state
    store.commit('setToken', null, { root: true });
    store.commit('setUser', null, { root: true });
    store.commit('CLEAR_AUTH', null, { root: true });

    // Don't clear cart token on 401, keep it for guest cart
    // Redirect to login
    router.push({ name: 'login' });
  }

  // Handle 419 (CSRF token mismatch) - common with sessions
  if (error.response?.status === 419) {
    console.error('CSRF token mismatch - refreshing page');
    // You might want to refresh the CSRF token here
    window.location.reload();
  }

  // Handle 422 (Validation errors) - log but don't redirect
  if (error.response?.status === 422) {
    console.warn('Validation error:', error.response.data);
  }

  return Promise.reject(error);
});

// Helper function to get CSRF cookie (for Laravel Sanctum)
export const getCsrfToken = async () => {
  try {
    await axiosClient.get('/sanctum/csrf-cookie');
    return true;
  } catch (error) {
    console.error('Failed to get CSRF token:', error);
    return false;
  }
};

// Helper to initialize session with cart token
export const initializeSession = async () => {
  try {
    // First, ensure we have a CSRF token
    await getCsrfToken();

    // Check if we have a cart token in storage
    const cartToken = getCartToken();

    // If we have a token, set it in headers for the initial request
    if (cartToken) {
      axiosClient.defaults.headers.common['X-Cart-Token'] = cartToken;
    }

    // Try to get or create guest cart
    const response = await axiosClient.get('/cart');

    // Save token from response
    if (response.data?.data?.cart_token) {
      setCartToken(response.data.data.cart_token);
    }

    return response.data;
  } catch (error) {
    console.error('Failed to initialize session:', error);
    throw error;
  }
};

// Helper to clear cart token (for logout or cart reset)
export const clearCartToken = () => {
  localStorage.removeItem('cart_token');
  localStorage.removeItem('session_id');
  localStorage.removeItem('cart_backup');
  delete axiosClient.defaults.headers.common['X-Cart-Token'];
};

// Helper to get current cart token
export const getCurrentCartToken = () => {
  return getCartToken();
};

// Helper to manually set cart token (for testing or manual updates)
export const updateCartToken = (token) => {
  if (token) {
    setCartToken(token);
    axiosClient.defaults.headers.common['X-Cart-Token'] = token;
  } else {
    clearCartToken();
  }
};

// Helper to check if user has an active cart
export const hasActiveCart = () => {
  return !!getCartToken();
};

export default axiosClient;
