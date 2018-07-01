import Vue from 'vue/dist/vue.esm';
import router from './router';
import './resource';
import NProgress from 'nprogress'
import App from './app'


document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    router,
    template: "<app />",
    components: { App },
    mounted: function(){
      NProgress.configure({ parent: '#progress_bar' });
    }
  }).$mount('#app');
})
