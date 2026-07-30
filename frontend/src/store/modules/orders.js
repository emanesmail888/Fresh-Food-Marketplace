import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const state = {
  orders: {
    data: [],
    loading: false,
    links: [],
    total: 0,
    from: 0,
    to: 0,
    meta: {}
  },

   recentOrders: {
    data: [],
    loading: false
  },

  order:{
    currentOrder: null,
    orderDetails: null,
   orderLoading: false,
    OrderError: false
    },

checkoutLoading: false,
checkoutError: null,
checkoutSummary: null,
paymentIntent: null,
verificationStatus: null,
discount: null,
//   currentOrder: null,
//   orderLoading: false,
};



const getters = {
  orders: (state) => state.orders,
//   currentOrder: (state) => state.currentOrder,
//   orderLoading: (state) => state.orderLoading,

  currentOrder: (state) => state.order.currentOrder,
  orderDetails: (state) => state.order?.orderDetails,
  orderLoading: (state) => state.order?.orderLoading || false,
  orderError: (state) => state.order?.error || null,

  checkoutLoading: state => state.checkoutLoading,
  checkoutError: state => state.checkoutError,
  currentOrder: state => state.order.currentOrder,
  checkoutSummary: state => state.checkoutSummary,
  paymentIntent: state => state.paymentIntent,
  verificationStatus: state => state.verificationStatus,










};

const mutations = {

  SET_ORDERS(state, payload) {
    // The payload contains the pagination data
    state.orders = {
      ...state.orders,
      data: payload.data || [],
      links: payload.links || [],
      total: payload.total || 0,
      from: payload.from || 0,
      to: payload.to || 0,
      meta: {
        current_page: payload.current_page,
        last_page: payload.last_page,
        per_page: payload.per_page,
        total: payload.total,
      },
      loading: false,
    };
  },

  SET_ORDERS_LOADING(state, loading) {
    state.orders.loading = loading;
  },

  SET_CURRENT_ORDER(state, order) {
    state.order.currentOrder = order;
  },
  SET_ORDER_LOADING(state, loading) {
    state.order.orderLoading = loading;
  },
  CLEAR_CURRENT_ORDER(state) {
    state.order.currentOrder = null;
  },


   SET_RECENT_ORDERS(state, orders) {
    state.recentOrders = {
      data: orders || [],
      loading: false
    }
  },
  SET_RECENT_ORDERS_LOADING(state, loading) {
    state.recentOrders.loading = loading
  },


 SET_CHECKOUT_LOADING (state, isLoading)  {
    state.checkoutLoading = isLoading;
},

 SET_CHECKOUT_ERROR  (state, error)  {
    state.checkoutError = error;
},

 CLEAR_CHECKOUT_ERROR (state)  {
    state.checkoutError = null;
},



 SET_CHECKOUT_SUMMARY(state, summary)  {
    state.checkoutSummary = summary;
},

 SET_PAYMENT_INTENT (state, intent)  {
    state.paymentIntent = intent;
},

 SET_VERIFICATION_STATUS (state, status)  {
    state.verificationStatus = status;
},

 RESET_CHECKOUT_STATE (state)  {
    state.checkoutLoading = false;
    state.checkoutError = null;
    state.order.currentOrder = null;
    state.checkoutSummary = null;
    state.paymentIntent = null;
    state.verificationStatus = null;
},


 SET_ORDER_LOADING(state, status)  {
    state.order.orderLoading = status;
},

 SET_ORDER_ERROR(state, error)  {
    state.order.orderError = error;
},

 CLEAR_ORDER_ERROR (state)  {
    state.order.orderError = null;
},

//  SET_CURRENT_ORDER(state, order)  {
//     state.order.currentOrder = order;
// },

 SET_ORDER_DETAILS(state, order) {
    state.order.orderDetails = order;
},

 CLEAR_CURRENT_ORDER (state) {
    state.order.currentOrder = null;
},

 CLEAR_ORDER_DETAILS (state) {
    state.order.orderDetails = null;
},

 UPDATE_ORDER_STATUS  (state, {
    status
})  {
    if (state.order.currentOrder) {
        state.order.currentOrder.status = status;
    }
    if (state.order.orderDetails) {
        state.order.orderDetails.status = status;
    }
},

 UPDATE_PAYMENT_STATUS (state, {
    payment_status
}) {
    if (state.order.currentOrder) {
        state.order.currentOrder.payment_status = payment_status;
    }
    if (state.order.orderDetails) {
        state.order.orderDetails.payment_status = payment_status;
    }
},
SET_DISCOUNT(state, discount) {
    state.discount = discount;
  }
};




