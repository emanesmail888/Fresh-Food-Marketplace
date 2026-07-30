import {
    setSessionData,
    getSessionData,
    hasValidSessionData,
    SessionStorageKeys
} from '../utils/sessionStorage.js';

const EXPIRY_30_MINUTES = 1800; // 30 minutes in seconds

export function setUser(state, user) {
    state.user.data = user;
    sessionStorage.setItem('user', JSON.stringify(user));
}

export function setToken(state, token) {
    state.user.token = token;
    if (token) {
        sessionStorage.setItem('TOKEN', token);

    } else {
        sessionStorage.removeItem('TOKEN')
    }
}

export function CLEAR_AUTH(state) {
    state.user = null;
    state.token = null;
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    //   delete axiosClient.defaults.headers.common['Authorization'];
}

export function setProducts(state, [loading, data = null]) {

    if (data) {
        state.products = {
            ...state.products,
            data: data.data,
            links: data.meta?.links,
            page: data.meta.current_page,
            limit: data.meta.per_page,
            from: data.meta.from,
            to: data.meta.to,
            total: data.meta.total,
        }
    }
    state.products.loading = loading;
}

export function SET_SHOP_PRODUCTS_LOADING(state, loading) {
    state.shopProducts.loading = loading;
}

export function SET_SHOP_PRODUCTS(state, payload) {
    state.shopProducts.data = payload.data;
    state.shopProducts.current_page = payload.current_page;
    state.shopProducts.last_page = payload.last_page;
    state.shopProducts.per_page = payload.per_page;
    state.shopProducts.total = payload.total;
    state.shopProducts.from = payload.from;
    state.shopProducts.to = payload.to;
    state.shopProducts.error = null;


    // ✅ Save to session storage with 30-minute expiry
    const shopData = {
        data: payload.data,
        current_page: payload.current_page,
        last_page: payload.last_page,
        per_page: payload.per_page,
        total: payload.total,
        from: payload.from,
        to: payload.to,
    };

    setSessionData(SessionStorageKeys.SHOP_PRODUCTS, shopData, EXPIRY_30_MINUTES);


}

export function RESTORE_SHOP_FROM_SESSION(state) {
    const shopData = getSessionData(SessionStorageKeys.SHOP_PRODUCTS);

    if (shopData) {
        state.shopProducts.data = shopData.data || [];
        state.shopProducts.current_page = shopData.current_page || 1;
        state.shopProducts.last_page = shopData.last_page || 1;
        state.shopProducts.per_page = shopData.per_page || 10;
        state.shopProducts.total = shopData.total || 0;
        state.shopProducts.from = shopData.from || null;
        state.shopProducts.to = shopData.to || null;
        state.shopProducts.error = null;

        console.log('✅ Shop products restored from session storage');
        return true;
    }

    console.log('⚠️ No shop products found in session storage');
    return false;
}

// ✅ New: Check if shop data exists in session
export function HAS_SHOP_SESSION_DATA() {
    return hasValidSessionData(SessionStorageKeys.SHOP_PRODUCTS);
}




export function SET_SHOP_PRODUCTS_ERROR(state, error) {
    state.shopProducts.error = error;
    state.shopProducts.loading = false;
}

export function setCategories(state, [loading, data = null]) {

    if (data) {
        state.categories = {
            ...state.categories,
            data: data.data,
            links: data.meta?.links,
            page: data.meta.current_page,
            limit: data.meta.per_page,
            from: data.meta.from,
            to: data.meta.to,
            total: data.meta.total,
        }
    }
    state.categories.loading = loading;
}

export function setUsers(state, [loading, data = null]) {

    if (data) {
        state.users = {
            ...state.users,
            data: data.data,
            links: data.meta?.links,
            page: data.meta.current_page,
            limit: data.meta.per_page,
            from: data.meta.from,
            to: data.meta.to,
            total: data.meta.total,
        }
    }
    state.products.loading = loading;
}



export function showToast(state, message) {
    state.toast.show = true;
    state.toast.message = message;
}

export function hideToast(state) {
    state.toast.show = false;
    state.toast.message = '';
}



export function setAllCategories(state, all_categories) {
    state.allCategories = all_categories.data;
}




//  setting the cart
export const SET_CART = (state, cartData) => {
    // console.log('SET_CART mutation received:', cartData);

    // Ensure updatingItems is always a Set
    if (!state.cart.updatingItems || !(state.cart.updatingItems instanceof Set)) {
        state.cart.updatingItems = new Set();
    }

    state.cart = {
        ...state.cart,
        ...cartData,
        items: cartData.items || [],
        lastFetched: Date.now()
    };
};

