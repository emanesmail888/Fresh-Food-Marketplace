import {createStore} from "vuex";
import state from './state'
import * as actions from './actions'
import * as mutations from './mutations'
import getters from './getters';import createPersistedState from 'vuex-persistedstate';
import settings from './modules/settings';
import services from './modules/services';
import orders from './modules/orders';
import contact from './modules/contact';
import dashboard from './modules/dashboard';
import product from './modules/product';
import reviews from "./modules/reviews";
import users from "./modules/users";
import wishlist from "./modules/wishlist";

const store = createStore({
  state,
  getters,
  actions,
  mutations,
  modules: {
    settings,services,orders,contact,dashboard,product,reviews,users,wishlist

  },
  plugins: [
    createPersistedState({
      paths: ['cart.items', 'user.token', 'user.data']

    })
  ]


//   plugins: [createPersistedState()],
//   paths: ['cart.items','user.token', 'user.data'] // Persist only cart and user auth info,
});

// Initialize cart from backup and fetch fresh data
const initCart = async () => {
  // First load from backup for immediate display
  store.dispatch('initializeCartFromBackup');

  // Then fetch fresh data from server
  setTimeout(() => {
    store.dispatch('fetchCart').catch(err => {
      console.error('Failed to initialize cart:', err);
    });
  }, 10);
};

initCart();

export default store

