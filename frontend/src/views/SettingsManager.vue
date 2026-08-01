<!-- resources/js/components/SettingsManager.vue -->
<template>
  <div class="max-w-7xl mx-auto bg-white rounded-xl shadow-lg mt-10">
    <!-- Header -->
    <div class="border-b border-gray-200 px-6 py-4">
      <h1 class="text-2xl font-bold text-gray-800"> {{ t("System_Settings") }}</h1>
      <p class="text-sm text-gray-500 mt-1">{{t("Manage_Settings")}}</p>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-20">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
    </div>

    <div v-else>
      <!-- Groups Tabs -->
      <div class="border-b border-gray-200 px-6">
        <nav class="flex space-x-8 overflow-x-auto pt-2">

          <button
            v-for="group in groups"
            :key="group"
            @click="setActiveGroup(group)"
            :class="[
                'py-4 px-1 border-b-2 font-medium text-sm whitespace-nowrap transition group relative',
                activeGroup === group
                ? 'border-green-500 text-green-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            ]"
            >
            {{ formatGroupName(group) }}
            <span class="ml-2 px-2 py-0.5 text-xs rounded-full bg-gray-100 text-gray-600">
                {{ allSettings[group]?.length || 0 }}
            </span>

            <!-- Delete icon on hover -->
            <button
                v-if="group !== 'general'"
                @click.stop="deleteSingleGroup(group)"
                class="absolute -top-1 -right-0 opacity-0 group-hover:opacity-100 text-gray-100 bg-red-500 hover:text-gray-300 transition"
                title="Delete group"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
          </button>
          <button
            @click="openAddGroupModal"
            class="py-4 px-1 text-green-600 hover:text-green-700 font-medium text-sm whitespace-nowrap"
          >
            +{{t("new_group")}}
          </button>


        </nav>
      </div>

      <!-- Settings Content -->
      <div v-if="activeGroup" class="p-6">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-semibold text-gray-800">
            {{ formatGroupName(activeGroup) }} {{t("settings")}}
          </h2>
          <button
            @click="openAddModal"
            class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 flex items-center gap-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            {{t("add_setting")}}
          </button>
        </div>

        <form @submit.prevent="saveGroupSettings">
          <div class="space-y-6">
            <div
              v-for="setting in currentGroupSettings"
              :key="setting.id"
              class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition"
            >
              <div class="flex justify-between items-start mb-3">
                <div class="flex-1">
                  <label class="block text-sm font-medium text-gray-700">
                    {{ formatSettingName(setting.name) }}
                    <span class="text-xs text-gray-400 ml-2">({{ setting.name }})</span>
                  </label>
                  <p class="text-xs text-gray-400 mt-0.5">{{t("type")}}: {{t(getTypeLabel(setting.type)) }}</p>
                </div>
                <button
                  type="button"
                  @click="deleteSetting(setting)"
                  class="text-red-600 hover:text-red-800 text-sm ml-4"
                >
                  {{t("Delete")}}
                </button>
              </div>

              <!-- Text Input -->
              <div v-if="setting.type === 'text'">
                <textarea
                  v-if="setting.value && setting.value.length > 100"
                  :value="setting.value"
                  @input="updateSettingValue(setting.name, $event.target.value)"
                  rows="4"
                  class="w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                ></textarea>
                <input
                  v-else
                  :value="setting.value"
                  @input="updateSettingValue(setting.name, $event.target.value)"
                  type="text"
                  class="w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                />
              </div>

              <!-- Single Image Field -->
              <div v-else-if="setting.type === 'image'">
                <div class="flex items-start gap-4">
                  <div class="flex-1">
                    <input
                      type="file"
                      accept="image/*"
                      @change="(e) => handleSettingFileUpload(setting, e.target.files[0])"
                      class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100"
                    />
                    <p class="text-xs text-gray-500 mt-1">{{t("Upload_new_image")}}</p>
                  </div>
                  <div v-if="setting.preview || setting.value" class="w-32 h-32">
                    <img
                       :src="setting.preview ||`${storageBase}/${setting.value}`"

                      class="w-full h-full object-cover rounded-lg border"
                      :alt="setting.name"
                    />
                  </div>
                </div>
              </div>

              <!-- Multi Images Field -->
            <div v-else-if="setting.type === 'multi_images'">
            <div class="space-y-4">
                <div>
                <input
                    type="file"
                    accept="image/*"

                    multiple
                    @change="(e) => handleMultiImageSelect(setting, e.target.files)"
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100"
                    :disabled="setting.uploadingMultiImages"
                />
                <p class="text-xs text-gray-500 mt-1">{{t("Upload_multiple_images")}}</p>
                </div>

                <!-- Upload Progress -->
                <div v-if="setting.uploadingMultiImages" class="bg-gray-50 p-3 rounded">
                <div class="flex justify-between text-sm text-gray-600 mb-1">
                    <span>{{t("uploadingMultiImages")}}</span>
                    <span>{{ setting.multiUploadProgress || 0 }}%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2 overflow-hidden">
                    <div
                    class="bg-green-600 h-2 rounded-full transition-all duration-300"
                    :style="{ width: (setting.multiUploadProgress || 0) + '%' }"
                    ></div>
                </div>
                <p class="text-xs text-gray-500 mt-1">
                    {{t("uploaded")}} {{ setting.uploadedCount || 0 }} of {{ setting.newImages?.length || 0 }} {{t("images")}}
                </p>
                </div>

            <!-- Image Gallery -->
            <div v-if="getMultiImages(setting).length > 0 || (setting.newImages && setting.newImages.length > 0)" class="mt-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">
                {{t("image_gallery")}} ({{ getMultiImages(setting).length + (setting.newImages?.length || 0) }})
            </label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <!-- Existing Images -->
                <div v-for="(image, idx) in getMultiImages(setting)" :key="'existing-' + idx" class="relative group">
                <img
                    :src="image"
                    class="w-full h-32 object-cover rounded-lg border"
                    :alt="'Image ' + (idx + 1)"
                />

                </div>

                <!-- New Images Preview -->
                <div v-for="(newImg, newIdx) in (setting.newImages || [])" :key="'new-' + newIdx" class="relative group">
                <img
                    :src="newImg.preview"
                    class="w-full h-32 object-cover rounded-lg border border-green-300"
                    :alt="'New image ' + (newIdx + 1)"
                />
                <button
                    type="button"
                    @click="removeNewMultiImage(setting, newIdx)"
                    class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs hover:bg-red-600 opacity-0 group-hover:opacity-100 transition"
                    title="Remove"
                >
                    ✕
                </button>
                <div class="absolute bottom-1 left-1 bg-green-500 text-white text-xs px-1 rounded">
                    New
                </div>
                </div>
            </div>
            </div>

            </div>
            </div>

              <!-- Video Field -->
              <div v-else-if="setting.type === 'video'">
                <div class="flex items-start gap-4">
                  <div class="flex-1">
                    <input
                      type="file"
                      accept="video/*"
                      @change="(e) => handleSettingFileUpload(setting, e.target.files[0])"
                      class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100"
                    />
                    <p class="text-xs text-gray-500 mt-1">{{t("Upload_new_video")}}</p>
                  </div>
                  <div v-if="setting.preview || setting.value" class="w-48">
                    <video
                      :src="setting.preview ||`${storageBase}/${setting.value}`"
                      controls
                      class="w-full rounded-lg border"
                    ></video>
                  </div>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-if="currentGroupSettings.length === 0" class="text-center py-12 bg-gray-50 rounded-lg">
              <p class="text-gray-500">No settings found in {{ formatGroupName(activeGroup) }}</p>
              <p class="text-gray-500 text-sm mt-2">Click "Add Setting" to create your first setting</p>
            </div>

            <!-- Submit Button -->
            <div v-if="currentGroupSettings.length > 0" class="flex justify-end pt-4">
              <button
                type="submit"
                :disabled="saving || hasActiveUploads"
                class="px-6 py-3 bg-green-600 text-white font-medium rounded-md hover:bg-green-700 disabled:opacity-50"
              >
                <svg v-if="saving" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8h8a8 8 0 01-16 0z"/>
                </svg>
                {{t("save_all_settings")}}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!-- Add Setting Modal -->
    <div v-if="showAddModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
      <div class="relative top-20 mx-auto p-5 border w-full max-w-md shadow-lg rounded-md bg-white">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-medium text-gray-900">{{t("add_new_setting")}}</h3>
          <button @click="closeAddModal" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("setting_name")}} *</label>
            <input
              v-model="newSetting.name"
              type="text"
              @input="checkDuplicateName"
              :class="[
                'w-full rounded-md shadow-sm focus:border-green-500 focus:ring-green-500',
                isNameDuplicate
                  ? 'border-red-500 focus:border-red-500 focus:ring-red-500'
                  : 'border-gray-300'
              ]"
              placeholder="e.g., hero_title, contact_email"
            />
            <p v-if="isNameDuplicate" class="mt-1 text-sm text-red-600">
              {{t("A setting with this name already exists")}}
            </p>
            <p class="text-xs text-gray-500 mt-1">{{t("Use_snake_case")}}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("group")}}</label>
            <input
              v-model="newSetting.group"
              type="text"
              readonly
              class="w-full rounded-md border-gray-300 bg-gray-50 shadow-sm"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("type")}} *</label>
            <select
              v-model="newSetting.type"
              @change="resetFileSelection"
              class="w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
            >
              <option value="text">{{t("text")}}</option>
              <option value="image">{{t("image")}}</option>
              <option value="multi_images">{{t("multiple_images")}}</option>
              <option value="video">{{t("video")}}</option>
            </select>
          </div>

          <div v-if="newSetting.type === 'text'">
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("setting_value")}}</label>
            <textarea
              v-model="newSetting.value"
              rows="3"
              class="w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
              :placeholder="t('enter_setting_value')"
            ></textarea>
          </div>

          <div v-else-if="newSetting.type === 'multi_images'">
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("multiple_images")}}</label>
            <input
              type="file"
              accept="image/*"
              multiple
              @change="(e) => handleNewMultiImages(e.target.files)"
              class="w-full"
              :disabled="uploadingNewFile"
            />
            <p class="text-xs text-gray-500 mt-1">{{t("Upload_multiple_images")}}</p>

            <!-- Multi-image upload progress -->
            <div v-if="uploadingNewFile" class="mt-3">
              <div class="flex justify-between text-sm text-gray-600 mb-1">
                <span>{{t("uploadingMultiImages")}}</span>
                <span>{{ multiUploadProgress }}%</span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-2.5 overflow-hidden">
                <div
                  class="bg-green-600 h-2.5 rounded-full transition-all duration-300"
                  :style="{ width: multiUploadProgress + '%' }"
                ></div>
              </div>
              <p class="text-xs text-gray-500 mt-1">
                {{t("uploaded")}} {{ uploadedImagesCount }} {{t("of")}} {{ newSetting.multiImages?.length || 0 }} {{t("images")}}
              </p>
            </div>

            <!-- Preview multiple images -->
            <div v-if="newSetting.multiImages && newSetting.multiImages.length > 0 && !uploadingNewFile" class="mt-3">
              <label class="block text-sm font-medium text-gray-700 mb-2">{{t("selected_images")}} ({{ newSetting.multiImages.length }})</label>
              <div class="grid grid-cols-3 gap-2">
                <div v-for="(img, idx) in newSetting.multiImages" :key="idx" class="relative">
                  <img :src="img.preview" class="w-full h-24 object-cover rounded border" />
                  <button
                    type="button"
                    @click="removeNewMultiSelectionImage(idx)"
                    class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs"
                  >
                    ✕
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div v-else>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              {{ newSetting.type === 'image' ? 'Image File' : 'Video File' }}
            </label>
            <input
              type="file"
              :accept="newSetting.type === 'image' ? 'image/*' : 'video/*'"
              @change="(e) => handleNewSettingFile(e.target.files[0])"
              class="w-full"
              :disabled="uploadingNewFile"
            />

            <!-- Upload Progress Bar -->
            <div v-if="uploadingNewFile" class="mt-3">
              <div class="flex justify-between text-sm text-gray-600 mb-1">
                <span>{{ newSetting.type === 'image' ? 'Uploading image...' : 'Uploading video...' }}</span>
                <span>{{ uploadProgress }}%</span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-2.5 overflow-hidden">
                <div
                  class="bg-green-600 h-2.5 rounded-full transition-all duration-300"
                  :style="{ width: uploadProgress + '%' }"
                ></div>
              </div>
              <p v-if="newSetting.type === 'video'" class="text-xs text-gray-500 mt-1">
                Uploaded {{ formatFileSize(uploadedBytes) }} of {{ formatFileSize(selectedFileSize) }}
              </p>
            </div>

            <!-- Preview -->
            <div v-if="newSetting.preview && !uploadingNewFile" class="mt-2">
              <img v-if="newSetting.type === 'image'" :src="newSetting.preview" class="h-32 object-cover rounded" />
              <video v-else :src="newSetting.preview" controls class="h-32 rounded"></video>
            </div>

            <!-- Cancel Upload Button -->
            <button
              v-if="uploadingNewFile"
              type="button"
              @click="cancelUpload"
              class="mt-2 w-full px-3 py-1 bg-red-100 text-red-600 rounded-md hover:bg-red-200 text-sm"
            >
              {{t("cancel_upload")}}
            </button>
          </div>

          <div class="flex gap-3 pt-4">
            <button
              @click="addSetting"
              :disabled="saving || isNameDuplicate || uploadingNewFile"
              class="flex-1 px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50"
            >
              <svg v-if="uploadingNewFile" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8h8a8 8 0 01-16 0z"/>
              </svg>
              {{ uploadingNewFile ? t("uploading") : t("add_setting") }}
            </button>
            <button
              @click="closeAddModal"
              class="flex-1 px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200"
            >
              {{t("Cancel")}}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Group Modal -->
    <div v-if="showAddGroupModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
      <div class="relative top-20 mx-auto p-5 border w-full max-w-md shadow-lg rounded-md bg-white">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-medium text-gray-900">{{t("create_new_group")}}</h3>
          <button @click="closeAddGroupModal" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">{{t("group_name")}}*</label>
            <input
              v-model="newGroup.name"
              type="text"
              placeholder="e.g., home_settings, about_settings"
              class="w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
            />
            <p class="text-xs text-gray-500 mt-1">{{t("Use_snake_case")}}</p>
          </div>

          <div class="flex gap-3 pt-4">
            <button
              @click="createNewGroup"
              class="flex-1 px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700"
            >
              {{t("create_group")}}
            </button>
            <button
              @click="closeAddGroupModal"
              class="flex-1 px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200"
            >
              {{t("Cancel")}}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast Message -->
    <transition
      enter-active-class="transition ease-out duration-300"
      enter-from-class="transform opacity-0 translate-y-2"
      enter-to-class="transform opacity-100 translate-y-0"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="transform opacity-100 translate-y-0"
      leave-to-class="transform opacity-0 translate-y-2"
    >
      <div v-if="message" :class="['fixed bottom-4 right-4 p-4 rounded-lg shadow-lg z-50 flex items-center gap-3', messageType === 'success' ? 'bg-green-500' : 'bg-red-500']">
        <p class="text-white">{{ message }}</p>
        <button
          @click="store.commit('settings/CLEAR_MESSAGE')"
          class="text-white hover:text-gray-200"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, onBeforeUnmount } from 'vue'
