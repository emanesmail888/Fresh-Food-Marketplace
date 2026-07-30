import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

export default {
    namespaced: true,

    state: {
        reviews: [],
        userReview: null,
        stats: {
            average_rating: 0,
            total_reviews: 0,
            verified_count: 0,
            rating_distribution: {}
        },
        loading: false,
        pagination: {
            current_page: 1,
            last_page: 1,
            per_page: 10,
            total: 0
        },
        sort: 'latest'
    },

    mutations: {
        SET_REVIEWS(state, { reviews, pagination }) {
            state.reviews = reviews;
            state.pagination = pagination;
        },
        SET_USER_REVIEW(state, review) {
            state.userReview = review;
        },
        SET_STATS(state, stats) {
            state.stats = stats;
        },
        SET_LOADING(state, loading) {
            state.loading = loading;
        },
        SET_SORT(state, sort) {
            state.sort = sort;
        },
        ADD_REVIEW(state, review) {
            state.reviews.unshift(review);
            state.pagination.total++;
        },
        UPDATE_REVIEW(state, updatedReview) {
            const index = state.reviews.findIndex(r => r.id === updatedReview.id);
            if (index !== -1) {
                state.reviews[index] = updatedReview;
            }
            if (state.userReview && state.userReview.id === updatedReview.id) {
                state.userReview = updatedReview;
            }
        },
        DELETE_REVIEW(state, reviewId) {
            state.reviews = state.reviews.filter(r => r.id !== reviewId);
            state.pagination.total--;
            if (state.userReview && state.userReview.id === reviewId) {
                state.userReview = null;
            }
        }
    },

    actions: {
        async fetchReviews({ commit, state }, { productId, page = 1 }) {
            commit('SET_LOADING', true);
            try {
                const response = await axiosClient.get(`/products/${productId}/reviews`, {
                    params: {
                        page,
                        per_page: state.pagination.per_page,
                        sort: state.sort
                    }
                });

                commit('SET_REVIEWS', {
                    reviews: response.data.reviews.data,
                    pagination: {
                        current_page: response.data.reviews.current_page,
                        last_page: response.data.reviews.last_page,
                        per_page: response.data.reviews.per_page,
                        total: response.data.reviews.total
                    }
                });
                commit('SET_USER_REVIEW', response.data.user_review);
                commit('SET_STATS', response.data.stats);
            } catch (error) {
                console.error('Error fetching reviews:', error);
                throw error;
            } finally {
                commit('SET_LOADING', false);
            }
        },

        async submitReview({ commit }, { productId, reviewData }) {
            try {
                const response = await axiosClient.post(`/products/${productId}/reviews`, reviewData, {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                });
                commit('ADD_REVIEW', response.data.review);
                // Refresh stats
                await this.dispatch('reviews/fetchStats', productId);
                return response.data;
            } catch (error) {
                console.error('Error submitting review:', error);
                throw error;
            }
        },

        async updateReview({ commit }, { reviewId, reviewData }) {
            try {
                // استخدام POST مع _method PUT بدلاً من PUT مباشرة
                const response = await axiosClient.post(`/products/reviews/${reviewId}`, reviewData, {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                });
                commit('UPDATE_REVIEW', response.data.review);
                return response.data;
            } catch (error) {
                console.error('Error updating review:', error);
                throw error;
            }
        },

        async deleteReview({ commit }, reviewId) {
            try {
                await axiosClient.delete(`/products/reviews/${reviewId}`);
                commit('DELETE_REVIEW', reviewId);
            } catch (error) {
                console.error('Error deleting review:', error);
                throw error;
            }
        },

        async fetchStats({ commit }, productId) {
            try {
                const response = await axiosClient.get(`/products/${productId}/reviews/stats`);
                commit('SET_STATS', response.data);
            } catch (error) {
                console.error('Error fetching stats:', error);
            }
        },

        setSort({ commit, dispatch }, sort) {
            commit('SET_SORT', sort);
            dispatch('fetchReviews');
        }
    }
};
