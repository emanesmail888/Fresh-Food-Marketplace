<template>
  <home-layout>
    <div :dir="currentDirection">
      <!-- Breadcrumb -->
      <section class="py-5">
        <div class="container mx-auto px-4">
          <div class="text-center">
            <h1 class="text-3xl font-bold text-gray-800">{{ t('checkout') }}</h1>
            <h4 class="text-sm mt-3 text-gray-600">
              <router-link to="/" class="text-gray-600 hover:text-green-600 transition-colors">{{ t('home') }}</router-link>
              <span class="text-gray-400 mx-1 text-xs align-middle">›</span>
              <router-link to="/cart" class="text-gray-600 hover:text-green-600 transition-colors">{{ t('cart') }}</router-link>
              <span class="text-gray-400 mx-1 text-xs align-middle">›</span>
              <span class="text-gray-800">{{ t('checkout') }}</span>
            </h4>
          </div>
        </div>
      </section>

      <!-- Checkout Steps -->
      <section class="py-8 bg-gray-50 min-h-screen">
        <div class="container mx-auto">
          <!-- Step Indicator -->
          <div class="mb-16  ">
            <div class="flex items-center justify-center ">
              <div class="flex items-center mx-auto  w-100 max-w-4xl">
                <div
                  v-for="(step, index) in steps"
                  :key="index"
                  class="flex-1 relative"
                >
                  <div class="flex items-center">
                    <div
                      class="w-10 h-10 rounded-full flex items-center justify-center font-bold z-10 transition-colors"
                      :class="[
                        currentStep >= index + 1
                          ? 'bg-green-600 text-white'
                          : 'bg-gray-200 text-gray-600'
                      ]"
                    >
                      <span v-if="currentStep > index + 1">✓</span>
                      <span v-else>{{ index + 1 }}</span>
                    </div>
                    <div
                      v-if="index < steps.length - 1"
                      class="flex-1 h-1 mx-2 transition-colors"
                      :class="currentStep > index + 1 ? 'bg-green-600' : 'bg-gray-200'"
                    ></div>
                  </div>
                  <span class="absolute -bottom-6  transform -translate-x-1 text-xs font-medium text-gray-600 whitespace-nowrap">
                    {{ t(step.key) }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Loading State -->
          <div v-if="isLoading" class="text-center py-16">
            <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-green-600 border-t-transparent"></div>
            <p class="text-xl text-gray-600 mt-4">{{ t('loading') }}</p>
          </div>

          <div v-else-if="!cartItems.length" class="text-center py-16">
            <p class="text-xl text-gray-600 mb-6">{{ t('empty_cart') }}</p>
            <router-link to="/products" class="bg-green-600 hover:bg-green-700 text-white px-8 py-4 rounded-lg transition-colors">
              {{ t('go_shopping') }}
            </router-link>
          </div>

          <div v-else class="flex flex-wrap -mx-4">
            <!-- Main Content (Left Column) -->
            <div class="w-full lg:w-8/12 px-4">
              <!-- Step 1: Shipping Information -->
              <div v-show="currentStep === 1" class="bg-white rounded-lg shadow-sm p-6 mb-6">
                <h2 class="text-xl font-bold text-gray-800 mb-6">{{ t('shipping_information') }}</h2>

                <form @submit.prevent="nextStep">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Name -->
                    <div class="col-span-2 md:col-span-1">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('full_name') }} <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.shipping_address.name"
                        type="text"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.name'] ? 'border-red-500' : 'border-gray-300']"
                        :placeholder="t('full_name_placeholder')"
                      />
                      <p v-if="errors['shipping_address.name']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.name'][0] }}
                      </p>
                    </div>

                    <!-- Email -->
                    <div class="col-span-2 md:col-span-1">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('email') }} <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.shipping_address.email"
                        type="email"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.email'] ? 'border-red-500' : 'border-gray-300']"
                        :placeholder="t('email_placeholder')"
                      />
                      <p v-if="errors['shipping_address.email']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.email'][0] }}
                      </p>
                    </div>

                    <!-- Phone -->
                    <div class="col-span-2">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('phone') }} <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.shipping_address.phone"
                        type="tel"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.phone'] ? 'border-red-500' : 'border-gray-300']"
                        :placeholder="t('phone_placeholder')"
                      />
                      <p v-if="errors['shipping_address.phone']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.phone'][0] }}
                      </p>
                    </div>

                    <!-- Address Line 1 -->
                    <div class="col-span-2">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('address_line1') }} <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.shipping_address.address_line1"
                        type="text"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.address_line1'] ? 'border-red-500' : 'border-gray-300']"
                        :placeholder="t('address_line1_placeholder')"
                      />
                      <p v-if="errors['shipping_address.address_line1']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.address_line1'][0] }}
                      </p>
                    </div>

                    <!-- Address Line 2 (Optional) -->
                    <div class="col-span-2">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('address_line2') }}
                      </label>
                      <input
                        v-model="form.shipping_address.address_line2"
                        type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                        :placeholder="t('address_line2_placeholder')"
                      />
                    </div>

                    <!-- City -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('city') }} <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.shipping_address.city"
                        type="text"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.city'] ? 'border-red-500' : 'border-gray-300']"
                        :placeholder="t('city_placeholder')"
                      />
                      <p v-if="errors['shipping_address.city']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.city'][0] }}
                      </p>
                    </div>

                    <!-- State/Region -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('state') }}
                      </label>
                      <input
                        v-model="form.shipping_address.state"
                        type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                        :placeholder="t('state_placeholder')"
                      />
                    </div>

                    <!-- Postal Code -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('postal_code') }}
                      </label>
                      <input
                        v-model="form.shipping_address.postal_code"
                        type="text"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                        :placeholder="t('postal_code_placeholder')"
                      />
                    </div>

                    <!-- Country -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('country') }} <span class="text-red-500">*</span>
                      </label>
                      <select
                        v-model="form.shipping_address.country"
                        :class="['w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition',
                                 errors['shipping_address.country'] ? 'border-red-500' : 'border-gray-300']"
                      >
                        <option value="EG">Egypt</option>
                        <option value="SA">Saudi Arabia</option>
                        <option value="AE">UAE</option>
                      </select>
                      <p v-if="errors['shipping_address.country']" class="mt-1 text-sm text-red-600">
                        {{ errors['shipping_address.country'][0] }}
                      </p>
                    </div>

                    <!-- Customer Notes -->
                    <div class="col-span-2">
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        {{ t('order_notes') }}
                      </label>
                      <textarea
                        v-model="form.customer_notes"
                        rows="3"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                        :placeholder="t('order_notes_placeholder')"
                      ></textarea>
                    </div>
                  </div>

                  <!-- Billing Address Toggle -->
                  <div class="mt-6 pt-6 border-t border-gray-200">
                    <label class="flex items-center">
                      <input
                        type="checkbox"
                        v-model="billingSameAsShipping"
                        class="w-4 h-4 text-green-600 border-gray-300 rounded focus:ring-green-500"
                      />
                      <span class="ml-2 text-gray-700">{{ t('billing_same_as_shipping') }}</span>
                    </label>
                  </div>

                  <!-- Step Navigation -->
                  <div class="mt-8 flex justify-end">
                    <button
                      type="submit"
                      class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg transition-colors font-medium"
                      :disabled="isSubmitting"
                    >
                      <span v-if="isSubmitting" class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent mr-2"></span>
                      {{ t('continue_to_shipping') }}
                    </button>
                  </div>
                </form>
              </div>

              <!-- Step 2: Shipping Method -->
              <div v-show="currentStep === 2" class="bg-white rounded-lg shadow-sm p-6 mb-6">
                <h2 class="text-xl font-bold text-gray-800 mb-6">{{ t('shipping_method') }}</h2>

                <div class="space-y-4">
                  <div
                    v-for="method in shippingMethods"
                    :key="method.id"
                    @click="selectShippingMethod(method)"
                    class="border rounded-lg p-4 cursor-pointer transition"
                    :class="form.shipping_method === method.id ? 'border-green-600 bg-green-50' : 'border-gray-200 hover:border-green-300'"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center">
                        <div class="w-5 h-5 rounded-full border-2 mr-3 flex items-center justify-center"
                             :class="form.shipping_method === method.id ? 'border-green-600' : 'border-gray-300'">
                          <div v-if="form.shipping_method === method.id" class="w-2.5 h-2.5 rounded-full bg-green-600"></div>
                        </div>
                        <div>
                          <h3 class="font-semibold text-gray-800">{{ t(method.name) }}</h3>
                          <p class="text-sm text-gray-600">{{ t(method.description) }}</p>
                        </div>
                      </div>
                      <div class="text-lg font-bold text-gray-800">
                        {{ formatPrice(method.cost) }}
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Shipping Notes -->
                <div class="mt-6">
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('shipping_notes') }}
                  </label>
                  <textarea
                    v-model="form.shipping_notes"
                    rows="2"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                    :placeholder="t('shipping_notes_placeholder')"
                  ></textarea>
                </div>

                <!-- Step Navigation -->
                <div class="mt-8 flex justify-between">
                  <button
                    @click="prevStep"
                    class="px-8 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors font-medium"
                  >
                    {{ t('back') }}
                  </button>
                  <button
                    @click="nextStep"
                    class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg transition-colors font-medium"
                    :disabled="!form.shipping_method"
                  >
                    {{ t('continue_to_payment') }}
                  </button>
                </div>
              </div>

              <!-- Step 3: Payment Method -->
              <div v-show="currentStep === 3" class="bg-white rounded-lg shadow-sm p-6">
                <h2 class="text-xl font-bold text-gray-800 mb-6">{{ t('payment_method') }}</h2>

                <div class="space-y-4">
                  <!-- Stripe -->
                  <div
                    @click="selectPaymentMethod('stripe')"
                    class="border rounded-lg p-4 cursor-pointer transition"
                    :class="form.payment_method === 'stripe' ? 'border-green-600 bg-green-50' : 'border-gray-200 hover:border-green-300'"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center">
                        <div class="w-5 h-5 rounded-full border-2 mr-3 flex items-center justify-center"
                             :class="form.payment_method === 'stripe' ? 'border-green-600' : 'border-gray-300'">
                          <div v-if="form.payment_method === 'stripe'" class="w-2.5 h-2.5 rounded-full bg-green-600"></div>
                        </div>
                        <div>
                          <h3 class="font-semibold text-gray-800">{{ t('stripe') }}</h3>
                          <p class="text-sm text-gray-600">{{ t('stripe_desc') }}</p>
                        </div>
                      </div>
                      <div class="flex space-x-1">
                        <span class="text-2xl">💳</span>
                      </div>
                    </div>
                  </div>

                  <!-- Cash on Delivery -->
                  <div
                    @click="selectPaymentMethod('cash_on_delivery')"
                    class="border rounded-lg p-4 cursor-pointer transition"
                    :class="form.payment_method === 'cash_on_delivery' ? 'border-green-600 bg-green-50' : 'border-gray-200 hover:border-green-300'"
                  >
                    <div class="flex items-center">
                      <div class="w-5 h-5 rounded-full border-2 mr-3 flex items-center justify-center"
                           :class="form.payment_method === 'cash_on_delivery' ? 'border-green-600' : 'border-gray-300'">
                        <div v-if="form.payment_method === 'cash_on_delivery'" class="w-2.5 h-2.5 rounded-full bg-green-600"></div>
                      </div>
                      <div>
                        <h3 class="font-semibold text-gray-800">{{ t('cash_on_delivery') }}</h3>
                        <p class="text-sm text-gray-600">{{ t('cash_on_delivery_desc') }}</p>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Minimum Amount Warning for Stripe -->
                <div v-if="form.payment_method === 'stripe' && total < 25" class="mt-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                  <p class="text-sm text-yellow-800">
                    <span class="font-medium">⚠️ {{ t('minimum_amount_warning') }}</span>
                    {{ t('minimum_amount_message', { amount: formatPrice(25) }) }}
                  </p>
                </div>

                <!-- Order Review -->
                <div class="mt-8 pt-6 border-t border-gray-200">
                  <h3 class="font-semibold text-gray-800 mb-4">{{ t('order_review') }}</h3>

                  <div class="space-y-3 max-h-60 overflow-y-auto">
                    <div v-for="item in cartItems" :key="item.id" class="flex items-center justify-between text-sm">
                      <div class="flex items-center">
                        <span class="font-medium text-gray-900">
                        {{ currentLanguage === 'ar' && item.product?.title_ar ? item.product?.title_ar : item.product?.title }}

                        </span>
                        <span class="text-gray-500 ml-2">x {{ getQuantityDisplay(item) }}</span>
                      </div>
                      <span class="text-gray-900">{{ formatPrice(getItemTotal(item)) }}</span>
                    </div>
                  </div>
                </div>

                <!-- Step Navigation -->
                <div class="mt-8 flex justify-between">
                  <button
                    @click="prevStep"
                    class="px-8 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors font-medium"
                  >
                    {{ t('back') }}
                  </button>
                  <button
                    @click="placeOrder"
                    class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg transition-colors font-medium"
                    :disabled="isPlacingOrder || !form.payment_method || (form.payment_method === 'stripe' && total < 25)"
                  >
                    <span v-if="isPlacingOrder" class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent mr-2"></span>
                    {{ t('place_order') }}
                  </button>
                </div>
              </div>
            </div>

            <!-- Order Summary (Right Column) -->
            <div class="w-full lg:w-4/12 px-4">
              <div class="bg-white rounded-lg shadow-sm p-6 sticky top-4">
                <h2 class="text-xl font-bold text-gray-800 mb-4">{{ t('order_summary') }}</h2>

                <!-- Cart Items Summary -->
                <div class="max-h-60 overflow-y-auto mb-4">
                  <div v-for="item in cartItems" :key="item.id" class="flex items-center py-2 border-b border-gray-100 last:border-0">
                    <div class="w-12 h-12 bg-gray-100 rounded overflow-hidden mr-3">
                      <img
                        v-if="item.product?.image"
                        :src="`${storageBase}/${item.product.image}`"
                        :alt="item.product.title"
                        class="w-full h-full object-cover"
                      />
                      <div v-else class="w-full h-full flex items-center justify-center text-gray-400 text-xs">
                        {{ t('no_image') }}
                      </div>
                    </div>
                    <div class="flex-1">
                      <h4 class="text-sm font-medium text-gray-800 line-clamp-1">
                         {{ currentLanguage === 'ar' && item.product?.title_ar ? item.product?.title_ar : item.product?.title }}
                     </h4>
                      <p class="text-xs text-gray-500">{{ getQuantityDisplay(item) }}</p>
                    </div>
                    <div class="text-sm font-medium text-gray-800">
                      {{ formatPrice(getItemTotal(item)) }}
                    </div>
                  </div>
                </div>

                <!-- Totals -->
                <div class="space-y-3 pt-4 border-t border-gray-200">
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('subtotal') }}:</span>
                    <span class="text-gray-800">{{ formatPrice(calculatedSubtotal) }}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('shipping') }}:</span>
                    <span class="text-gray-800">{{ formatPrice(form.shipping_cost || 0) }}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">{{ t('tax') }} (14% VAT):</span>
                    <span class="text-gray-800">{{ formatPrice(calculatedTax) }}</span>
                  </div>
                  <div v-if="discount > 0" class="flex justify-between text-sm text-green-600">
                    <span>{{ t('discount') }}:</span>
                    <span>-{{ formatPrice(discount) }}</span>
                  </div>
                  <div class="flex justify-between text-lg font-bold pt-3 border-t border-gray-200">
                    <span>{{ t('total') }}:</span>
                    <span class="text-green-600">{{ formatPrice(calculatedTotal) }}</span>
                  </div>
                </div>

                <!-- Discount Code -->
                <div class="mt-4">
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    {{ t('discount_code') }}
                  </label>
                  <div class="flex">
                    <input
                      v-model="discountCode"
                      type="text"
                      class="flex-1 px-2 py-2 border border-gray-300 rounded-l-lg focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                      :placeholder="t('enter_code')"
                    />
                    <button
                      @click="applyDiscount"
                      class="px-3 py-2 bg-gray-100 border border-l-0 border-gray-300 rounded-r-lg text-gray-700 hover:bg-gray-200 transition"
                    >
                      {{ t('apply') }}
                    </button>
                  </div>
                </div>

                <!-- Secure Checkout Badge -->
                <div class="mt-6 pt-6 border-t border-gray-200 text-center">
                  <div class="flex items-center justify-center text-gray-600 text-sm">
                    <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                    </svg>
                    <span>{{ t('secure_checkout') }}</span>
                  </div>
                  <p class="text-xs text-gray-500 mt-1">{{ t('secure_checkout_message') }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Stripe Return Handler -->
      <div v-if="isVerifyingSession" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg p-8 text-center">
          <div class="animate-spin rounded-full h-12 w-12 border-4 border-green-600 border-t-transparent mx-auto mb-4"></div>
          <p class="text-gray-600">{{ t('verifying_payment') }}</p>
        </div>
      </div>
    </div>
  </home-layout>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useToast } from "vue-toastification";
