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
  // ✅ CHANGE THIS: Set to false since you're using JWT Bearer tokens
  withCredentials: false,
  // ✅ CHANGE THIS: Set to false if not using Laravel Sanctum CSRF
  withXSRFToken: false
});

// Request interceptor
axiosClient.interceptors.request.use(config => {
  // Add auth token if user is logged in
  const token = store.state.user?.token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Only add CSRF token if you're actually using it
  // If you're using JWT, you don't need this
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  if (csrfToken && withXSRFToken) {
    config.headers['X-CSRF-TOKEN'] = csrfToken;
  }

  return config;
}, error => {
  return Promise.reject(error);
});

// Response interceptor
axiosClient.interceptors.response.use(response => {
  return response;
}, error => {
  if (error.response?.status === 401) {
    // Clear auth state
    store.commit('setToken', null, { root: true });
    store.commit('setUser', null, { root: true });
    store.commit('CLEAR_AUTH', null, { root: true });

    // Redirect to login
    router.push({ name: 'login' });
  }

  // Handle 419 (CSRF token mismatch)
  if (error.response?.status === 419) {
    console.error('CSRF token mismatch - refreshing page');
    window.location.reload();
  }

  return Promise.reject(error);
});

// Helper function to get CSRF cookie (for Laravel Sanctum)
// You only need this if using Sanctum with cookies
export const getCsrfToken = async () => {
  try {
    await axiosClient.get('/sanctum/csrf-cookie');
    return true;
  } catch (error) {
    console.error('Failed to get CSRF token:', error);
    return false;
  }
};

// Helper to initialize session
export const initializeSession = async () => {
  try {
    // Only call this if you're using session-based auth
    // If using JWT, you don't need this
    await getCsrfToken();

    const response = await axiosClient.get('/cart');
    return response.data;
  } catch (error) {
    console.error('Failed to initialize session:', error);
    throw error;
  }
};

export default axiosClient;

// import axios from "axios";
// import store from "./store";
// import router from "./router/index.js";

// const axiosClient = axios.create({
//   baseURL: `${import.meta.env.VITE_API_BASE_URL}/api`,
//   headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'X-Requested-With': 'XMLHttpRequest'
//   },
//   withCredentials: true, // CRITICAL: This ensures cookies (sessions) are sent with requests
//   withXSRFToken: true
// });

// // Request interceptor
// axiosClient.interceptors.request.use(config => {
//   // Add auth token if user is logged in
//   const token =  store.state.user?.token;
//   if (token) {
//     config.headers.Authorization = `Bearer ${token}`;
//   }

//   // Add CSRF token for Laravel (important for session security)
//   const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
//   if (csrfToken) {
//     config.headers['X-CSRF-TOKEN'] = csrfToken;
//   }

//   return config;
// }, error => {
//   return Promise.reject(error);
// });

// // Response interceptor
// axiosClient.interceptors.response.use(response => {
//   return response;
// }, error => {
//   if (error.response?.status === 401) {
//     // Clear auth state
//     store.commit('setToken', null, { root: true });
//     store.commit('setUser', null, { root: true });
//     store.commit('CLEAR_AUTH', null, { root: true });


//     // Redirect to login
//     router.push({ name: 'login' });
//   }

//   // Handle 419 (CSRF token mismatch) - common with sessions
//   if (error.response?.status === 419) {
//     console.error('CSRF token mismatch - refreshing page');
//     // You might want to refresh the CSRF token here
//     window.location.reload();
//   }

//   return Promise.reject(error);
// });

// // Helper function to get CSRF cookie (for Laravel Sanctum)
// export const getCsrfToken = async () => {
//   try {
//     await axiosClient.get('/sanctum/csrf-cookie');
//     return true;
//   } catch (error) {
//     console.error('Failed to get CSRF token:', error);
//     return false;
//   }
// };

// // Helper to initialize session
// export const initializeSession = async () => {
//   try {
//     // First, ensure we have a CSRF token
//     await getCsrfToken();

//     // Then, try to get or create guest cart
//     const response = await axiosClient.get('/cart');
//     return response.data;
//   } catch (error) {
//     console.error('Failed to initialize session:', error);
//     throw error;
//   }
// };

// export default axiosClient;