export const SET_LOADING = (state, status) => {
    if (!state.cart) state.cart = {
        items: [],
        summary: {},
        updatingItems: new Set()
    };
    state.cart.loading = status;
};

export const SET_ERROR = (state, error) => {
    if (!state.cart) state.cart = {
        items: [],
        summary: {},
        updatingItems: new Set()
    };
    state.cart.error = error;
};

export const CLEAR_ERROR = (state) => {
    if (state.cart) state.cart.error = null;
};

export const ADD_ITEM = (state, responseData) => {
    console.log('ADD_ITEM mutation received:', responseData);

    if (!state.cart) {
        state.cart = {
            items: [],
            summary: {},
            updatingItems: new Set()
        };
    }

    // Ensure updatingItems is a Set
    if (!(state.cart.updatingItems instanceof Set)) {
        state.cart.updatingItems = new Set();
    }

    if (responseData.cart) {
        state.cart = {
            ...state.cart,
            ...responseData.cart,
            items: responseData.cart.items || [],
            lastFetched: Date.now()
        };
    } else if (responseData.item) {
        const existingIndex = state.cart.items.findIndex(
            item => item.id === responseData.item.id
        );

        if (existingIndex !== -1) {
            state.cart.items[existingIndex] = responseData.item;
        } else {
            state.cart.items.push(responseData.item);
        }

        if (responseData.cart_summary) {
            state.cart.summary = responseData.cart_summary;
        }
        state.cart.lastFetched = Date.now();
    }
};

export const UPDATE_ITEM = (state, itemData) => {
    if (!state.cart) {
        state.cart = {
            items: [],
            summary: {},
            updatingItems: new Set()
        };
    }

    // Ensure updatingItems is a Set
    if (!(state.cart.updatingItems instanceof Set)) {
        state.cart.updatingItems = new Set();
    }

    const index = state.cart.items.findIndex(item => item.id === itemData.item?.id);

    if (index !== -1 && itemData.item) {
        state.cart.items[index] = itemData.item;
    }

    if (itemData.cart_summary) {
        state.cart.summary = itemData.cart_summary;
    }

    state.cart.lastFetched = Date.now();
};

export const REMOVE_ITEM = (state, {
    itemId,
    data
}) => {
    if (!state.cart) {
        state.cart = {
            items: [],
            summary: {},
            updatingItems: new Set()
        };
    }

    // Ensure updatingItems is a Set
    if (!(state.cart.updatingItems instanceof Set)) {
        state.cart.updatingItems = new Set();
    }

    state.cart.items = state.cart.items.filter(item => item.id !== itemId);

    if (data && data.cart_summary) {
        state.cart.summary = data.cart_summary;
    }

    state.cart.lastFetched = Date.now();
};

export const CLEAR_CART = (state) => {
    if (!state.cart) {
        state.cart = {
            items: [],
            summary: {},
            updatingItems: new Set()
        };
    }

    state.cart.items = [];
    state.cart.summary = {
        total_items_kg: 0,
        unique_products: 0,
        subtotal: 0,
        tax: 0,
        total: 0,
        shipping: 0
    };
    state.cart.lastFetched = Date.now();

    // Ensure updatingItems is a Set
    if (!(state.cart.updatingItems instanceof Set)) {
        state.cart.updatingItems = new Set();
    }
};

export const SET_UPDATING = (state, {
    id,
    status
}) => {
    // Initialize cart if it doesn't exist
    if (!state.cart) {
        state.cart = {
            items: [],
            summary: {},
            updatingItems: new Set()
        };
    }

    // Ensure updatingItems is a Set
    if (!(state.cart.updatingItems instanceof Set)) {
        // If it's an array, convert to Set
        if (Array.isArray(state.cart.updatingItems)) {
            state.cart.updatingItems = new Set(state.cart.updatingItems);
        } else {
            // Otherwise create new Set
            state.cart.updatingItems = new Set();
        }
    }

    if (status) {
        state.cart.updatingItems.add(id);
        // console.log('Added to updatingItems:', id, 'Set now has:', Array.from(state.cart.updatingItems));
    } else {
        state.cart.updatingItems.delete(id);
        // console.log('Removed from updatingItems:', id, 'Set now has:', Array.from(state.cart.updatingItems));
    }
};



// homeProducts

export const SET_HOME_PRODUCTS_LOADING = async (state, loading) => {
    state.homeProductsLoading = loading
};