import { useStore } from 'vuex';
import HomeLayout from "../components/HomeLayout.vue";
import { useLanguage } from '../composables/useLanguage';

const router = useRouter();
const route = useRoute();
const store = useStore();
const toast = useToast();
const { currentLanguage, currentDirection, t, formatPrice } = useLanguage();

// State
const currentStep = ref(1);
const isLoading = ref(false);
const isSubmitting = ref(false);
const isPlacingOrder = ref(false);
const isVerifyingSession = ref(false);
const billingSameAsShipping = ref(true);
const discount = ref(0);
const discountCode = ref('');
const discountData = ref(null);
const errors = ref({});

// Store getters
const cartItems = computed(() => store.state.cart?.items || []);

// Unit configuration
const unitLabels = {
  kg: { en: "kg", ar: "كجم", isWeight: true },
  g: { en: "g", ar: "جم", isWeight: true },
  piece: { en: "piece", ar: "قطعة", isWeight: false },
  liter: { en: "liter", ar: "لتر", isWeight: false },
  pack: { en: "pack", ar: "حزمة", isWeight: false },
  bunch: { en: "bunch", ar: "حزمة", isWeight: false }
};

const getUnitLabel = (unit) => {
  const config = unitLabels[unit] || unitLabels.kg;
  return currentLanguage.value === "ar" ? config.ar : config.en;
};

