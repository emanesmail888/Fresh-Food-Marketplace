import { ref, computed } from 'vue';
import ar from '../lang/ar.js';
import en from '../lang/en.js';


// Language configurations
export const languages = {
  ar: {
    name: 'العربية',
    flag: '🇸🇦',
    dir: 'rtl',
    translations: ar
  },
  en: {
    name: 'English',
    flag: '🇬🇧',
    dir: 'ltr',
    translations: en
  },

};

// Create a global language state
const currentLanguage = ref('en');

// Translation function
export const t = (key) => {
  const translations = languages[currentLanguage.value]?.translations;
  return translations?.[key] || languages.en.translations[key] || key;
};

// Format price based on language
export const formatPrice = (value) => {
  if (value === undefined || value === null) return currentLanguage.value === 'ar' ? '٠٫٠٠ ج.م' : '0.00 EGP';

  return new Intl.NumberFormat(currentLanguage.value === 'ar' ? 'ar-EG' : 'en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }).format(value) + (currentLanguage.value === 'ar' ? ' ج.م' : ' EGP');
};

// Format weight based on language
export const formatWeight = (grams) => {
  if (!grams || grams <= 0) return currentLanguage.value === 'ar' ? '٠ جم' : '0 g';

  const kg = grams / 1000;

  if (kg < 0.1) {
    return currentLanguage.value === 'ar'
      ? `${new Intl.NumberFormat('ar-EG').format(Math.round(grams))} جم`
      : `${Math.round(grams)} g`;
  }
  if (kg < 1) {
    return currentLanguage.value === 'ar'
      ? `${new Intl.NumberFormat('ar-EG').format(kg)} كجم`
      : `${kg.toFixed(2)} kg`;
  }
  return currentLanguage.value === 'ar'
    ? `${new Intl.NumberFormat('ar-EG').format(kg)} كجم`
    : `${kg.toFixed(kg % 1 === 0 ? 0 : 2)} kg`;
};

 export const formatDate = (dateString) => {
    if (!dateString) return '';

    const date = new Date(dateString);
    const options = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };

    return date.toLocaleDateString(
      currentLanguage.value === 'ar' ? 'ar-EG' : 'en-US',
      options
    );
  };
// Language change function
export const changeLanguage = (lang) => {
  if (languages[lang]) {
    currentLanguage.value = lang;

    // Update document direction and language
    document.documentElement.dir = languages[lang].dir;
    document.documentElement.lang = lang;

    // Store preference
    localStorage.setItem('preferred-language', lang);

    // Dispatch event for other components
    window.dispatchEvent(new CustomEvent('language-changed', { detail: lang }));
  }
};

// Load saved language
export const loadSavedLanguage = () => {
  const saved = localStorage.getItem('preferred-language');
  if (saved && languages[saved]) {
    currentLanguage.value = saved;
    document.documentElement.dir = languages[saved].dir;
    document.documentElement.lang = saved;
  }
};

// Initialize on load
loadSavedLanguage();

export function useLanguage() {
  return {
    currentLanguage: computed(() => currentLanguage.value),
    currentDirection: computed(() => languages[currentLanguage.value]?.dir || 'ltr'),
    currentLanguageName: computed(() => languages[currentLanguage.value]?.name || 'English'),
    currentLanguageFlag: computed(() => languages[currentLanguage.value]?.flag || '🇬🇧'),
    languages,
    t,
    formatPrice,
    formatWeight,
    changeLanguage,
    loadSavedLanguage,
    formatDate
  };
}
