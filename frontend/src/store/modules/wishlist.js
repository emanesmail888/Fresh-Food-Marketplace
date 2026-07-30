import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

// const state = {
//     items: [],
//     loading: false,
//     error: null
// };

// const getters = {
//      wishlistItems: (state) => state.items || [],
//     wishlistCount: (state) => state.items.length,
//     // isInWishlist: (state) => (productId) => {
//     //     return state.items.some(item => item.id === productId);
//     // }
//     isInWishlist: (state) => (productId) => {
//         if (!Array.isArray(state.items)) return false;
//         return state.items.some(item => item.id === productId || item.product_id === productId);
//     },
// };

// const mutations = {
//     SET_WISHLIST_ITEMS(state, items) {
//         state.items = items;
//     },
//     ADD_TO_WISHLIST(state, product) {
//         if (!state.items.some(item => item.id === product.id)) {
//             state.items.push(product);
//         }
//     },
//     REMOVE_FROM_WISHLIST(state, productId) {
//         state.items = state.items.filter(item => item.id !== productId);
//     },
//     SET_LOADING(state, loading) {
//         state.loading = loading;
//     },
//     SET_ERROR(state, error) {
//         state.error = error;
//     }
// };

// const actions = {
//     async fetchWishlist({ commit }) {
//         commit('SET_LOADING', true);
//         try {
//             const response = await axiosClient.get('/wishlist');
//             commit('SET_WISHLIST_ITEMS', response.data || []);
//             return response.data;
//         } catch (error) {
//             commit('SET_ERROR', error.message);
//             throw error;
//         } finally {
//             commit('SET_LOADING', false);
//         }
//     },

//     async addToWishlist({ commit }, productId) {
//         try {
//             const response = await axiosClient.post('/wishlist', { product_id: productId });
//             // Fetch the product details to add to wishlist
//             const productResponse = await axiosClient.get(`/products/${productId}`);
//             commit('ADD_TO_WISHLIST', productResponse.data.data);
//             return response.data;
//         } catch (error) {
//             if (error.response?.status === 409) {
//                 throw new Error('Product already in wishlist');
//             }
//             throw error;
//         }
//     },

//     async removeFromWishlist({ commit }, productId) {
//         try {
//             const response = await axiosClient.delete(`/wishlist/${productId}`);
//             commit('REMOVE_FROM_WISHLIST', productId);
//             return response.data;
//         } catch (error) {
//             throw error;
//         }
//     },

//     async toggleWishlist({ commit }, productId) {
//     try {
//         const response = await axiosClient.post('/wishlist/toggle', {
//             product_id: productId
//         });

//         if (response.data.action === 'added') {
//             // Fetch product details using the wishlist endpoint
//             const productResponse = await axiosClient.get(`/wishlist/product/${productId}`);
//             commit('ADD_TO_WISHLIST', productResponse.data.data);
//         } else {
//             commit('REMOVE_FROM_WISHLIST', productId);
//         }

//         return response.data;
//     } catch (error) {
//         throw error;
//     }
// },

//     async checkWishlist({ commit, getters }, productId) {
//         try {
//             const response = await axiosClient.get(`/wishlist/check/${productId}`);
//             return response.data.in_wishlist;
//         } catch (error) {
//             return false;
//         }
//     }
// };

// export default {
//     namespaced: true,
//     state,
//     getters,
//     mutations,
//     actions
// };
const state = {
    items: [], // Make sure this is initialized as an empty array
    loading: false,
    error: null,
    total: 0
};

const getters = {
    wishlistItems: (state) => state.items || [], // Fallback to empty array
    wishlistCount: (state) => Array.isArray(state.items) ? state.items.length : 0,
    isInWishlist: (state) => (productId) => {
        if (!Array.isArray(state.items)) return false;
        return state.items.some(item => item.id === productId || item.product_id === productId);
    },
    isLoading: (state) => state.loading,
    wishlistError: (state) => state.error
};

