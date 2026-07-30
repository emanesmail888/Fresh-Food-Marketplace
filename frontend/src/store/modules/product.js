// store/modules/product.js
import axiosClient from "../../axios";

export default {
    namespaced: true,

    state: {
        product: null,
        relatedProducts: [],
        loading: false,
        error: null
    },

    mutations: {
        SET_PRODUCT(state, product) {
            state.product = product;
        },
        SET_RELATED_PRODUCTS(state, products) {
            state.relatedProducts = products;
        },
        SET_LOADING(state, loading) {
            state.loading = loading;
        },
        SET_ERROR(state, error) {
            state.error = error;
        }
    },

    actions: {
        async fetchProductBySlug({ commit }, slug) {
            try {
                const response = await axiosClient.get(`/product/${slug}`);
                commit('SET_PRODUCT', response.data);
                return response.data;
            } catch (error) {
                console.error('Error fetching product:', error);
                throw error;
            }
        },

        /**
         * IMPORTANT: This uses QUERY PARAMETERS (?) NOT route parameters (/)
         * URL: /api/product/related?category_id=2&product_id=3&limit=5
         */
        async fetchRelatedProducts({ commit }, { categoryId, productId, limit = 5 }) {
            if (!categoryId || !productId) {
                // console.warn('Missing category_id or product_id for related products');
                commit('SET_RELATED_PRODUCTS', []);
                return [];
            }

            try {
                // console.log('Fetching related products with query params:', {
                //     url: '/products/related',
                //     params: {
                //         category_id: categoryId,
                //         product_id: productId,
                //         limit: limit
                //     }
                // });

                const response = await axiosClient.get('/products/related', {
                    params: {
                        category_id: categoryId,
                        product_id: productId,
                        limit: limit
                    }
                });

                // console.log('Related products response:', response.data);
                commit('SET_RELATED_PRODUCTS', response.data);
                return response.data;
            } catch (error) {
                console.error('Error fetching related products:', error);
                commit('SET_RELATED_PRODUCTS', []);
                return [];
            }
        }
    }
};
