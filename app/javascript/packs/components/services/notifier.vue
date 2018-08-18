<template>
  <transition name="fade">
    <div v-if="message" class="alert alert-warning alert-dismissible show" role="alert">
      {{ message }}
      <button type="button" class="close" @click="closeWindow()">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  </transition>
</template>

<script>
  import { mapActions } from 'vuex'

  export default {
    computed: {
      message() {
        return this.$store.state.message;
      }
    },
    methods: {
      ...mapActions([
        'updateMessage',
      ]),
      closeWindow: function(){
        this.updateMessage("")
      }
    }
  }
</script>


<style scoped>
  .fade-enter-active, .fade-leave-active {
    transition: opacity .5s;
  }
  .fade-enter, .fade-leave-to{
    opacity: 0;
  }
</style>