// Get quantity display based on product unit
const getQuantityDisplay = (item) => {
  const unit = item.unit || item.product?.unit || 'kg';
  const quantityInGrams = item.quantity_grams;

  if (item.quantity_display) {
    return item.quantity_display;
  }

  if (unit === 'kg') {
    const kgValue = quantityInGrams / 1000;
    return `${kgValue.toFixed(2)} ${getUnitLabel(unit)}`;
  }

  if (unit === 'g') {
    return `${Math.round(quantityInGrams)} ${getUnitLabel(unit)}`;
  }

  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    const pieceValue = Math.round(quantityInGrams);
    return `${pieceValue} ${getUnitLabel(unit)}${pieceValue !== 1 ? 's' : ''}`;
  }

  if (unit === 'liter') {
    const literValue = quantityInGrams / 1000;
    return `${literValue.toFixed(2)} ${getUnitLabel(unit)}`;
  }

  return `${quantityInGrams} ${getUnitLabel(unit)}`;
};

// Get price per unit
const getPricePerUnit = (item) => {
  const unit = item.unit || item.product?.unit || 'kg';

  // Use price_per_unit from API if available
  if (item.price_per_unit && item.price_per_unit > 0) {
    return parseFloat(item.price_per_unit);
  }

  // Calculate based on unit type
  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    const price = item.product?.sale_price || item.product?.price || item.price_at_add || 0;
    return parseFloat(price);
  }

  if (unit === 'kg') {
    return parseFloat(item.price_at_add || item.product?.sale_price || item.product?.price || 0);
  }

  if (unit === 'g') {
    const pricePerKg = parseFloat(item.price_at_add || item.product?.sale_price || item.product?.price || 0);
    return pricePerKg / 1000;
  }

  return parseFloat(item.price_at_add || 0);
};

