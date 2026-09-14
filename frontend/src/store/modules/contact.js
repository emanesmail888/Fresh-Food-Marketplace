import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const state = {
  contacts: {
    data: [],
    loading: false,
    links: [],
    total: 0,
    from: 0,
    to: 0,
    meta: {}
  },
  currentContact: null,
  contactLoading: false,
  stats: null,
  statsLoading: false,
};

const getters = {
  contacts: (state) => state.contacts,
  currentContact: (state) => state.currentContact,
  contactLoading: (state) => state.contactLoading,
  stats: (state) => state.stats,
  statsLoading: (state) => state.statsLoading,
};

const mutations = {
  SET_CONTACTS(state, payload) {
    state.contacts = {
      ...state.contacts,
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
  SET_CONTACTS_LOADING(state, loading) {
    state.contacts.loading = loading;
  },
  SET_CURRENT_CONTACT(state, contact) {
    state.currentContact = contact;
  },
  SET_CONTACT_LOADING(state, loading) {
    state.contactLoading = loading;
  },
  SET_STATS(state, stats) {
    state.stats = stats;
  },
  SET_STATS_LOADING(state, loading) {
    state.statsLoading = loading;
  },
  CLEAR_CURRENT_CONTACT(state) {
    state.currentContact = null;
  },
};

const actions = {
  async getContacts({ commit }, payload = {}) {
    commit('SET_CONTACTS_LOADING', true);

    try {
      const params = {
        search: payload.search || '',
        per_page: payload.per_page || 10,
        sort_field: payload.sort_field || 'created_at',
        sort_direction: payload.sort_direction || 'desc',
        status: payload.status || '',
      };
      if (payload.status && payload.status !== 'all' && payload.status !== '') {
        params.status = payload.status;
      }
      const url = payload.url || '/contacts';
      const response = await axiosClient.get(url, { params });

      if (response.data.success) {
        commit('SET_CONTACTS', response.data.data);
      } else {
        commit('SET_CONTACTS', { data: [], links: [], total: 0 });
      }

      return response.data;
    } catch (error) {
      console.error('Failed to fetch contacts:', error);
      commit('SET_CONTACTS', { data: [], links: [], total: 0 });
      throw error;
    } finally {
      commit('SET_CONTACTS_LOADING', false);
    }
  },

  async submitContact({ commit }, formData) {
    try {
      const response = await axiosClient.post('/contact', formData);
      return response.data;
    } catch (error) {
      console.error('Failed to submit contact:', error);
      throw error;
    }
  },

  async getContact({ commit }, id) {
    commit('SET_CONTACT_LOADING', true);

    try {
      const response = await axiosClient.get(`/contacts/${id}`);
      commit('SET_CURRENT_CONTACT', response.data.data);
      return response.data;
    } catch (error) {
      console.error('Failed to fetch contact:', error);
      throw error;
    } finally {
      commit('SET_CONTACT_LOADING', false);
    }
  },

  async updateContact({ commit }, { id, data }) {
    try {
      const response = await axiosClient.put(`/contacts/${id}`, data);
      return response.data;
    } catch (error) {
      console.error('Failed to update contact:', error);
      throw error;
    }
  },

  async deleteContact({ commit }, id) {
    try {
      const response = await axiosClient.delete(`/contacts/${id}`);
      return response.data;
    } catch (error) {
      console.error('Failed to delete contact:', error);
      throw error;
    }
  },

  async bulkDeleteContacts({ commit }, ids) {
    try {
      const response = await axiosClient.post('/contacts/bulk-delete', { ids });
      return response.data;
    } catch (error) {
      console.error('Failed to delete contacts:', error);
      throw error;
    }
  },

  async getContactStats({ commit }) {
    commit('SET_STATS_LOADING', true);

    try {
      const response = await axiosClient.get('/contacts/stats');
      if (response.data.success) {
        commit('SET_STATS', response.data.data);
      }
      return response.data;
    } catch (error) {
      console.error('Failed to fetch contact stats:', error);
      throw error;
    } finally {
      commit('SET_STATS_LOADING', false);
    }
  },

  clearCurrentContact({ commit }) {
    commit('CLEAR_CURRENT_CONTACT');
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
