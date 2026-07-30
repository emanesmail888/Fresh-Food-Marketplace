// utils/sessionStorage.js

export const SessionStorageKeys = {
  HOME_PRODUCTS: 'home_products',
  HOME_SEEDS_PRODUCTS: 'home_seeds_products',
  HOME_GREEN_VEGETABLES_PRODUCTS: 'home_green_vegetables_products',
  HOME_SERVICES: 'home_services',
  HOME_CATEGORIES: 'home_categories',
  HOME_SETTINGS: 'home_settings',
  FOOTER_SETTINGS: 'footer_settings',
  HOME_DATA_TIMESTAMP: 'home_data_timestamp',
  SHOP_PRODUCTS: 'shop_products',
  ABOUT_SETTINGS: 'about_settings',
};

// Set data with expiration (optional)
export const setSessionData = (key, data, expireInSeconds = null) => {
  try {
    const item = {
      data: data,
      timestamp: Date.now(),
    };

    if (expireInSeconds) {
      item.expiry = Date.now() + (expireInSeconds * 1000);
    }

    sessionStorage.setItem(key, JSON.stringify(item));
  } catch (error) {
    console.error('Error saving to session storage:', error);
  }
};

// Get data from session storage
export const getSessionData = (key) => {
  try {
    const item = sessionStorage.getItem(key);
    if (!item) return null;

    const parsedItem = JSON.parse(item);

    // Check if data has expired
    if (parsedItem.expiry && Date.now() > parsedItem.expiry) {
      sessionStorage.removeItem(key);
      return null;
    }

    return parsedItem.data;
  } catch (error) {
    console.error('Error reading from session storage:', error);
    return null;
  }
};

// Check if data exists and is not expired
export const hasValidSessionData = (key) => {
  try {
    const item = sessionStorage.getItem(key);
    if (!item) return false;

    const parsedItem = JSON.parse(item);

    if (parsedItem.expiry && Date.now() > parsedItem.expiry) {
      sessionStorage.removeItem(key);
      return false;
    }

    return true;
  } catch (error) {
    return false;
  }
};

// Clear specific session data
export const clearSessionData = (key) => {
  sessionStorage.removeItem(key);
};

// Clear all session data (optional)
export const clearAllSessionData = () => {
  Object.values(SessionStorageKeys).forEach(key => {
    sessionStorage.removeItem(key);
  });
};
