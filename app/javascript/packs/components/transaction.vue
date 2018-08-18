<template >
  <tr>
    <template v-if="!this.isChanging">
      <td>{{this.category_name}}</td>
      <td :class="[this.isExpense ? 'danger' : 'success']">{{this.amount}}</td>
      <td>{{this.date}}</td>
      <button class='btn btn-sm btn-success btn-edit' @click="isChanging = true">edit</button>
    </template>

    <template v-if="this.isChanging">
      <td>
        <select v-model="currentCategoryId">
          <option v-for="option in categories" v-bind:value="option.id">
            {{ option.name }}
          </option>
        </select>
      </td>
      <td><input class='amount' v-model="currentAmount" placeholder="Amount"></td>
      <td>{{this.date}}</td>
      <td>
        <button class='btn btn-sm btn-primary btn-update' @click="updateTransaction()">save</button>
        <button class='btn btn-sm btn-default btn-back' @click="returnValues()">back</button>
      </td>
    </template>
  </tr>
</template>

<script>
  import { mapActions } from 'vuex'

  export default {
    name: "transaction",
    props: ['category_name', 'category_id', "isExpense", "date", "amount", "id", "categories"],
    data: function () {
      return {
        currentAmount: this.amount,
        currentCategoryId: this.category_id,
        isChanging: false
      }
    },
    methods: {
      ...mapActions([
        'updateMessage',
      ]),
      returnValues: function(){
        this.isChanging = false;
        this.currentAmount = this.amount;
        this.currentCategoryId = this.category_id;
      },
      updateTransaction: function(){
        var request_params = { amount: this.currentAmount, category_id: this.currentCategoryId };
        this.$http.put('transactions/'+this.id, request_params).then(function(response){
          this.isChanging = false;
          this.$emit("update-transaction", response.body)
        }, function(error_response){
          var error_message = error_response.body.errors.join(', ');
          this.updateMessage(error_message)
        })
      }
    }
  }
</script>


<style scoped>
</style>
