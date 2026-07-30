import HomeServices from "../components/HomeServices.vue";

export default {
    user: {
        token: sessionStorage.getItem('TOKEN'),
        data: {}
        // data: JSON.parse(localStorage.getItem('user')) || null, // Load user from local storage

    },
    products: {
        loading: false,
        data: [],
        links: [],
        from: null,
        to: null,
        page: 1,
        limit: null,
        total: null
    },


    cart: {
        items: [],
        summary: {
            total_items_kg: 0,
            unique_products: 0,
            subtotal: 0,
            tax: 0,
            total: 0,
            shipping: 0
        },
        loading: false,
        error: null,
        lastFetched: null,
        updatingItems: new Set(),
    },

    categories: {
        loading: false,
        data: [],
        links: [],
        from: null,
        to: null,
        page: 1,
        limit: null,
        total: null
    },

    isHomeLoading: false,
    homeError: null,
    isDataLoaded: false,


    allCategories: [],

    homeProducts: [],
    homeProductsLoading: false,
    homeProductsError: null,

    homeSettings: null,
    footerSettings: null,
    aboutSettings: null,

    homeSeedsProducts: [],
    homeSeedsLoading: false,
    homeSeedsError: null,


    homeGreenVegetablesProducts: [],
    homeGreenVegetablesLoading: false,
    homeGreenVegetablesError: null,

    HomeServices: [],
    homeServicesLoading: false,
    homeServicesError: null,

    HomeCategories: [],
    homeCategoriesLoading: false,
    homeCategoriesError: null,



    items: [],

    toast: {
        show: false,
        message: '',
        delay: 5000
    },
    dateOptions: [
        { key: '1d', text: 'Last Day' },
        { key: '1k', text: 'Last Week' },
        { key: '2k', text: 'Last 2 Weeks' },
        { key: '1m', text: 'Last Month' },
        { key: '3m', text: 'Last 3 Months' },
        { key: '6m', text: 'Last 6 Months' },
        { key: 'all', text: 'All Time' },
    ],

    shopProducts: {
        data: [],
        loading: false,
        current_page: 1,
        last_page: 1,
        per_page: 12,
        total: 0,
        from: 0,
        to: 0,
        error: null
    },



}