import { useStore } from 'vuex'
import axiosClient from '../axios'
import { useLanguage } from "../composables/useLanguage";


const {
  currentLanguage,
  t,

} = useLanguage()

const { currentDirection } = useLanguage();
const store = useStore()

const cleanupWebSocket = () => {

  try {

    console.log('Cleaning up WebSocket connections...')
  } catch (error) {
    console.error('Error cleaning up WebSocket:', error)
  }
}

// Add event listeners for page navigation
window.addEventListener('beforeunload', cleanupWebSocket)
window.addEventListener('pagehide', cleanupWebSocket)

// Clean up event listeners when component is destroyed
onBeforeUnmount(() => {
  cleanupWebSocket()
  window.removeEventListener('beforeunload', cleanupWebSocket)
  window.removeEventListener('pagehide', cleanupWebSocket)
})
// ===== END WEBSOCKET CLEANUP =====


// Upload states
const uploadingStates = ref({})
const uploadingNewFile = ref(false)
const uploadProgress = ref(0)
const uploadedBytes = ref(0)
const selectedFileSize = ref(0)
const uploadCancelled = ref(false)
const multiUploadProgress = ref(0)
const uploadedImagesCount = ref(0)

const storageBase = import.meta.env.VITE_STORAGE_URL ;


// Computed from store
const allSettings = computed(() => store.state.settings.allSettings || {})
const groups = computed(() => store.state.settings.groups || [])
const loading = computed(() => store.state.settings.loading || false)
const saving = computed(() => store.state.settings.saving || false)
const activeGroup = computed(() => store.state.settings.activeGroup)
const message = computed(() => store.state.settings.message)
const messageType = computed(() => store.state.settings.messageType)
const showAddModal = computed(() => store.state.settings.showAddModal)
const showAddGroupModal = computed(() => store.state.settings.showAddGroupModal)
const newGroup = computed(() => store.state.settings.newGroup)

