import Vue from 'vue/dist/vue.esm'
import router from './router'
import resource from './resource'


document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    router
  }).$mount('#app');
})