export const SET_HOME_PRODUCTS = async (state, home_products) => {
    state.homeProducts = {
        data: home_products
    }
    setSessionData(SessionStorageKeys.HOME_PRODUCTS, home_products ,EXPIRY_30_MINUTES);

};

export const SET_HOME_PRODUCTS_ERROR = async (state, error) => {
    state.homeProductsError = error
};

//categories

export const SET_HOME_CATEGORIES = async (state, categories) => {
    state.HomeCategories = categories;
    setSessionData(SessionStorageKeys.HOME_CATEGORIES, categories ,EXPIRY_30_MINUTES);
};

//homeSeeds

export const SET_HOME_SEEDS_LOADING = async (state, loading) => {
    state.homeSeedsLoading = loading
};

export const SET_HOME_SEEDS_PRODUCTS = async (state, products) => {
    state.homeSeedsProducts = products
    setSessionData(SessionStorageKeys.HOME_SEEDS_PRODUCTS, products ,EXPIRY_30_MINUTES);

};

export const SET_HOME_SEEDS_ERROR = async (state, error) => {
    state.homeSeedsError = error
};
//homeVegetables
export const SET_HOME_GREEN_VEGETABLES_LOADING = async (state, loading) => {
    state.homeGreenVegetablesLoading = loading
};

export const SET_HOME_GREEN_VEGETABLES_PRODUCTS = async (state, products) => {
    state.homeGreenVegetablesProducts = products
    setSessionData(SessionStorageKeys.HOME_GREEN_VEGETABLES_PRODUCTS, products ,EXPIRY_30_MINUTES);

};

export const SET_GREEN_HOME_VEGETABLES_ERROR = async (state, error) => {
    state.homeGreenVegetablesError = error
};

//services
export const SET_HOME_SERVICES = async (state, services) => {
    state.homeServices = services;
    setSessionData(SessionStorageKeys.HOME_SERVICES, services ,EXPIRY_30_MINUTES);

};

export const SET_HOME_SERVICES_ERROR = async (state, error) => {
    state.homeServicesError = error
};

export const SET_HOME_SERVICES_LOADING = async (state, loading) => {
    state.homeServicesLoading = loading
};


//settings

export const SET_HOME_SETTINGS = async (state, settings) => {
    state.homeSettings = settings;
    setSessionData(SessionStorageKeys.HOME_SETTINGS, settings , EXPIRY_30_MINUTES);

};

export const SET_HOME_GLOBAL_LOADING = async (state, status) => {
    state.isHomeLoading = status;
};

export const SET_HOME_ERROR = async (state, error) => {
    state.homeError = error;
};


export const SET_FOOTER_SETTINGS = async (state, settings) => {
    state.footerSettings = settings;
    setSessionData(SessionStorageKeys.FOOTER_SETTINGS, settings , EXPIRY_30_MINUTES);

};

export const SET_ABOUT_SETTINGS = async (state, settings) => {
    state.aboutSettings = settings;
    setSessionData(SessionStorageKeys.ABOUT_SETTINGS, settings , EXPIRY_30_MINUTES);

};


export const SET_IS_DATA_LOADED=async(state, loaded) =>{
    state.isDataLoaded = loaded;
  };


  // Restore data from session storage
export const RESTORE_FROM_SESSION=async(state)=> {
const keys = [
    { key: SessionStorageKeys.HOME_PRODUCTS, mutation: 'SET_HOME_PRODUCTS' },
    { key: SessionStorageKeys.HOME_SEEDS_PRODUCTS, mutation: 'SET_HOME_SEEDS_PRODUCTS' },
    { key: SessionStorageKeys.HOME_SERVICES, mutation: 'SET_HOME_SERVICES' },
    { key: SessionStorageKeys.HOME_CATEGORIES, mutation: 'SET_HOME_CATEGORIES' },
    { key: SessionStorageKeys.HOME_SETTINGS, mutation: 'SET_HOME_SETTINGS' },
    { key: SessionStorageKeys.FOOTER_SETTINGS, mutation: 'SET_FOOTER_SETTINGS' },
    { key: SessionStorageKeys.ABOUT_SETTINGS, mutation: 'SET_ABOUT_SETTINGS' },
];

keys.forEach(({ key, mutation }) => {
    if (hasValidSessionData(key)) {
    const data = getSessionData(key);
    if (data) {
        state[mutation.replace('SET_', '').toLowerCase()] = data;
    }
    }
});
}





