// Local ref for new setting
const newSetting = ref({
  name: '',
  group: '',
  type: 'text',
  value: '',
  file: null,
  preview: null,
  multiImages: [],
  metadata: null
})

// Computed properties
const hasActiveUploads = computed(() => {
  return Object.values(uploadingStates.value).some(state => state?.isUploading === true) || uploadingNewFile.value
})

const currentGroupSettings = computed(() => {
  if (!activeGroup.value || !allSettings.value[activeGroup.value]) {
    return []
  }
  return allSettings.value[activeGroup.value] || []
})

const isNameDuplicate = computed(() => {
  if (!newSetting.value.name || !activeGroup.value) return false
  return currentGroupSettings.value.some(
    s => s.name.toLowerCase() === newSetting.value.name.toLowerCase()
  )
})

// Helper functions
const formatGroupName = (group) => {
  if (!group) return ''
  return group.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())
}

const formatSettingName = (name) => {
  return name.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())
}

const getTypeLabel = (type) => {
  const labels = {
    'text': 'text',
    'image': 'image',
    'multi_images': 'multiple_images',
    'video': 'video'
  }
  return labels[type] || type
}


const getMultiImages = (setting) => {
  if (!setting.value) return []
  try {
    let images = typeof setting.value === 'string'
      ? JSON.parse(setting.value)
      : setting.value

    // Ensure all images have /storage/ prefix
    if (Array.isArray(images)) {
      return images.map(img => {
        if (img && !img.startsWith('/storage/') && !img.startsWith('http')) {
          return '/storage/' + img.replace(/^\/+/, '')
        }
        return img
      })
    }
    return []
  } catch {
    return []
  }
}

