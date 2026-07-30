import axiosClient from "../../axios";

import { useLanguage } from "../../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const state = {
  // All settings grouped by group
  allSettings: {},

  // Groups list
  groups: [],

  // Loading states
  loading: false,
  saving: false,

  // Active tab/group
  activeGroup: null,

  // Errors
  errors: {},

  // UI
  message: null,
  messageType: 'success',



  // Modal states
  showAddModal: false,
  showAddGroupModal: false,

  // New setting form
  newSetting: {
    name: '',
    group: '',
    type: 'text',
    value: '',
    file: null,
    preview: null
  },

  // New group form
  newGroup: {
    name: '',
    settings: []
  }
}

const mutations = {
  SET_ALL_SETTINGS(state, settings) {
    state.allSettings = settings
  },

  SET_GROUPS(state, groups) {
    state.groups = groups
  },

  ADD_GROUP(state, group) {
    state.groups.push(group)
    state.allSettings[group] = []
  },

  REMOVE_GROUP(state, group) {
    const index = state.groups.indexOf(group)
    if (index !== -1) {
      state.groups.splice(index, 1)
    }
    delete state.allSettings[group]
  },

  SET_LOADING(state, loading) {
    state.loading = loading
  },

  SET_SAVING(state, saving) {
    state.saving = saving
  },

  SET_ACTIVE_GROUP(state, group) {
    state.activeGroup = group
  },

  UPDATE_SETTING_VALUE(state, { group, name, value }) {
    if (state.allSettings[group]) {
      const index = state.allSettings[group].findIndex(s => s.name === name)
      if (index !== -1) {
        state.allSettings[group][index].value = value
      }
    }
  },

  UPDATE_SETTING_FILE(state, { group, name, file, preview }) {
    if (state.allSettings[group]) {
      const index = state.allSettings[group].findIndex(s => s.name === name)
      if (index !== -1) {
        state.allSettings[group][index].file = file
        state.allSettings[group][index].preview = preview
      }
    }
  },

  ADD_SETTING(state, { group, setting }) {
    if (!state.allSettings[group]) {
      state.allSettings[group] = []
    }
    state.allSettings[group].push(setting)
  },

  REMOVE_SETTING(state, { group, name }) {
    if (state.allSettings[group]) {
      const index = state.allSettings[group].findIndex(s => s.name === name)
      if (index !== -1) {
        state.allSettings[group].splice(index, 1)
      }
    }
  },

  SET_NEW_SETTING_FIELD(state, { field, value }) {
    state.newSetting[field] = value
  },

  RESET_NEW_SETTING(state) {
    state.newSetting = {
      name: '',
      group: state.activeGroup || '',
      type: 'text',
      value: '',
      file: null,
      preview: null
    }
  },

  SET_NEW_GROUP_FIELD(state, { field, value }) {
    state.newGroup[field] = value
  },

  RESET_NEW_GROUP(state) {
    state.newGroup = {
      name: '',
      settings: []
    }
  },

  SET_SHOW_ADD_MODAL(state, show) {
    state.showAddModal = show
  },

  SET_SHOW_ADD_GROUP_MODAL(state, show) {
    state.showAddGroupModal = show
  },

  SET_MESSAGE(state, { message, type }) {
  state.message = message
  state.messageType = type || 'success'

  // Auto clear after 3 seconds
  setTimeout(() => {
    state.message = null
  }, 3000)
},
  CLEAR_MESSAGE(state) {
    state.message = null
  },

  SET_ERRORS(state, errors) {
    state.errors = errors
  },

  CLEAR_ERRORS(state) {
    state.errors = {}
  },


UPDATE_MULTI_IMAGES(state, { group, name, files }) {
  if (state.allSettings[group]) {
    const setting = state.allSettings[group].find(s => s.name === name)
    if (setting) {
      setting.newFiles = [...(setting.newFiles || []), ...files]
      setting.previewFiles = setting.previewFiles || []

      files.forEach(file => {
        const reader = new FileReader()
        reader.onload = (e) => {
          setting.previewFiles.push(e.target.result)
        }
        reader.readAsDataURL(file)
      })
    }
  }
},

REMOVE_MULTI_IMAGE(state, { group, name, index }) {
  if (state.allSettings[group]) {
    const setting = state.allSettings[group].find(s => s.name === name)
    if (setting) {
      if (setting.value) {
        let images = typeof setting.value === 'string' ? JSON.parse(setting.value) : setting.value
        images.splice(index, 1)
        setting.value = JSON.stringify(images)
      }
      if (setting.previewFiles) {
        setting.previewFiles.splice(index, 1)
      }
    }
  }
}

}

