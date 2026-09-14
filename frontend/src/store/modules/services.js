import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const state =  {
  services: {
    data: [],
    loading: false,
    current_page: 1,
    last_page: 1,
    total: null,
    from: null,
    to: null,
    links: [],
     page: 1,
    limit: null,
  }


}

const mutations = {
  setServices(state, services) {
    state.services = services;
  },
  setServicesLoading(state, loading) {
    state.services.loading = loading;
  }
}

const actions = {

  async getServices({ commit }, { url = null, search = '', per_page = 10, sort_field = 'created_at', sort_direction = 'desc' }) {
    commit('setServicesLoading', true);

    try {
      let requestUrl = url || '/services';
      const params = new URLSearchParams({
        search,
        per_page,
        sort_field,
        sort_direction
      });

      const separator = requestUrl.includes('?') ? '&' : '?';
      const response = await axiosClient.get(`${requestUrl}${separator}${params.toString()}`);

      commit('setServices', response.data);
      return response;
    } catch (error) {
      console.error(t('Failed to fetch services'), error);
      throw error;
    } finally {
      commit('setServicesLoading', false);
    }
  },

  async getService({ commit }, id) {
    try {
      const response = await axiosClient.get(`/services/${id}`);
      return response;
    } catch (error) {
      console.error(t('Failed to fetch service'), error);
      throw error;
    }
  },

  async createService({ commit }, serviceData) {
    try {
      const formData = new FormData();

      // Handle file upload
      if (serviceData.image instanceof File) {
        formData.append('image', serviceData.image);
      }

      // Add other fields
      formData.append('title', serviceData.title);
      if (serviceData.title_ar) formData.append('title_ar', serviceData.title_ar);
      formData.append('description', serviceData.description);
      if (serviceData.description_ar) formData.append('description_ar', serviceData.description_ar);

      const response = await axiosClient.post('/services', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      return response;
    } catch (error) {
      console.error(t('Failed to create service'), error);
      throw error;
    }
  },

  async updateService({ commit }, { id, serviceData }) {
    try {
      const formData = new FormData();

      // Add _method for PUT request
      formData.append('_method', 'PUT');

      // Handle file upload
      if (serviceData.image instanceof File) {
        formData.append('image', serviceData.image);
      }

      // Add other fields
      formData.append('title', serviceData.title);
      if (serviceData.title_ar) formData.append('title_ar', serviceData.title_ar);
      formData.append('description', serviceData.description);
      if (serviceData.description_ar) formData.append('description_ar', serviceData.description_ar);

      const response = await axiosClient.post(`/services/${id}`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      return response;
    } catch (error) {
      console.error(t('Failed to update service'), error);
      throw error;
    }
  },

  async deleteService({ commit }, id) {
    try {
      const response = await axiosClient.delete(`/services/${id}`);
      return response;
    } catch (error) {
      console.error(t('Failed to delete service'), error);
      throw error;
    }
  }
}

const getters = {
  services: state => state.services
}


export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
