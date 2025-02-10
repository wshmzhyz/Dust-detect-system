import axios from 'axios'

//const URL = "http://10.237.55.112:8080"
const URL = "http://localhost:8080"
const service = axios.create({
    baseURL: URL, // url = base url + request url
    timeout: 10000,// request timeout
    withCredentials: true
})

// http request 拦截器
service.interceptors.request.use(
    config => {
        return config;
    },
    error => {
        return Promise.reject(error)
    }
)

service.interceptors.response.use(
    response => {
        return response.data;
    },
    error => {
        return Promise.reject(error);
    }
);

export default service
