import axiosClient from "../axios";
import {
  setSessionData,
  getSessionData,
  hasValidSessionData,
  SessionStorageKeys
} from '../utils/sessionStorage';

export function getCurrentUser({ commit }, data) {
    return axiosClient.get('/user', { params: data })
        .then(({ data }) => {
            commit('setUser', data);
            return data;
        })
}

export function login({ commit }, data) {


    return axiosClient.post('/login', data)
        .then(({ data }) => {
            commit('setUser', data.user);
            commit('setToken', data.token)
            //   localStorage.setItem('TOKEN', token)
            try {
                dispatch('mergeCart', null, { root: true });
            } catch (cartError) {
                console.warn('Cart merge error:', cartError);
            }
            return data;
        })
}

export function register({ commit }, data) {
    return axiosClient.post('/register', data)
        .then(({ data }) => {
            commit('setUser', data.user);
            commit('setToken', data.token);

            try {
                dispatch('mergeCart', null, { root: true });
            } catch (cartError) {
                console.warn('Cart merge error:', cartError);
            }
            return data;
        })
};

export function logout({ commit }) {
    return axiosClient.post('/logout')
        .then((response) => {
            commit('setToken', null)

            return response;
        })
}



export function getAllCategories({ commit }) {
    return axiosClient.get('all_categories')
        .then(({ data }) => {
            commit('setAllCategories', data)
        })
}


export function getHomeSettings({ commit }) {
    return axiosClient.get('home')
        .then(({ data }) => {
            commit('SET_HOME_SETTINGS', data.home_settings)
        })
}
export function getAboutSettings({ commit }) {
    return axiosClient.get('about')
        .then(({ data }) => {
            commit('SET_ABOUT_SETTINGS', data.about_settings)
        })
}


export const getShopProducts = async ({ commit }, { page = 1, per_page = 12, search = "", sort_field = "created_at", sort_direction = "desc" }) => {
  commit("SET_SHOP_PRODUCTS_LOADING", true);

  try {
    const response = await axiosClient.get("/shop", {
      params: {
        page,
        per_page,
        search,
        sort_field,
        sort_direction
      }
    });

    commit("SET_SHOP_PRODUCTS", {
      data: response.data.data,
      current_page: response.data.meta.current_page,
      last_page: response.data.meta.last_page,
      per_page: response.data.meta.per_page,
      total: response.data.meta.total,
      from: response.data.meta.from,
      to: response.data.meta.to
    });
  } catch (error) {
    commit("SET_SHOP_PRODUCTS_ERROR", error.message);
    console.error("Error fetching products:", error);
  } finally {
    commit("SET_SHOP_PRODUCTS_LOADING", false);
  }
};



export function getProducts({ commit, state }, { url = null, search = '', per_page, sort_field, sort_direction } = {}) {
    commit('setProducts', [true])
    url = url || '/products'
    const params = {
        per_page: state.products.limit,
    }
    return axiosClient.get(url, {
        params: {
            ...params,
            search, per_page, sort_field, sort_direction
        }
    })
        .then((response) => {
            commit('setProducts', [false, response.data])
        })
        .catch(() => {
            commit('setProducts', [false])
        })
}

export function getCategories({ commit, state }, { url = null, search = '', per_page, sort_field, sort_direction } = {}) {
    commit('setCategories', [true])
    url = url || '/categories'
    const params = {
        per_page: state.categories.limit,
    }
    return axiosClient.get(url, {
        params: {
            ...params,
            search, per_page, sort_field, sort_direction
        }
    })
        .then((response) => {
            commit('setCategories', [false, response.data])
        })
        .catch(() => {
            commit('setCategories', [false])
        })
}

export function getProduct({ commit }, id) {
    return axiosClient.get(`/products/${id}`)
}
export function getCategory({ commit }, id) {
    return axiosClient.get(`/categories/${id}`)
}