const setActiveGroup = (group) => {
  store.dispatch('settings/setActiveGroup', group)
}



// Handle single file selection for new setting
const handleNewSettingFile = async (file) => {
  if (!file) return

  if (newSetting.value.type === 'image' && !file.type.startsWith('image/')) {
    store.dispatch('settings/setMessage', {
      message: 'Please select a valid image file',
      type: 'error'
    })
    return
  }

  if (newSetting.value.type === 'video' && !file.type.startsWith('video/')) {
    store.dispatch('settings/setMessage', {
      message: 'Please select a valid video file',
      type: 'error'
    })
    return
  }

  const maxSize = newSetting.value.type === 'image' ? 20 * 1024 * 1024 : 2 * 1024 * 1024 * 1024
  if (file.size > maxSize) {
    store.dispatch('settings/setMessage', {
      message: `File size too large. Max ${newSetting.value.type === 'image' ? '20MB' : '2GB'}`,
      type: 'error'
    })
    return
  }

  newSetting.value.file = file
  selectedFileSize.value = file.size
  uploadCancelled.value = false

  const reader = new FileReader()
  reader.onload = (e) => {
    newSetting.value.preview = e.target.result
  }
  reader.readAsDataURL(file)

  store.dispatch('settings/setMessage', {
    message: `${newSetting.value.type === 'image' ? 'Image' : 'Video'} selected. Click "Add Setting" to upload.`,
    type: 'info'
  })
}

