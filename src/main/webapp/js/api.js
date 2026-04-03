const API_BASE_URL = '/familly-bonding-api/api';

const api = {
    getToken: () => localStorage.getItem('jwt_token'),
    
    setToken: (token) => localStorage.setItem('jwt_token', token),
    
    removeToken: () => localStorage.removeItem('jwt_token'),

    getHeaders: (auth = true) => {
        const headers = {
            'Content-Type': 'application/json'
        };
        if (auth) {
            const token = api.getToken();
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }
        }
        return headers;
    },

    request: async (endpoint, options = {}) => {
        const url = `${API_BASE_URL}${endpoint}`;
        const requireAuth = options.requireAuth !== false; // Default to true

        const fetchOptions = {
            method: options.method || 'GET',
            headers: api.getHeaders(requireAuth),
        };

        if (options.body) {
            fetchOptions.body = JSON.stringify(options.body);
        }

        try {
            const response = await fetch(url, fetchOptions);
            
            if ((response.status === 401 || response.status === 403) && !endpoint.includes('/auth/')) {
                // Unauthorized or Forbidden - Clear token and redirect to login
                api.removeToken();
                window.location.href = 'login.jsp';
                throw new Error("Session expired. Please log in again.");
            }

            const data = await response.json().catch(() => ({}));

            if (!response.ok) {
                throw new Error(data.error || 'API request failed');
            }

            return data;
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    get: (endpoint, requireAuth = true) => api.request(endpoint, { method: 'GET', requireAuth }),
    post: (endpoint, body, requireAuth = true) => api.request(endpoint, { method: 'POST', body, requireAuth }),
    put: (endpoint, body, requireAuth = true) => api.request(endpoint, { method: 'PUT', body, requireAuth }),
    delete: (endpoint, requireAuth = true) => api.request(endpoint, { method: 'DELETE', requireAuth }),

    refreshSession: async () => {
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user || !user.userId) return;
        
        try {
            const freshUser = await api.get(`/users/${user.userId}`);
            localStorage.setItem('user', JSON.stringify(freshUser));
            return freshUser;
        } catch (error) {
            console.error("Failed to refresh session:", error);
        }
    }
};