// Get quantity in product's natural unit
const getQuantityValue = (item) => {
  const unit = item.unit || item.product?.unit || 'kg';
  const quantityInGrams = item.quantity_grams;

  if (item.quantity_value) {
    return item.quantity_value;
  }

  if (unit === 'piece' || unit === 'pack' || unit === 'bunch') {
    return Math.round(quantityInGrams);
  }

  if (unit === 'kg') {
    return quantityInGrams / 1000;
  }

  if (unit === 'liter') {
    return quantityInGrams / 1000;
  }

  return quantityInGrams;
};

// Get total for a single item
const getItemTotal = (item) => {
  if (item.total_price && item.total_price > 0) {
    return parseFloat(item.total_price);
  }

  const pricePerUnit = getPricePerUnit(item);
  const quantity = getQuantityValue(item);
  return pricePerUnit * quantity;
};

// Calculate subtotal from items
const calculatedSubtotal = computed(() => {
  let subtotal = 0;
  for (const item of cartItems.value) {
    subtotal += getItemTotal(item);
  }
  return subtotal;
});

// Calculate tax (14% VAT)
const calculatedTax = computed(() => {
  return calculatedSubtotal.value * 0.14;
});

// Calculate total
// const calculatedTotal = computed(() => {
//   return calculatedSubtotal.value + calculatedTax.value + (form.value.shipping_cost || 0);
// });
const calculatedTotal = computed(() => {
  const subtotal = calculatedSubtotal.value;
  const tax = calculatedTax.value;
  const shipping = form.value.shipping_cost || 0;
  const discountAmount = discount.value || 0;
  return subtotal + tax + shipping - discountAmount;
});

