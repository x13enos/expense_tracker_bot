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
      <button class='btn btn-primary' @click="createTransaction()">Save</button>
      <button class='btn btn-default' @click="cancelCreation()">Cancel</button>
    </form>
  </div>
</template>

<script>
  export default {
    props: ["categories"],
    data: function () {
      return {
        amount: 0,
        categoryId: null
      }
    },
    methods: {
      cancelCreation: function(){
        this.$emit('cancel-creation')
      },

      createTransaction: function(){
        var request_params = { amount: this.amount, category_id: this.categoryId };
        this.$http.post('transactions', request_params).then(function(){
          this.$emit("add-transaction")
        }, function(error){
          console.log(error)
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