const mutations = {
    SET_WISHLIST_ITEMS(state, items) {
        // Ensure items is always an array
        state.items = Array.isArray(items) ? items : [];
    },
    ADD_TO_WISHLIST(state, product) {
        // Ensure state.items is an array
        if (!Array.isArray(state.items)) {
            state.items = [];
        }
        // Check if product already exists
        const exists = state.items.some(item =>
            item.id === product.id || item.product_id === product.id
        );
        if (!exists) {
            state.items.push(product);
        }
    },
    REMOVE_FROM_WISHLIST(state, productId) {
        // Ensure state.items is an array before filtering
        if (!Array.isArray(state.items)) {
            state.items = [];
            return;
        }
        state.items = state.items.filter(item => {
            // Handle both nested and flat structures
            const itemId = item.product_id || item.id;
            return itemId !== productId;
        });
    },
    SET_LOADING(state, loading) {
        state.loading = loading;
    },
    SET_ERROR(state, error) {
        state.error = error;
    },
    CLEAR_WISHLIST(state) {
        state.items = [];
    }
};

const actions = {
    async fetchWishlist({ commit }) {
        commit('SET_LOADING', true);
        commit('SET_ERROR', null);

        try {
            const response = await axiosClient.get('/wishlist');

            // Extract data from response
            let wishlistData = [];
            if (response.data && response.data.data) {
                wishlistData = response.data.data;
            } else if (Array.isArray(response.data)) {
                wishlistData = response.data;
            }

            commit('SET_WISHLIST_ITEMS', wishlistData);
            return response.data;
        } catch (error) {
            console.error('Fetch wishlist error:', error);
            commit('SET_ERROR', error.response?.data?.message || error.message);
            throw error;
        } finally {
            commit('SET_LOADING', false);
        }
    },

    async addToWishlist({ commit }, productId) {
        try {
            const response = await axiosClient.post('/wishlist', { product_id: productId });

            // If the response includes the product data, add it
            if (response.data && response.data.product) {
                commit('ADD_TO_WISHLIST', response.data.product);
            } else {
                // Otherwise, fetch the product details
                const productResponse = await axiosClient.get(`/products/${productId}`);
                if (productResponse.data && productResponse.data.data) {
                    commit('ADD_TO_WISHLIST', productResponse.data.data);
                }
            }

            return response.data;
        } catch (error) {
            console.error('Add to wishlist error:', error);
            throw error;
        }
    },

    async removeFromWishlist({ commit }, productId) {
        try {
            const response = await axiosClient.delete(`/wishlist/${productId}`);
            commit('REMOVE_FROM_WISHLIST', productId);
            return response.data;
        } catch (error) {
            console.error('Remove from wishlist error:', error);
            throw error;
        }
    },

    // async toggleWishlist({ commit, getters }, { productId, productData = null }) {
    //     try {
    //         const response = await axiosClient.post('/wishlist/toggle', { product_id: productId });

    //         if (response.data.action === 'added') {
    //             if (productData) {
    //                 commit('ADD_TO_WISHLIST', productData);
    //             } else if (response.data.product) {
    //                 commit('ADD_TO_WISHLIST', response.data.product);
    //             } else {
    //                 // Fetch product details
    //                 const productResponse = await axiosClient.get(`/wishlist/product/${productId}`);
    //                 if (productResponse.data && productResponse.data.data) {
    //                     commit('ADD_TO_WISHLIST', productResponse.data.data);
    //                 }
    //             }
    //         } else {
    //             commit('REMOVE_FROM_WISHLIST', productId);
    //         }

    //         return response.data;
    //     } catch (error) {
    //         console.error('Toggle wishlist error:', error);
    //         throw error;
    //     }
    // },
        async toggleWishlist({ commit }, productId) {
        try {
            const response = await axiosClient.post('/wishlist/toggle', {
                product_id: productId
            });

            if (response.data.action === 'added') {
                // Fetch product details using the wishlist endpoint
                const productResponse = await axiosClient.get(`/wishlist/product/${productId}`);
                commit('ADD_TO_WISHLIST', productResponse.data.data);
            } else {
                commit('REMOVE_FROM_WISHLIST', productId);
            }

            return response.data;
        } catch (error) {
            throw error;
        }
    },
    async checkWishlist({ getters }, productId) {
        try {
            const response = await axiosClient.get(`/wishlist/check/${productId}`);
            return response.data.in_wishlist || false;
        } catch (error) {
            console.error('Check wishlist error:', error);
            return false;
        }
    },

    clearWishlist({ commit }) {
        commit('CLEAR_WISHLIST');
    }
};

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
};