// For backward compatibility
const subtotal = calculatedSubtotal;
const tax = calculatedTax;
const total = calculatedTotal;

// Steps
const steps = [
  { key: 'shipping_info' },
  { key: 'shipping_method' },
  { key: 'payment' }
];

// Shipping methods
const shippingMethods = ref([
  { id: 'standard', name: 'standard_shipping', description: 'standard_desc', cost: 6 },
  { id: 'express', name: 'express_shipping', description: 'express_desc', cost: 12 },
  { id: 'next_day', name: 'next_day_delivery', description: 'next_day_delivery_desc', cost: 20 }
]);

// Form data
const form = ref({
  payment_method: '',
  shipping_method: '',
  shipping_cost: 0,
  shipping_address: {
    name: '',
    email: '',
    phone: '',
    address_line1: '',
    address_line2: '',
    city: '',
    state: '',
    postal_code: '',
    country: 'EG'
  },
  billing_address: null,
  customer_notes: '',
  shipping_notes: '',
  discount_code: ''

});

// Handle Stripe return
const handleStripeReturn = async () => {
  const sessionId = route.query.session_id;

  if (sessionId) {
    isVerifyingSession.value = true;

    try {
      const response = await store.dispatch('orders/verifyStripeSession', sessionId);

      if (response.success) {
        toast.success(t('payment_successful'));
        router.push(`/order-confirmation/${response.order.order_number}`);
      } else {
        toast.error(t('payment_failed'));
        router.push('/checkout');
      }
    } catch (error) {
      console.error('Failed to verify session:', error);
      toast.error(t('verification_failed'));
      router.push('/checkout');
    } finally {
      isVerifyingSession.value = false;
    }
  }
};