// Handle multi-image selection for new setting
const handleNewMultiImages = (files) => {
  if (!files || files.length === 0) return

  const images = []
  const validFiles = Array.from(files).filter(f => {
    if (!f.type.startsWith('image/')) {
      store.dispatch('settings/setMessage', {
        message: `File ${f.name} is not a valid image`,
        type: 'error'
      })
      return false
    }
    if (f.size > 20 * 1024 * 1024) {
      store.dispatch('settings/setMessage', {
        message: `Image ${f.name} is too large (Max 20MB)`,
        type: 'error'
      })
      return false
    }
    return true
  })

  for (const file of validFiles) {
    const reader = new FileReader()
    reader.onload = (e) => {
      images.push({
        file: file,
        preview: e.target.result,
        name: file.name
      })
      if (images.length === validFiles.length) {
        newSetting.value.multiImages = [...newSetting.value.multiImages, ...images]
      }
    }
    reader.readAsDataURL(file)
  }
}

// Remove new multi-image from selection
const removeNewMultiSelectionImage = (index) => {
  newSetting.value.multiImages.splice(index, 1)
}



// Handle multi-image selection for existing setting - REPLACE MODE
const handleMultiImageSelect = (setting, files) => {
  if (!files || files.length === 0) return

  // Clear existing new images
  setting.newImages = []

  const validFiles = Array.from(files).filter(f => {
    if (!f.type.startsWith('image/')) {
      store.dispatch('settings/setMessage', {
        message: `File ${f.name} is not a valid image`,
        type: 'error'
      })
      return false
    }
    if (f.size > 20 * 1024 * 1024) {
      store.dispatch('settings/setMessage', {
        message: `Image ${f.name} is too large (Max 20MB)`,
        type: 'error'
      })
      return false
    }
    return true
  })

  for (const file of validFiles) {
    const reader = new FileReader()
    reader.onload = (e) => {
      if (!setting.newImages) setting.newImages = []
      setting.newImages.push({
        file: file,
        preview: e.target.result,
        name: file.name
      })
    }
    reader.readAsDataURL(file)
  }

  // Show warning that old images will be replaced
  store.dispatch('settings/setMessage', {
    message: `${validFiles.length} new image(s) selected. Old images will be replaced when you click "Save".`,
    type: 'warning'
  })
}




