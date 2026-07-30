import { createApp } from 'vue'
import './index.css'
// import './style.css'
import App from './App.vue'
import store  from './store';
import router from './router';
import Toast from 'vue-toastification'
import 'vue-toastification/dist/index.css'
import 'aos/dist/aos.css'
createApp(App)
.use(store)
.use(router)
.use(Toast, {
  position: 'top-center',
  timeout: 3000,
  closeOnClick: true,
  pauseOnFocusLoss: true,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  closeButton: 'button',
  icon: true,
  rtl: true
})
.mount('#app') ;
window.addEventListener('storage', (e) => {
  if (e.key === 'cart') {
    // Cart was updated in another tab, refresh
    store.dispatch('fetchCart').catch(console.error);
  }
});