export function createProduct({ commit }, product) {
    // Prepare payload — FormData if there's any file, otherwise plain object
    let payload = product;

    // If there's a main image OR gallery images → switch to FormData
    if (product.image instanceof File || (product.images && product.images.length > 0)) {
        const form = new FormData();

        // Text / number fields
        form.append('title', product.title || '');
        form.append('title_ar', product.title_ar || '');
        form.append('slug', product.slug || '');
        form.append('description', product.description || '');
        form.append('description_ar', product.description_ar || '');
        form.append('price', product.price ?? '');
        form.append('sale_price', product.sale_price ?? '');
        form.append('stock', product.stock ?? 0);
        form.append('unit', product.unit ?? 'kg');
        form.append('category_id', product.category_id ?? '');
        form.append('new_arrival', product.new_arrival ? '1' : '0');

        // Main image (single file)
        if (product.image instanceof File) {
            form.append('image', product.image);
        }

        // Multiple gallery images (array of Files)
        if (product.images && Array.isArray(product.images)) {
            product.images.forEach((file, index) => {
                if (file instanceof File) {
                    form.append(`images[${index}]`, file);
                }
            });
        }

        payload = form;
    }

    // Send request
    return axiosClient.post('/products', payload, {
        headers: {
            'Content-Type': 'multipart/form-data'   // good practice when using FormData
        }
    })
        .then(response => {
            // Optional: commit something to store on success
            // commit('addProduct', response.data); // if you have such mutation
            return response; // return for chaining .then() in component
        })
        .catch(error => {
            console.error('Create product failed:', error);
            throw error; // let component handle error (show toast, etc.)
        });
}
export function createCategory({ commit }, category) {
    // Prepare payload — FormData if there's any file, otherwise plain object
    let payload = category;

    // If there's a main image OR gallery images → switch to FormData
    if (category.image instanceof File) {
        const form = new FormData();

        // Text / number fields
        form.append('name', category.name || '');
        form.append('name_ar', category.name_ar || '');

        // Main image (single file)
        if (category.image instanceof File) {
            form.append('image', category.image);
        }



        payload = form;
    }

    // Send request
    return axiosClient.post('/categories', payload, {
        headers: {
            'Content-Type': 'multipart/form-data'   // good practice when using FormData
        }
    })
        .then(response => {
            // Optional: commit something to store on success
            // commit('addCategory', response.data); // if you have such mutation
            return response; // return for chaining .then() in component
        })
        .catch(error => {
            console.error('Create category failed:', error);
            throw error; // let component handle error (show toast, etc.)
        });
}


export function deleteProduct({ commit }, id) {
    return axiosClient.delete(`/products/${id}`)
}

export function deleteCategory({ commit }, id) {
    return axiosClient.delete(`/categories/${id}`)
}

// export function getUsers({ commit, state }, { url = null, search = '', per_page, sort_field, sort_direction } = {}) {
//     commit('setUsers', [true])
//     url = url || '/users'
//     const params = {
//         per_page: state.users.limit,
//     }
//     return axiosClient.get(url, {
//         params: {
//             ...params,
//             search, per_page, sort_field, sort_direction
//         }
//     })
//         .then((response) => {
//             commit('setUsers', [false, response.data])
//         })
//         .catch(() => {
//             commit('setUsers', [false])
//         })
// }

// export function createUser({ commit }, user) {
//     return axiosClient.post('/users', user)
// }

// export function updateUser({ commit }, user) {
//     return axiosClient.put(`/users/${user.id}`, user)
// }


export function updateProduct({ commit }, { id, product }) {
    const form = new FormData();

    // Always send _method for Laravel
    form.append("_method", "PUT");

    // Text / number fields – safe defaults
    form.append("title", product.title?.trim() || "");
    form.append("title_ar", product.title_ar?.trim() || "");
    form.append("slug", product.slug?.trim() || "");
    form.append("description", product.description?.trim() || "");
    form.append("description_ar", product.description_ar?.trim() || "");
    form.append("price", product.price ?? "");
    form.append("sale_price", product.sale_price ?? "");
    form.append("stock", product.stock ?? 0);
    form.append("unit", product.unit ?? "kg");
    form.append("category_id", product.category_id ?? "");
    form.append("new_arrival", product.new_arrival ? "1" : "0");

    // Main image – only if new file
    if (product.image instanceof File) {
        form.append("image", product.image);
    }

    // Gallery images – only if new files
    if (product.images && Array.isArray(product.images)) {
        product.images.forEach((file, index) => {
            if (file instanceof File) {
                form.append(`images[${index}]`, file);
            }
        });
    }

    return axiosClient.post(`/products/${id}`, form, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    });
}
export function updateCategory({ commit }, { id, category }) {
    const form = new FormData();

    form.append("_method", "PUT");

    // Text / number fields – safe defaults
    form.append("name", category.name?.trim() || "");
    form.append("name_ar", category.name_ar?.trim() || "");


    // Main image – only if new file
    if (category.image instanceof File) {
        form.append("image", category.image);
    }


    return axiosClient.post(`/categories/${id}`, form, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    });
}

