<template>
  <div class='row'>
    <div class="col-lg-12">
      <h2 class="page-header">Transactions</h2>
      <table class="table">
        <thead class="thead-dark">
          <tr>
            <th scope="col">Category</th>
            <th scope="col">Amount</th>
            <th scope="col">Date(in UTC)</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <Transaction
            v-for="transaction in transaction_data.transactions"
            v-bind="transaction"
            :categories="transaction_data.categories"
            v-on:update-transaction="updateTransaction(transaction, $event)"
             />
        </tbody>
      </table>
    </div>
  </div>
  </div>
</template>

<script>
  import Transaction from '@components/transaction';

  export default {
    name: "transactions",
    components: {
      Transaction,
    },
    data: function () {
      return {
        transaction_data: {}
      }
    },

    created: function(){
      this.fetchData()
    },

    methods: {
      updateTransaction: function(transaction, new_data){
        ["amount", 'category_id', "category_name", "isExpense"].forEach((k) => {
          transaction[k] = new_data[k]
        })
      },

      fetchData: function(){
        this.$http.get('transactions').then(function(response){
          this.transaction_data = response.body
        }, function(error){
          console.log(error)
        })
      }
    }
  }
</script>


<style scoped>
</style>
