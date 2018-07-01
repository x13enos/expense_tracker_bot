import Vue from 'vue/dist/vue.esm';
import router from './router';
import './resource';
import App from './app'


document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    router,
    template: "<app />",
    components: { App }
  }).$mount('#app');
})
