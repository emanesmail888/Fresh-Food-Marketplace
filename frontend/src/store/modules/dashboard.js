import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const state = {
  dashboardStats: null,
  loading: false,
}

const getters = {
  dashboardStats: (state) => state.dashboardStats,
}

const mutations = {
  SET_DASHBOARD_STATS(state, stats) {
    state.dashboardStats = stats
  },
  SET_LOADING(state, loading) {
    state.loading = loading
  },
}

const actions = {
  async getDashboardStats({ commit }) {
    commit('SET_LOADING', true)

    try {
      const response = await axiosClient.get('/dashboard')

      if (response.data.success) {
        commit('SET_DASHBOARD_STATS', response.data.data)
        return response.data
      }
      return { success: false, data: null }
    } catch (error) {
      console.error('Failed to fetch dashboard stats:', error)
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