export const getHomeSeedsProducts=async({ commit }) =>{
    commit('SET_HOME_SEEDS_LOADING', true)
    commit('SET_HOME_SEEDS_ERROR', null)

    try {
      const response = await axiosClient.get('home')
      commit('SET_HOME_SEEDS_PRODUCTS', response.data.seeds_products || [])
    } catch (error) {
      console.error('Failed to fetch seeds products:', error)
      commit('SET_HOME_SEEDS_ERROR', error.response?.data?.message || 'Failed to load products')
    } finally {
      commit('SET_HOME_SEEDS_LOADING', false)
    }
  };

  export const getHomeProducts=async({ commit }) =>{
     commit('SET_HOME_PRODUCTS_LOADING', true)
    commit('SET_HOME_PRODUCTS_ERROR', null)
    try {
      const response = await axiosClient.get('home')
      commit('SET_HOME_PRODUCTS', response.data.products || [])
    } catch (error) {
      console.error('Failed to fetch products:', error)
      commit('SET_HOME_PRODUCTS_ERROR', error.response?.data?.message || 'Failed to load products')
    } finally {
      commit('SET_HOME_PRODUCTS_LOADING', false)
    }
  };
  export const getHomeServices=async({ commit }) =>{
     commit('SET_HOME_SERVICES_LOADING', true)
    commit('SET_HOME_SERVICES_ERROR', null)
    try {
      const response = await axiosClient.get('home')
      commit('SET_HOME_SERVICES', response.data.services || [])
    } catch (error) {
      console.error('Failed to fetch Services:', error)
      commit('SET_HOME_SERVICES_ERROR', error.response?.data?.message || 'Failed to load Services')
    } finally {
      commit('SET_HOME_SERVICES_LOADING', false)
    }
  };



  export const fetchHomeData = async ({ commit,state }) => {

    if (state.isDataLoaded) {
    return;
  }
  commit('SET_HOME_GLOBAL_LOADING', true);
  commit('SET_HOME_ERROR', null);

  try {
    const response = await axiosClient.get('home');

    commit('SET_HOME_PRODUCTS', response.data.products || []);
    commit('SET_HOME_SEEDS_PRODUCTS', response.data.seeds_products || []);
    commit('SET_HOME_GREEN_VEGETABLES_PRODUCTS', response.data.green_vegetables_products || []);
    commit('SET_HOME_CATEGORIES', response.data.categories || []);
    commit('SET_HOME_SERVICES', response.data.services || []);
    commit('SET_HOME_SETTINGS', response.data.home_settings || {});
    commit('SET_FOOTER_SETTINGS', response.data.footer_settings || {});
    commit('SET_IS_DATA_LOADED', true);

    // Save timestamp for cache management
    setSessionData(SessionStorageKeys.HOME_DATA_TIMESTAMP, Date.now());

  } catch (error) {
    console.error('Failed to fetch home data:', error);
    commit('SET_HOME_ERROR', error.response?.data?.message || 'Failed to load home page');
  } finally {
    commit('SET_HOME_GLOBAL_LOADING', false);
  }
};

// Check if session data is still valid (optional)
export const validateSessionData = ({ commit }) => {
  const timestamp = getSessionData(SessionStorageKeys.HOME_DATA_TIMESTAMP);
  if (timestamp) {
    const age = Date.now() - timestamp;
    const maxAge = 30 * 60 * 1000; // 30 minutes

    if (age > maxAge) {
      // Data is too old, clear it
      clearAllSessionData();
      commit('SET_IS_DATA_LOADED', false);
      return false;
    }
    return true;
  }
  return false;
};


// Helper to save cart to localStorage as backup
const saveCartToStorage = (cartState) => {
    try {
        const cartToSave = {
            items: cartState.items,
            summary: cartState.summary,
            lastFetched: Date.now()
        };
        localStorage.setItem('cart_backup', JSON.stringify(cartToSave));
    } catch (e) {
        console.error('Failed to save cart to storage:', e);
    }
};

export const fetchCart = async ({ commit, rootGetters, state }) => {
    // Don't fetch if we fetched recently (within last 30 seconds)
    const now = Date.now();
    //   if (state.cart?.lastFetched && (now - state.cart.lastFetched) < 1000) {
    //     console.log('Using cached cart data');
    //     return;
    //   }

    commit('SET_LOADING', true);
    commit('CLEAR_ERROR');

    try {
        const response = await axiosClient.get('/cart');
        const cartData = response.data.data;

        commit('SET_CART', cartData);

        // Save to localStorage as backup
        saveCartToStorage(cartData);

        return response.data;
    } catch (error) {
        console.error('Failed to fetch cart:', error);

        // Try to load from backup on error
        const backupCart = localStorage.getItem('cart_backup');
        if (backupCart) {
            try {
                const parsed = JSON.parse(backupCart);
                commit('SET_CART', parsed);
            } catch (e) {
                console.error('Failed to parse backup cart:', e);
            }
        }

        commit('SET_ERROR', 'فشل في تحميل السلة');
        throw error;
    } finally {
        commit('SET_LOADING', false);
    }
};

