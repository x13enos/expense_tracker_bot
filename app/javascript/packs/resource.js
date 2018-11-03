import Vue from 'vue/dist/vue.esm'
import router from './router'
import VueResource from 'vue-resource'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

Vue.use(VueResource)

Vue.http.options.root = '/api/v1/';

Vue.http.interceptors.push(function(request, next) {
  NProgress.start();
  if ( localStorage.getItem("auth_token") !== "undefined") {
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    request.headers.set('AUTHORIZATION', 'Bearer ' + localStorage.getItem("auth_token"));
    request.headers.set('X-CSRF-Token', token);
  }

  next(function(response) {
    NProgress.done();
    if(response.status == 401){
      router.push('unathorized')
    }
    if(typeof response.headers.map.http_authorization !== "undefined"){
      localStorage.setItem('auth_token', response.headers.map.http_authorization);
    };
  });
});