const actions = {
  // Fetch all settings
  async fetchAllSettings({ commit }) {
    commit('SET_LOADING', true)

    try {
      // Fixed endpoint
      const response = await axiosClient.get('/settings')
      if (response.data.success) {
        commit('SET_ALL_SETTINGS', response.data.data)

        // Extract unique groups
        const groups = Object.keys(response.data.data)
        commit('SET_GROUPS', groups)

        // Set first group as active if none
        if (groups.length > 0 && !state.activeGroup) {
          commit('SET_ACTIVE_GROUP', groups[0])
        }
      }
      return response.data
    } catch (error) {
      commit('SET_MESSAGE', { message: 'Error loading settings', type: 'error' })
      console.error('Error fetching settings:', error)
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },

  // Fetch groups
  async fetchGroups({ commit }) {
    try {
      const response = await axiosClient.get('/settings/groups')
      if (response.data.success) {
        commit('SET_GROUPS', response.data.data)
      }
      return response.data
    } catch (error) {
      console.error('Error fetching groups:', error)
      throw error
    }
  },

  // Create new group
  async createGroup({ commit, dispatch }, groupName) {
    if (!groupName || !groupName.trim()) {
      commit('SET_MESSAGE', { message: t('Please enter a group name'), type: 'error' })
      return false
    }

    const validName = /^[a-zA-Z][a-zA-Z0-9_]*$/.test(groupName)
    if (!validName) {
      commit('SET_MESSAGE', {
        message: t('Group name must start with a letter and contain only letters, numbers, and underscores'),
        type: 'error'
      })
      return false
    }

    if (state.groups.includes(groupName)) {
      commit('SET_MESSAGE', { message: t('Group already exists'), type: 'error' })
      return false
    }

    // Add group locally
    commit('ADD_GROUP', groupName)
    commit('SET_ACTIVE_GROUP', groupName)
    commit('SET_MESSAGE', { message: t('group_created_successfully'), type: 'success' })

    return true
  },

  // Delete group
  async deleteGroup({ commit }, group) {
    if (!confirm(`Delete entire group "${group}" and all its settings? This action cannot be undone.`)) {
      return false
    }

    try {
      const response = await axiosClient.delete(`/settings/group/${group}`)
      if (response.data.success) {
        commit('REMOVE_GROUP', group)

        if (state.activeGroup === group) {
          const remainingGroups = state.groups.filter(g => g !== group)
          commit('SET_ACTIVE_GROUP', remainingGroups[0] || null)
        }

        commit('SET_MESSAGE', { message: t('group_deleted_successfully'), type: 'success' })
        return true
      }
    } catch (error) {
      commit('SET_MESSAGE', { message: t('group_delete_error'), type: 'error' })
      console.error('Error deleting group:', error)
      return false
    }
  },

  // Add new setting - FIXED VERSION
  async addSetting({ commit, state }) {
    const { name, group, type, value, file } = state.newSetting

    if (!name || !group) {
      commit('SET_MESSAGE', { message: t('Name and group are required'), type: 'error' })
      return false
    }

    const formData = new FormData()
    formData.append('name', name)
    formData.append('group', group)
    formData.append('type', type)

    if (type === 'text') {
      formData.append('value', value || '')
    } else if (file) {
      // FIXED: Don't validate file size here, let server handle it
      formData.append('file', file)
    } else {
      commit('SET_MESSAGE', { message: t('Please select a file'), type: 'error' })
      return false
    }

    try {
      // FIXED: Use correct endpoint
      const response = await axiosClient.post('/settings', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })

      if (response.data.success) {
        const newSetting = {
          id: response.data.data.id,
          name: name,
          value: type === 'text' ? value : response.data.data.value,
          type: type,
          raw_value: response.data.data.value
        }

        commit('ADD_SETTING', { group, setting: newSetting })
        commit('RESET_NEW_SETTING')
        commit('SET_SHOW_ADD_MODAL', false)
        commit('SET_MESSAGE', { message: t('Setting added successfully'), type: 'success' })

        return true
      }
    } catch (error) {
      console.error('Error adding setting:', error)
      if (error.response?.status === 422) {
        commit('SET_ERRORS', error.response.data.errors)
        const errorMessage = error.response.data.errors.file?.[0] || error.response.data.message || 'Validation error'
        commit('SET_MESSAGE', { message: errorMessage, type: 'error' })
      } else if (error.response?.status === 500) {
        commit('SET_MESSAGE', { message: t('Server error. Check file size limits.'), type: 'error' })
      } else {
        commit('SET_MESSAGE', { message: t('Error adding setting: ') + (error.response?.data?.message || error.message), type: 'error' })
      }
      return false
    }
  },

  // Update single setting
  async updateSetting({ commit }, { group, name, value, file, id }) {
    commit('SET_SAVING', true)

    const formData = new FormData()
    formData.append("_method", "PUT");// Laravel method spoofing
    if (file) {
      formData.append('file', file)
    } else {
      formData.append('value', value)
    }

    try {
      const response = await axiosClient.post(`/settings/${id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })

      if (response.data.success) {
        if (!file) {
          commit('UPDATE_SETTING_VALUE', { group, name, value })
        } else {
          // Refresh settings to get new file URL
          await actions.fetchAllSettings({ commit })
        }
        commit('SET_MESSAGE', { message: t('Setting updated successfully'), type: 'success' })
        return true
      }
    } catch (error) {
      commit('SET_MESSAGE', { message: t('Error updating setting: ') + (error.response?.data?.message || error.message), type: 'error' })
      console.error('Error updating setting:', error)
      return false
    } finally {
      commit('SET_SAVING', false)
    }
  },


    // Update entire group - Handles images and videos
    async updateGroupSettings({ commit, state, dispatch }, group) {
    commit('SET_SAVING', true)

    const settings = state.allSettings[group] || []
    let successCount = 0
    let errorCount = 0

    for (const setting of settings) {
        try {
        // Check if this setting has a new file to upload (image or video)
        if (setting.file && setting.file instanceof File) {
            // Handle file upload (image or video)
            const formData = new FormData()
            formData.append('_method', 'PUT')
            formData.append('file', setting.file)

            const response = await axiosClient.post(`/settings/${setting.id}`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
            })

            if (response.data.success) {
            successCount++
            // Clear file reference after successful upload
            delete setting.file
            delete setting.preview
            console.log(`Updated file for ${setting.name}:`, setting.type)
            } else {
            errorCount++
            console.error(`Failed to update file for ${setting.name}`)
            }
        }
        // Inside the loop in updateGroupSettings
    if (setting.type === 'multi_images') {
    if (setting.newFiles?.length) {
        // Upload all new files
        for (const file of setting.newFiles) {
        const formData = new FormData()
        formData.append('_method', 'PUT')
        formData.append('file', file)
        formData.append('type', 'multi_images')

        await axiosClient.post(`/settings/${setting.id}`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        })
        }
        delete setting.newFiles
        delete setting.previewFiles
    }
    successCount++
    }
        // Handle text updates
        else if (setting.type === 'text') {
            const response = await axiosClient.put(`/settings/${setting.id}`, {
            value: setting.value
            })

            if (response.data.success) {
            successCount++
            } else {
            errorCount++
            }
        }
        // For existing images/videos without new file upload
        else {
            successCount++
        }
        } catch (error) {
        console.error(`Error updating setting ${setting.name}:`, error)
        errorCount++
        }
    }

    // Show result message
    if (errorCount > 0) {
        commit('SET_MESSAGE', {
        message: t(`Saved ${successCount} settings, but ${errorCount} failed`),
        type: 'error'
        })
    } else {
        commit('SET_MESSAGE', {
        message: t(`All ${successCount} settings saved successfully`),
        type: 'success'
        })
    }

    // Refresh settings to get updated values (especially for file URLs)
    if (successCount > 0) {
        await dispatch('fetchAllSettings')
    }

    commit('SET_SAVING', false)
    return errorCount === 0
    },

  // Delete setting
  async deleteSetting({ commit }, { group, name, id }) {
    if (!confirm(t('Delete this setting?'))) {
      return false
    }

    try {
      const response = await axiosClient.delete(`/settings/${id}`)
      if (response.data.success) {
        commit('REMOVE_SETTING', { group, name })
        commit('SET_MESSAGE', { message: t('Setting deleted successfully'), type: 'success' })
        return true
      }
    } catch (error) {
      commit('SET_MESSAGE', { message: t('Error deleting setting: ') + (error.response?.data?.message || error.message), type: 'error' })
      console.error('Error deleting setting:', error)
      return false
    }
  },

  // Set active group
  setActiveGroup({ commit }, group) {
    commit('SET_ACTIVE_GROUP', group)
  },

  // Modal actions
  openAddModal({ commit, state }) {
    commit('RESET_NEW_SETTING')
    commit('SET_NEW_SETTING_FIELD', { field: 'group', value: state.activeGroup })
    commit('SET_SHOW_ADD_MODAL', true)
    commit('CLEAR_ERRORS')
  },

  closeAddModal({ commit }) {
    commit('SET_SHOW_ADD_MODAL', false)
    commit('RESET_NEW_SETTING')
    commit('CLEAR_ERRORS')
  },

  openAddGroupModal({ commit }) {
    commit('RESET_NEW_GROUP')
    commit('SET_SHOW_ADD_GROUP_MODAL', true)
  },

  closeAddGroupModal({ commit }) {
    commit('SET_SHOW_ADD_GROUP_MODAL', false)
    commit('RESET_NEW_GROUP')
  },

  // File handlers - FIXED: Removed 10MB limit
  handleNewSettingFile({ commit }, file) {
    if (!file) return

    console.log('File selected:', file.name, 'Size:', file.size, 'Type:', file.type)

    // Remove the 10MB limit check - let server handle it
    // Just show warning for large files but still allow upload
    if (file.size > 100 * 1024 * 1024) {
      commit('SET_MESSAGE', {
        message: `Large file (${(file.size / (1024 * 1024)).toFixed(2)}MB). Upload may take a while.`,
        type: 'warning'
      })
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      commit('SET_NEW_SETTING_FIELD', { field: 'preview', value: e.target.result })
      commit('SET_NEW_SETTING_FIELD', { field: 'file', value: file })
    }
    reader.readAsDataURL(file)
  },

  handleSettingFileUpload({ commit }, { group, name, file }) {
    if (!file) return

    console.log('Setting file upload:', name, file.name, file.size)

    const reader = new FileReader()
    reader.onload = (e) => {
      commit('UPDATE_SETTING_FILE', { group, name, file, preview: e.target.result })
    }
    reader.readAsDataURL(file)
  },

  // Large file upload with chunking support
  async uploadLargeVideo({ commit }, { setting, file, group }) {
    const CHUNK_SIZE = 5 * 1024 * 1024 // 5MB chunks
    const totalChunks = Math.ceil(file.size / CHUNK_SIZE)

    for (let chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      const start = chunkIndex * CHUNK_SIZE
      const end = Math.min(start + CHUNK_SIZE, file.size)
      const chunk = file.slice(start, end)

      const formData = new FormData()
      formData.append('file', chunk)
      formData.append('setting_id', setting.id)
      formData.append('setting_name', setting.name)
      formData.append('group', group)
      formData.append('resumableIdentifier', `${setting.id}_${file.name}`)
      formData.append('resumableFilename', file.name)
      formData.append('resumableTotalSize', file.size)
      formData.append('resumableTotalChunks', totalChunks)
      formData.append('resumableChunkNumber', chunkIndex + 1)

      try {
        const response = await axiosClient.post('/upload/large-file', formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
          onUploadProgress: (progressEvent) => {
            const percentCompleted = Math.round((chunkIndex + (progressEvent.loaded / progressEvent.total)) / totalChunks * 100)
            commit('SET_MESSAGE', { message: `Uploading: ${percentCompleted}%`, type: 'info' })
          }
        })

        if (response.data.completed) {
          commit('UPDATE_SETTING_VALUE', { group, name: setting.name, value: response.data.path })
          return true
        }
      } catch (error) {
        console.error('Chunk upload error:', error)
        commit('SET_MESSAGE', { message: 'Upload failed', type: 'error' })
        return false
      }
    }
  },

  // UI actions
  clearMessage({ commit }) {
    commit('CLEAR_MESSAGE')
  },

  setMessage({ commit }, { message, type }) {
    commit('SET_MESSAGE', { message, type })
    setTimeout(() => {
      commit('CLEAR_MESSAGE')
    }, 3000)
  }


}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