// Remove new multi-image from existing setting
const removeNewMultiImage = (setting, index) => {
  setting.newImages.splice(index, 1)
}


// Handle setting file upload (for existing settings)
const handleSettingFileUpload = (setting, file) => {
  if (!file) return

  store.commit('settings/UPDATE_SETTING_FILE', {
    group: activeGroup.value,
    name: setting.name,
    file: file,
    preview: URL.createObjectURL(file)
  })

  store.dispatch('settings/setMessage', {
    message: `New ${setting.type === 'image' ? 'image' : 'video'} selected. Click "Save All Settings" to upload.`,
    type: 'info'
  })
}



// Delete setting
const deleteSetting = (setting) => {
  store.dispatch('settings/deleteSetting', {
    group: activeGroup.value,
    name: setting.name,
    id: setting.id
  })
}

// Error handlers
const handleImageError = (event) => {
  event.target.src = '/placeholder-image.png'
}

// Create new group
const createNewGroup = async () => {
  const success = await store.dispatch('settings/createGroup', newGroup.value.name)
  if (success) {
    store.dispatch('settings/closeAddGroupModal')
  }
}

// Check duplicate name
const checkDuplicateName = () => {
  if (isNameDuplicate.value) {
    store.dispatch('settings/setMessage', {
      message: 'Setting name already exists in this group',
      type: 'warning'
    })
  }
}

// Reset file selection
const resetFileSelection = () => {
  newSetting.value.file = null
  newSetting.value.preview = null
  newSetting.value.multiImages = []
  uploadProgress.value = 0
  uploadedBytes.value = 0
  selectedFileSize.value = 0
  uploadingNewFile.value = false
  multiUploadProgress.value = 0
  uploadedImagesCount.value = 0
}

// Cancel upload
const cancelUpload = () => {
  uploadCancelled.value = true
  uploadingNewFile.value = false
  uploadProgress.value = 0
  newSetting.value.file = null
  newSetting.value.preview = null

  store.dispatch('settings/setMessage', {
    message: 'Upload cancelled',
    type: 'info'
  })
}

// Modal actions
const openAddModal = () => {
  newSetting.value = {
    name: '',
    group: activeGroup.value,
    type: 'text',
    value: '',
    file: null,
    preview: null,
    multiImages: [],
    metadata: null
  }
  uploadProgress.value = 0
  uploadedBytes.value = 0
  selectedFileSize.value = 0
  uploadingNewFile.value = false
  multiUploadProgress.value = 0
  uploadedImagesCount.value = 0
  store.dispatch('settings/openAddModal')
}

const closeAddModal = () => {
  uploadingNewFile.value = false
  uploadProgress.value = 0
  store.dispatch('settings/closeAddModal')
}

const openAddGroupModal = () => {
  store.dispatch('settings/openAddGroupModal')
}

const closeAddGroupModal = () => {
  store.dispatch('settings/closeAddGroupModal')
}



