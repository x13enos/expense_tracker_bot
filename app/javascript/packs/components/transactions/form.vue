<template>
  <div>
    <form class="form-inline">
      <label>Amount:</label>
      <input v-model="amount" placeholder="amount" class='form-control'>
      <label>Category:</label>
      <select v-model="categoryId" class='form-control'>
        <option v-for="category in categories" v-bind:value="category.id">
          {{ category.name }}
        </option>
      </select>
      <button type='button' class='btn btn-primary' @click="createTransaction()">Save</button>
      <button type='button' class='btn btn-default' @click="$emit('cancel-creation')">Cancel</button>
    </form>
  </div>
</template>

<script>
  import { mapActions } from 'vuex'

  export default {
    props: ["categories"],
    data: function () {
      return {
        amount: 0,
        categoryId: null
      }
    },
    methods: {
      ...mapActions([
        'updateMessage',
      ]),
      createTransaction: function(){
        var request_params = { amount: this.amount, category_id: this.categoryId };
        this.$http.post('transactions', request_params).then(function(){
          this.$emit("add-transaction")
        }, function(error_response){
          var error_message = error_response.body.errors.join(', ');
          this.updateMessage(error_message)
        })
      }
    }
  }
</script>


<style scoped>
  form label{
    margin: 0 10px;
  }
</style>