const actions = {

  async getOrders({ commit, state }, payload) {
    commit('SET_ORDERS_LOADING', true);

    try {
      const params = {
        search: payload.search || '',
        per_page: payload.per_page || 10,
        sort_field: payload.sort_field || 'created_at',
        sort_direction: payload.sort_direction || 'desc',
        status: payload.status || '',
      };

      const url = payload.url || '/orders';
      const response = await axiosClient.get(url, { params });

      // The response data is { success: true, data: { ...pagination, data: [...] } }
      if (response.data.success) {
        commit('SET_ORDERS', response.data.data);
      } else {
        commit('SET_ORDERS', { data: [], links: [], total: 0 });
      }

      return response.data;
    } catch (error) {
      console.error('Failed to fetch orders:', error);
      commit('SET_ORDERS', { data: [], links: [], total: 0 });
      throw error;
    } finally {
      commit('SET_ORDERS_LOADING', false);
    }
  },

  async getOrderByAdmin({ commit }, orderNumber) {
    commit('SET_ORDER_LOADING', true);

    try {
      const response = await axiosClient.get(`/orders/${orderNumber}/show`);
      commit('SET_CURRENT_ORDER', response.data);
      return response.data;
    } catch (error) {
      console.error('Failed to fetch order:', error);
      throw error;
    } finally {
      commit('SET_ORDER_LOADING', false);
    }
  },

   async updateOrderStatus({ commit }, { orderNumber, status }) {
    try {
      const response = await axiosClient.put(`/orders/${orderNumber}/status`, { status });
      return response.data;
    } catch (error) {
      console.error('Failed to update order status:', error);
      throw error;
    }
  },

   async getRecentOrders({ commit }) {
    commit('SET_RECENT_ORDERS_LOADING', true)

    try {
      const response = await axiosClient.get('/orders/recent')


      if (response.data.success) {
        // Check if data is an array or has data property
        let ordersData = []
        if (Array.isArray(response.data.data)) {
          ordersData = response.data.data
        } else if (response.data.data && Array.isArray(response.data.data.data)) {
          ordersData = response.data.data.data
        } else {
          ordersData = []
        }

        commit('SET_RECENT_ORDERS', ordersData)
      } else {
        commit('SET_RECENT_ORDERS', [])
      }

      return response.data
    } catch (error) {
      console.error('❌ Failed to fetch recent orders:', error)
      commit('SET_RECENT_ORDERS', [])
      throw error
    } finally {
      commit('SET_RECENT_ORDERS_LOADING', false)
    }
  }
,

  async getRefundStatus({ commit }, orderNumber) {
    try {
      const response = await axiosClient.get(`/orders/${orderNumber}/refund-status`);
      return response.data;
    } catch (error) {
      console.error('Failed to get refund status:', error);
      throw error;
    }
  },



async processCheckout({ commit }, checkoutData)  {
    commit('SET_CHECKOUT_LOADING', true);
    //   commit('CLEAR_CHECKOUT_ERROR');


    try {
        const response = await axiosClient.post('/checkout/process', checkoutData);

        // Store the order in state
        if (response.data.order) {
            commit('SET_CURRENT_ORDER', response.data.order);
        }

        // IMPORTANT: If checkout was successful, clear the cart in store
        if (response.data.cart && response.data.cart.items) {
            // Update cart module state
            commit('SET_CART', response.data.cart.items, { root: true });
        } else {
            // If no cart data returned, assume cart is empty
            commit('SET_CART', [], { root: true });
        }


        // Store payment intent if exists (for direct Stripe payments)
        if (response.data.payment_intent_client_secret) {
            commit('SET_PAYMENT_INTENT', {
                clientSecret: response.data.payment_intent_client_secret,
                ...response.data
            });
        }

        return response.data;
    } catch (error) {
        const errorData = {
            message: error.response?.data?.message || 'Checkout failed',
            errors: error.response?.data?.errors || {},
            error: error.response?.data?.error, // For Stripe errors
            status: error.response?.status
        };

        commit('SET_CHECKOUT_ERROR', errorData);
        throw error;
    } finally {
        commit('SET_CHECKOUT_LOADING', false);
    }
},

/**
 * Fetch checkout summary (cart items and totals)
 */
 async fetchCheckoutSummary ({ commit })  {
    commit('SET_CHECKOUT_LOADING', true);
    commit('CLEAR_CHECKOUT_ERROR');


    try {
        const response = await axiosClient.get('/checkout/summary');
        commit('SET_CHECKOUT_SUMMARY', response.data);
        return response.data;
    } catch (error) {
        const errorData = {
            message: error.response?.data?.message || 'Failed to fetch checkout summary',
            errors: error.response?.data?.errors || {},
            status: error.response?.status
        };
        commit('SET_CHECKOUT_ERROR', errorData);

        throw error;
    } finally {
        commit('SET_CHECKOUT_LOADING', false);
    }
},

/**
 * Verify Stripe session after return from checkout
 */
  async verifyStripeSession({ commit }, sessionId)  {
    commit('SET_CHECKOUT_LOADING', true);

    try {
        const response = await axiosClient.get(`/checkout/verify-session/${sessionId}`);
        commit('SET_VERIFICATION_STATUS', response.data.success);

        if (response.data.order) {
            commit('SET_CURRENT_ORDER', response.data.order);
        }

        return response.data;
    } catch (error) {
        commit('SET_CHECKOUT_ERROR', error.response?.data?.message || 'Failed to verify payment');
        throw error;
    } finally {
        commit('SET_CHECKOUT_LOADING', false);
    }
},


async applyDiscountCode({ commit }, { code, subtotal }) {
    try {
      const response = await axiosClient.post('/checkout/apply-discount', {
        code: code,
        subtotal: subtotal
      });

      if (response.data.valid) {
        commit('SET_DISCOUNT', response.data.discount);
        return response.data;
      } else {
        throw new Error(response.data.message || 'Invalid coupon');
      }
    } catch (error) {
      throw error;
    }
  },

/**
 * Reset checkout state (useful when leaving checkout page)
 */
 async resetCheckoutState ({ commit }) {
    commit('RESET_CHECKOUT_STATE');
},



 async fetchOrderByNumber ({ commit }, orderNumber)  {
    commit('SET_ORDER_LOADING', true);
    commit('CLEAR_ORDER_ERROR');

    try {
        const response = await axiosClient.get(`/orders/${orderNumber}`);

        // Store the order details
        commit('SET_ORDER_DETAILS', response.data);

        return response.data;
    } catch (error) {
        const errorMessage = error.response?.data?.message || 'Failed to fetch order';
        commit('SET_ORDER_ERROR', errorMessage);
        throw error;
    } finally {
        commit('SET_ORDER_LOADING', false);
    }
},

/**
 * Fetch current user's orders list
 */
async  fetchUserOrders({ commit }, params = {})  {
    commit('SET_ORDER_LOADING', true);
    commit('CLEAR_ORDER_ERROR');

    try {
        const response = await axiosClient.get('/orders', { params });
        return response.data;
    } catch (error) {
        const errorMessage = error.response?.data?.message || 'Failed to fetch orders';
        commit('SET_ORDER_ERROR', errorMessage);
        throw error;
    } finally {
        commit('SET_ORDER_LOADING', false);
    }
},

/**
 * Set current order (from checkout)
 */
async setCurrentOrder ({ commit }, order)  {
    commit('SET_CURRENT_ORDER', order);
},

/**
 * Clear current order
 */
async clearCurrentOrder({ commit })  {
    commit('CLEAR_CURRENT_ORDER');
},

/**
 * Clear order details
 */
 async clearOrderDetails ({ commit })  {
    commit('CLEAR_ORDER_DETAILS');
},

/**
 * Cancel order
 */
async cancelOrder({ commit }, { orderNumber, reason })  {
    commit('SET_ORDER_LOADING', true);
    commit('CLEAR_ORDER_ERROR');

    try {
        const response = await axiosClient.post(`/orders/${orderNumber}/cancel`, { reason });

        // Update the order status in state
        commit('UPDATE_ORDER_STATUS', { status: 'cancelled' });

        return response.data;
    } catch (error) {
        const errorMessage = error.response?.data?.message || 'Failed to cancel order';
        commit('SET_ORDER_ERROR', errorMessage);
        throw error;
    } finally {
        commit('SET_ORDER_LOADING', false);
    }
},

/**
 * Track order
 */
async trackOrder({ commit }, orderNumber)  {
    commit('SET_ORDER_LOADING', true);
    commit('CLEAR_ORDER_ERROR');

    try {
        const response = await axiosClient.get(`/orders/${orderNumber}/track`);
        return response.data;
    } catch (error) {
        const errorMessage = error.response?.data?.message || 'Failed to track order';
        commit('SET_ORDER_ERROR', errorMessage);
        throw error;
    } finally {
        commit('SET_ORDER_LOADING', false);
    }
},

/**
 * Reorder (add previous order items to cart)
*/
  async reorder ({ commit }, orderNumber)  {
    commit('SET_ORDER_LOADING', true);
    commit('CLEAR_ORDER_ERROR');

    try {
        const response = await axiosClient.post(`/orders/${orderNumber}/reorder`);

        // Update cart in store
        if (response.data.cart) {
            commit('SET_CART', response.data.cart.items, { root: true });
        }

        return response.data;
    } catch (error) {
        const errorMessage = error.response?.data?.message || 'Failed to reorder';
        commit('SET_ORDER_ERROR', errorMessage);
        throw error;
    } finally {
        commit('SET_ORDER_LOADING', false);
    }
},

  clearCurrentOrder({ commit }) {
    commit('CLEAR_CURRENT_ORDER');
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