const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// Save all group settings
const saveGroupSettings = async () => {
  if (hasActiveUploads.value) {
    store.dispatch('settings/setMessage', {
      message: 'Please wait for uploads to complete',
      type: 'warning'
    })
    return
  }

  if (!activeGroup.value) {
    store.dispatch('settings/setMessage', {
      message: 'No group selected',
      type: 'error'
    })
    return
  }

  const settings = currentGroupSettings.value
  const formData = new FormData()

  // Track which settings have files to upload
  let hasFiles = false

  for (const setting of settings) {
    // For text settings
    if (setting.type === 'text') {
      formData.append(`settings[${setting.name}][name]`, setting.name)
      formData.append(`settings[${setting.name}][value]`, setting.value)
      formData.append(`settings[${setting.name}][type]`, setting.type)
    }
    // For image/video settings with new files
    else if ((setting.type === 'image' || setting.type === 'video') && setting.file) {
      hasFiles = true
      formData.append(`settings[${setting.name}][name]`, setting.name)
      formData.append(`settings[${setting.name}][file]`, setting.file)
      formData.append(`settings[${setting.name}][type]`, setting.type)
    }
    // For image/video settings without new files (keep existing value)
    else if (setting.type === 'image' || setting.type === 'video') {
      formData.append(`settings[${setting.name}][name]`, setting.name)
      formData.append(`settings[${setting.name}][value]`, setting.value)
      formData.append(`settings[${setting.name}][type]`, setting.type)
    }
    // For multi_images settings
    else if (setting.type === 'multi_images') {
      // If there are new images to upload (replace mode)
      if (setting.newImages && setting.newImages.length > 0) {
        hasFiles = true
        formData.append(`settings[${setting.name}][name]`, setting.name)
        formData.append(`settings[${setting.name}][type]`, setting.type)
        formData.append(`settings[${setting.name}][replace_images]`, 'true')

        // Append all new images
        for (let i = 0; i < setting.newImages.length; i++) {
          formData.append(`settings[${setting.name}][files][${i}]`, setting.newImages[i].file)
        }
      }
      // If images were removed, send the updated array
      else if (setting.updatedValue && setting.updatedValue !== setting.originalValue) {
        formData.append(`settings[${setting.name}][name]`, setting.name)
        formData.append(`settings[${setting.name}][type]`, setting.type)
        formData.append(`settings[${setting.name}][value]`, setting.updatedValue)
      }
    }
  }

  formData.append('group', activeGroup.value)

  try {
    const response = await axiosClient.post('/settings/group/update', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })

    if (response.data.success) {
      // Clear file and newImages from settings after successful save
      for (const setting of currentGroupSettings.value) {
        if (setting.file) {
          delete setting.file
          setting.preview = null
        }
        if (setting.newImages) {
          delete setting.newImages
        }
        if (setting.updatedValue) {
          setting.value = setting.updatedValue
          delete setting.updatedValue
          delete setting.originalValue
        }
      }

      store.dispatch('settings/setMessage', {
        message: 'All settings saved successfully',
        type: 'success'
      })

      // Refresh settings
      await store.dispatch('settings/fetchAllSettings')
    }
  } catch (error) {
    console.error('Error saving settings:', error)
    store.dispatch('settings/setMessage', {
      message: error.response?.data?.message || 'Failed to save settings',
      type: 'error'
    })
  }
}


const updateSettingValue = (name, value) => {
  // For multi_images, track original value for comparison
  const setting = currentGroupSettings.value.find(s => s.name === name)
  if (setting && setting.type === 'multi_images') {
    // Store original value if not already stored
    if (!setting.originalValue) {
      setting.originalValue = setting.value
    }
    setting.updatedValue = value
  }

  store.commit('settings/UPDATE_SETTING_VALUE', {
    group: activeGroup.value,
    name,
    value
  })
}


