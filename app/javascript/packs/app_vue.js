import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import Dashboard from '@components/dashboard.vue'
// import Charts from './components/charts.vue'
import Transactions from '@components/transactions.vue'
import Unathorized from '@components/unathorized.vue'

Vue.use(VueRouter)
Vue.use(VueResource)

Vue.http.options.root = '/api/v1/';

const routes = [
  { path: '/', redirect: '/dashboard' },
  { path: '/dashboard', component: Dashboard },
  // { path: '/charts', component: Charts }
  { path: '/transactions', component: Transactions },
  { path: '/unathorized', component: Unathorized }
]

const router = new VueRouter({
  routes
})

Vue.http.interceptors.push(function(request, next) {
  if (localStorage.getItem("auth_token") !== null) {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    request.headers.set('AUTHORIZATION', 'Bearer ' + localStorage.getItem("auth_token"));
    request.headers.set('X-CSRF-Token', token);
  }

  next(function(response) {
    if(response.status == 401){
      router.push('unathorized')
    }
    if(typeof response.headers.map.http_authorization !== "undefined"){
      localStorage.setItem('auth_token', response.headers.map.http_authorization);
    };
  });
});

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    router
  }).$mount('#app');
})