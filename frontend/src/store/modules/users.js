// store/modules/user.js
import axiosClient from '../../axios';

export default {
    namespaced: true,

    state: {
        profile: null,
        orders: [],
        reviews: [],
        // wishlist: [],
        address: null,
        loading: false
    },

    mutations: {
        SET_PROFILE(state, profile) {
            state.profile = profile;
        },
        SET_ORDERS(state, orders) {
            state.orders = orders;
        },
        SET_REVIEWS(state, reviews) {
            state.reviews = reviews;
        },
        SET_WISHLIST(state, wishlist) {
            state.wishlist = wishlist;
        },
        SET_ADDRESS(state, address) {
            state.address = address;
        },
        SET_LOADING(state, loading) {
            state.loading = loading;
        }
    },

    actions: {
        async fetchProfile({ commit }) {
            try {
                const response = await axiosClient.get('/user/profile');
                commit('SET_PROFILE', response.data);
                return response.data;
            } catch (error) {
                console.error('Error fetching profile:', error);
                throw error;
            }
        },

        async updateProfile({ commit }, data) {
            try {
                const response = await axiosClient.put('/user/profile', data);
                commit('SET_PROFILE', response.data);
                return response.data;
            } catch (error) {
                console.error('Error updating profile:', error);
                throw error;
            }
        },

        async fetchOrders({ commit }, { page = 1, perPage = 10 } = {}) {
            try {
                const response = await axiosClient.get('/user/orders', {
                    params: { page, per_page: perPage }
                });

                // ✅ Return the full response with pagination
                return {
                    data: response.data.data || [],
                    current_page: response.data.current_page || 1,
                    last_page: response.data.last_page || 1,
                    per_page: response.data.per_page || 10,
                    total: response.data.total || 0
                };
            } catch (error) {
                console.error('Error fetching orders:', error);
                throw error;
            }
        },

        async fetchReviews({ commit }, { page = 1, perPage = 10 } = {}) {
            try {
                const response = await axiosClient.get('/user/reviews', {
                    params: { page, per_page: perPage }
                });

                return {
                    data: response.data.data || [],
                    current_page: response.data.current_page || 1,
                    last_page: response.data.last_page || 1,
                    per_page: response.data.per_page || 10,
                    total: response.data.total || 0
                };
            } catch (error) {
                console.error('Error fetching reviews:', error);
                throw error;
            }
        },

        // async fetchWishlist({ commit }) {
        //     try {
        //         const response = await axiosClient.get('/user/wishlist');
        //         commit('SET_WISHLIST', response.data);
        //         return response.data;
        //     } catch (error) {
        //         console.error('Error fetching wishlist:', error);
        //         throw error;
        //     }
        // },

        async fetchAddress({ commit }) {
            try {
                const response = await axiosClient.get('/user/address');
                commit('SET_ADDRESS', response.data);
                return response.data;
            } catch (error) {
                console.error('Error fetching address:', error);
                throw error;
            }
        },

        async updateAddress({ commit }, data) {
            try {
                const response = await axiosClient.put('/user/address', data);
                commit('SET_ADDRESS', response.data);
                return response.data;
            } catch (error) {
                console.error('Error updating address:', error);
                throw error;
            }
        },

        async changePassword({ commit }, data) {
            try {
                const response = await axiosClient.post('/user/change-password', data);
                return response.data;
            } catch (error) {
                console.error('Error changing password:', error);
                throw error;
            }
        }
    }
};
