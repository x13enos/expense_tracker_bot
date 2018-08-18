import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'
import mutations from './mutations'

Vue.use(Vuex)

const state = {
  message: ""
}

const actions = {
  updateMessage: ({ commit}, message ) => commit('updateMessage', message),
}

export default new Vuex.Store({
  state,
  mutations,
  actions
})
