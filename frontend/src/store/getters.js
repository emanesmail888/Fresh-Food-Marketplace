import { useLanguage } from '../composables/useLanguage';

const {currentLanguage } = useLanguage();

export default {
  isAuthenticated: (state) => !!state.user?.token,



  // Cart getters
  cartItems: (state) => state.cart?.items || [],
  cartCount: (state) => {
    // Count based on quantity display value
    const items = state.cart?.items || [];
    let totalCount = 0;

    items.forEach(item => {
      // For piece-based items, count each piece
      if (['piece', 'pack', 'bunch'].includes(item.unit)) {
        totalCount += item.quantity_value || item.quantity_grams;
      } else {
        // For weight-based items, count as 1 item per product
        totalCount += 1;
      }
    });

    return totalCount;
  },

  cartSubtotal: (state) => state.cart?.summary?.subtotal || 0,
  cartTotal: (state) => state.cart?.summary?.total || 0,
  cartTax: (state) => state.cart?.summary?.tax || 0,
  cartTotalKg: (state) => state.cart?.summary?.total_items || 0,
  cartTotalDisplay: (state) => state.cart?.summary?.total_items_display || '0',

  isLoading: (state) => state.cart?.loading || false,
  cartError: (state) => state.cart?.error || null,
  hasItems: (state) => state.cart?.items?.length > 0,
  isGuestCart: (state) => !state.user?.token && state.cart?.items?.length > 0,

  // Get cart item by product ID
  getCartItemByProductId: (state) => (productId) => {
    return state.cart?.items?.find(item => item.product_id === productId) || null;
  },

  // Get quantity for a specific product in proper unit
  getProductQuantity: (state) => (productId) => {
    const item = state.cart?.items?.find(item => item.product_id === productId);
    if (!item) return 0;

    // Return quantity_value if available (the unit-specific value)
    return item.quantity_value !== undefined ? item.quantity_value : item.quantity_grams;
  },

  // Get formatted quantity string for a product
  getFormattedQuantity: (state) => (productId) => {
    const item = state.cart?.items?.find(item => item.product_id === productId);
    if (!item) return '0';

    return item.quantity_display || `${item.quantity_value || item.quantity_grams} ${item.unit_label || item.unit}`;
  },

  isUpdating: (state) => (id) => {
    // Check if cart exists
    if (!state.cart) return false;

    // Check if updatingItems exists and is a Set
    if (state.cart.updatingItems instanceof Set) {
      return state.cart.updatingItems.has(id);
    }

    // Fallback: if it's an array, check includes
    if (Array.isArray(state.cart.updatingItems)) {
      return state.cart.updatingItems.includes(id);
    }

    // Fallback: if it's a plain object, check property
    if (state.cart.updatingItems && typeof state.cart.updatingItems === 'object') {
      return !!state.cart.updatingItems[id];
    }

    return false;
  },



  // Formatted payment method
  formattedPaymentMethod: (state) => (method) => {
    const methods = {
      'stripe':currentLanguage.value === 'ar' ?'بطاقة ائتمان / خصم' : 'Credit/Debit Card',
      'cash_on_delivery':currentLanguage.value === 'ar' ? 'الدفع عند الاستلام':'Cash on Delivery',
      'bank_transfer': currentLanguage.value === 'ar' ? 'تحويل بنكي':'Bank Transfer'

    };
    return methods[method] || method;
  },

  // Formatted payment status
  formattedPaymentStatus: (state) => (status) => {
    const statuses = {
    'unpaid': currentLanguage.value === 'ar' ? 'غير مدفوع' : 'Unpaid',
    'paid': currentLanguage.value === 'ar' ? 'مدفوع' : 'Paid',
    'failed': currentLanguage.value === 'ar' ? 'فشل' : 'Failed',
    'refunded': currentLanguage.value === 'ar' ? 'مسترد' : 'Refunded',
    'pending': currentLanguage.value === 'ar' ? 'قيد الانتظار' : 'Pending',
    'on_hold': currentLanguage.value === 'ar' ? 'قيد الإيقاف' : 'On Hold'


    };
    return statuses[status] || status;
  },

  // Payment status class for styling
  paymentStatusClass: (state) => (status) => {
    const classes = {
      'unpaid': 'text-orange-600',
      'paid': 'text-green-600',
      'failed': 'text-red-600',
      'refunded': 'text-gray-600',
      'pending': 'text-blue-600',
      'on_hold': 'text-yellow-600'
    };
    return classes[status] || 'text-gray-600';
  },

  // Order status class
  orderStatusClass: (state) => (status) => {
    const classes = {
      'pending': 'text-yellow-600',
      'processing': 'text-blue-600',
      'completed': 'text-green-600',
      'cancelled': 'text-red-600',
      'refunded': 'text-gray-600'
    };
    return classes[status] || 'text-gray-600';
  },

  // Get unit label for display
  getUnitLabel: (state) => (unit) => {
    const labels = {

    'kg': currentLanguage.value === 'ar' ?  'كجم': 'kg',
    'g': currentLanguage.value === 'ar' ?'جم': 'g',
    'piece': currentLanguage.value === 'ar' ? 'قطعة': 'piece',
    'liter': currentLanguage.value === 'ar' ?'لتر': 'liter',
    'pack': currentLanguage.value === 'ar' ? 'حزمة': 'pack',
    'bunch': currentLanguage.value === 'ar' ? 'حزمة' : 'bunch',
    };
    return labels[unit] || unit;
  },



  homeProducts: (state) => state.homeProducts,
  homeCategories: (state) => state.allCategories,
  homeSeeds: (state) => state.homeSeedsProducts,
  homeServices: (state) => state.HomeServices,
  homeSettings: (state) => state.homeSettings,
  isHomeLoading: (state) => state.homeLoading,
  homeError: (state) => state.homeError,
  isDataLoaded: state => state.isDataLoaded,



};