const addSetting = async () => {
  if (isNameDuplicate.value) {
    store.dispatch('settings/setMessage', {
      message: `A setting named "${newSetting.value.name}" already exists in this group`,
      type: 'error'
    })
    return
  }

  if (!newSetting.value.name || !newSetting.value.group) {
    store.dispatch('settings/setMessage', {
      message: `${t("setting_name_required")} ${t("group_name_required")}`,
      type: 'error'
    })
    return
  }

  // Handle text type
  if (newSetting.value.type === 'text') {
    const formData = new FormData()
    formData.append('group', newSetting.value.group)
    formData.append('name', newSetting.value.name)
    formData.append('type', newSetting.value.type)
    formData.append('value', newSetting.value.value || '')

    try {
      const response = await axiosClient.post('/settings', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })

      if (response.data.success) {
        await store.dispatch('settings/fetchAllSettings')
        closeAddModal()
        store.dispatch('settings/setMessage', {
          message: `${t("Setting added successfully")}`,
          type: 'success'
        })
      }
    } catch (error) {
      console.error('Error:', error)
      store.dispatch('settings/setMessage', {
        message: error.response?.data?.message || `${t("Failed to add setting")}`,
        type: 'error'
      })
    }
    return
  }

  // Handle multi-images
  if (newSetting.value.type === 'multi_images') {
    if (!newSetting.value.multiImages || newSetting.value.multiImages.length === 0) {
      store.dispatch('settings/setMessage', {
        message: `${t("Please select at least one image")}`,
        type: 'error'
      })
      return
    }

    uploadingNewFile.value = true
    multiUploadProgress.value = 0
    uploadedImagesCount.value = 0

    const formData = new FormData()
    formData.append('group', newSetting.value.group)
    formData.append('name', newSetting.value.name)
    formData.append('type', 'multi_images')

    for (let i = 0; i < newSetting.value.multiImages.length; i++) {
      formData.append(`files[${i}]`, newSetting.value.multiImages[i].file)
    }

    try {
      const response = await axiosClient.post('/settings', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        onUploadProgress: (progressEvent) => {
          const percent = Math.round((progressEvent.loaded * 100) / progressEvent.total)
          multiUploadProgress.value = percent
          uploadedImagesCount.value = Math.floor((progressEvent.loaded / progressEvent.total) * newSetting.value.multiImages.length)
        }
      })

      if (response.data.success) {
        await store.dispatch('settings/fetchAllSettings')
        closeAddModal()
        store.dispatch('settings/setMessage', {
          message: `${newSetting.value.multiImages.length} ${t("image")} added successfully`,
          type: 'success'
        })
      }
    } catch (error) {
      console.error('Error:', error)
      store.dispatch('settings/setMessage', {
        message: error.response?.data?.message || `${t("Failed to upload images")}`,
        type: 'error'
      })
    } finally {
      uploadingNewFile.value = false
      multiUploadProgress.value = 0
      uploadedImagesCount.value = 0
    }
    return
  }

  // Handle single file upload (image/video)
  if (!newSetting.value.file) {
    store.dispatch('settings/setMessage', {
      message: `${t("Please select a file")}`,
      type: 'error'
    })
    return
  }

  uploadingNewFile.value = true
  uploadProgress.value = 0
  uploadedBytes.value = 0

  try {
    const formData = new FormData()
    formData.append('group', newSetting.value.group)
    formData.append('name', newSetting.value.name)
    formData.append('type', newSetting.value.type)
    formData.append('file', newSetting.value.file)

    const response = await axiosClient.post('/settings', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      onUploadProgress: (progressEvent) => {
        if (!uploadCancelled.value) {
          const percent = Math.round((progressEvent.loaded * 100) / progressEvent.total)
          uploadProgress.value = percent
          uploadedBytes.value = progressEvent.loaded
        }
      }
    })

    if (uploadCancelled.value) return

    if (response.data.success) {
      await store.dispatch('settings/fetchAllSettings')
      closeAddModal()
      store.dispatch('settings/setMessage', {
        message: `${newSetting.value.type === 'image' ? t("Image") : t("Video")} added successfully`,
        type: 'success'
      })
    }
  } catch (error) {
    console.error('Error uploading file:', error)
    store.dispatch('settings/setMessage', {
      message: error.response?.data?.message || `${t("Failed to upload file")}`,
      type: 'error'
    })
  } finally {
    uploadingNewFile.value = false
    uploadProgress.value = 0
    uploadedBytes.value = 0
  }
}


const deleteSingleGroup = (group) => {
  if (confirm(`Delete entire group "${group}" and all its settings? This action cannot be undone!`)) {
    store.dispatch('settings/deleteGroup', group)
  }
}

// Auto-clear message
watch(message, (newVal) => {
  if (newVal) {
    setTimeout(() => {
      store.commit('settings/CLEAR_MESSAGE')
    }, 3000)
  }
})

// Lifecycle
onMounted(() => {
  store.dispatch('settings/fetchAllSettings')
})
</script>