// Fetch checkout summary
const fetchCheckoutSummary = async () => {
  isLoading.value = true;
  try {
    await store.dispatch('orders/fetchCheckoutSummary');
  } catch (error) {
    console.error('Failed to fetch checkout summary:', error);
  } finally {
    isLoading.value = false;
  }
};

// Load user data
const loadUserData = () => {
  const user = store.state.user;
  if (user) {
    form.value.shipping_address.name = user.name || '';
    form.value.shipping_address.email = user.email || '';
    form.value.shipping_address.phone = user.phone || '';
  }
};

// Validation
const validateStep1 = () => {
  errors.value = {};
  const addr = form.value.shipping_address;

  if (!addr.name?.trim()) errors.value['shipping_address.name'] = [t('name_required')];
  if (!addr.email?.trim()) errors.value['shipping_address.email'] = [t('email_required')];
  else if (!/^\S+@\S+\.\S+$/.test(addr.email)) errors.value['shipping_address.email'] = [t('email_invalid')];
  if (!addr.phone?.trim()) errors.value['shipping_address.phone'] = [t('phone_required')];
  if (!addr.address_line1?.trim()) errors.value['shipping_address.address_line1'] = [t('address_required')];
  if (!addr.city?.trim()) errors.value['shipping_address.city'] = [t('city_required')];
  if (!addr.country?.trim()) errors.value['shipping_address.country'] = [t('country_required')];

  return Object.keys(errors.value).length === 0;
};