export const addItem = async ({ commit, state }, { productId, quantityGrams = 1000 }) => {
    commit('SET_LOADING', true);
    commit('CLEAR_ERROR');

    // Optimistic update - store current cart for rollback
    const previousCart = state.cart ? { ...state.cart } : null;

    try {
        const response = await axiosClient.post('/cart/items', {
            product_id: productId,
            quantity_grams: quantityGrams
        });

        // console.log('Add item API response:', response.data);

        if (response.data.data && response.data.data.cart) {
            commit('SET_CART', response.data.data.cart);
        } else {
            commit('ADD_ITEM', response.data.data);
        }

        // Save updated cart to localStorage
        saveCartToStorage(state.cart);

        return response.data;
    } catch (error) {
        // Rollback on error
        if (previousCart) {
            commit('SET_CART', previousCart);
        }

        const message = error.response?.data?.message || 'فشل في إضافة المنتج';
        commit('SET_ERROR', message);
        throw error;
    } finally {
        commit('SET_LOADING', false);
    }
};


export const updateQuantity = async ({ commit, state }, payload) => {
  // Destructure with correct parameter names
  const { itemId, quantityGrams } = payload;

//   console.log('updateQuantity action called:', { itemId, quantityGrams });

  if (!itemId) {
    console.error('No itemId provided to updateQuantity action');
    throw new Error('معرف المنتج مطلوب');
  }

  // Ensure updatingItems is a Set before setting status
  if (!(state.cart?.updatingItems instanceof Set)) {
    // Initialize if needed
    if (!state.cart) state.cart = {};
    if (!state.cart.updatingItems) state.cart.updatingItems = new Set();
  }

  commit('SET_UPDATING', { id: itemId, status: true });

  try {
    const response = await axiosClient.put(`/cart/items/${itemId}`, {
      quantity_grams: Math.round(quantityGrams)
    });

    // console.log('Update quantity response:', response.data);

    if (response.data.data && response.data.data.cart) {
      commit('SET_CART', response.data.data.cart);
    } else if (response.data.data) {
      commit('UPDATE_ITEM', response.data.data);
    }

    return response.data;
  } catch (error) {
    console.error('Update quantity error:', error);
    const message = error.response?.data?.message || 'فشل في تحديث الكمية';
    commit('SET_ERROR', message);
    throw error;
  } finally {
    commit('SET_UPDATING', { id: itemId, status: false });
  }
};
export const removeItem = async ({ commit, state }, itemId) => {
    commit('SET_LOADING', true);

    // Store previous state for rollback
    const previousCart = state.cart ? { ...state.cart } : null;

    try {
        const response = await axiosClient.delete(`/cart/items/${itemId}`);

        if (response.data.data && response.data.data.cart) {
            commit('SET_CART', response.data.data.cart);
        } else {
            const removedItemData = response.data.data || response.data;
            commit('REMOVE_ITEM', { itemId, data: removedItemData });
        }

        // Save to localStorage
        saveCartToStorage(state.cart);

        return response.data;
    } catch (error) {
        // Rollback on error
        if (previousCart) {
            commit('SET_CART', previousCart);
        }

        const message = error.response?.data?.message || 'فشل في حذف المنتج';
        commit('SET_ERROR', message);
        throw error;
    } finally {
        commit('SET_LOADING', false);
    }
};

export const clearCart = async ({ commit, state }) => {
    commit('SET_LOADING', true);

    // Store previous state for rollback
    const previousCart = state.cart ? { ...state.cart } : null;

    try {
        const response = await axiosClient.delete('/cart/clear');

        if (response.data.data && response.data.data.cart) {
            commit('SET_CART', response.data.data.cart);
        } else {
            commit('CLEAR_CART');
        }

        // Save to localStorage
        saveCartToStorage(state.cart);

        return response.data;
    } catch (error) {
        // Rollback on error
        if (previousCart) {
            commit('SET_CART', previousCart);
        }

        commit('SET_ERROR', 'فشل في إفراغ السلة');
        throw error;
    } finally {
        commit('SET_LOADING', false);
    }
};

// Merge guest cart after login
export const mergeCart = async ({ commit, dispatch }) => {
    commit('SET_LOADING', true);

    try {
        const response = await axiosClient.post('/cart/merge');
        commit('SET_CART', response.data.data);

        // Save to localStorage
        saveCartToStorage(response.data.data);

        // Clear backup
        localStorage.removeItem('cart_backup');

        return response.data;
    } catch (error) {
        console.error('Failed to merge cart:', error);
        throw error;
    } finally {
        commit('SET_LOADING', false);
    }
};

// Initialize cart from backup
export const initializeCartFromBackup = ({ commit }) => {
    const backupCart = localStorage.getItem('cart_backup');
    if (backupCart) {
        try {
            const parsed = JSON.parse(backupCart);
            commit('SET_CART', parsed);
            return true;
        } catch (e) {
            console.error('Failed to parse backup cart:', e);
        }
    }
    return false;
};

