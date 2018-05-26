import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Dashboard from '@components/dashboard.vue'
// import Charts from './components/charts.vue'
import Transactions from '@components/transactions.vue'
import Unathorized from '@components/unathorized.vue'

Vue.use(VueRouter)

const router = new VueRouter({
  routes : [
    { path: '/', redirect: '/dashboard' },
    { path: '/dashboard', component: Dashboard },
    // { path: '/charts', component: Charts }
    { path: '/transactions', component: Transactions },
    { path: '/unathorized', component: Unathorized }
  ]
})

export default router