// Navigation
const nextStep = () => {
  if (currentStep.value === 1 && !validateStep1()) {
    return;
  }

  if (currentStep.value < steps.length) {
    currentStep.value++;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
};

const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
};

// Selection methods
const selectShippingMethod = (method) => {
  form.value.shipping_method = method.id;
  form.value.shipping_cost = method.cost;
};

const selectPaymentMethod = (method) => {
  form.value.payment_method = method;
};

// Apply discount
const applyDiscount = async () => {
  if (!discountCode.value.trim()) {
    toast.warning(t('enter_discount_code'));
    return;
  }

  try {
    // Pass both discount code and subtotal as parameters
    const response = await store.dispatch('orders/applyDiscountCode', {
      code: discountCode.value,
      subtotal: calculatedSubtotal.value
    });

    // Update discount data from response
    if (response?.discount) {
      discount.value = response.discount.amount;
      discountData.value = response.discount;
      toast.success(t('discount_applied'));
    }
  } catch (error) {
    // Reset discount on error
    discount.value = 0;
    discountData.value = null;
    toast.error(error.response?.data?.message || t('invalid_discount_code'));
  }
};

// Place order
const placeOrder = async () => {
  if (!form.value.payment_method) {
    toast.warning(t('select_payment_method'));
    return;
  }

  // Validate minimum amount for Stripe
  if (form.value.payment_method === 'stripe' && calculatedTotal.value < 25) {
    toast.error(t('minimum_amount_error', { amount: formatPrice(25) }));
    return;
  }

  isPlacingOrder.value = true;

  // Prepare final form data
  if (billingSameAsShipping.value) {
    form.value.billing_address = null;
  }

  // Include discount code if applied
  if (discountData.value) {
    form.value.discount_code = discountData.value.code;
  }

  try {
    const response = await store.dispatch('orders/processCheckout', form.value);

    if (response.payment_method === 'stripe' && response.checkout_url) {
      window.location.href = response.checkout_url;
    } else if (response.payment_method === 'cash_on_delivery') {
      toast.success(t('order_placed_success'));
      router.push(`/order-confirmation/${response.order.order_number}`);
    }
  } catch (error) {
    console.error('Checkout failed:', error);

    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors;
      const firstError = Object.values(error.response.data.errors)[0]?.[0];
      if (firstError) toast.error(firstError);
    } else if (error.response?.data?.message) {
      toast.error(error.response.data.message);
    } else if (error.response?.data?.error) {
      toast.error(error.response.data.error);
    }
  } finally {
    isPlacingOrder.value = false;
  }
};

// Lifecycle
onMounted(async () => {
  await fetchCheckoutSummary();
  await loadUserData();
  await handleStripeReturn();
});

// Watch for route changes
watch(() => route.query, handleStripeReturn, { deep: true });

const storageBase = import.meta.env.VITE_STORAGE_URL || "http://localhost:8000/";
</script>
