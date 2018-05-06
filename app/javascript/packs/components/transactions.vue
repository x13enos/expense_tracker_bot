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
            v-for="transaction in transactionData.transactions"
            v-bind="transaction"
            :categories="transactionData.categories"
            v-on:update-transaction="updateTransaction(transaction, $event)"
             />
        </tbody>
      </table>

      <paginate
        :page-count="transactionData.page_count"
        :click-handler="fetchData"
        :prev-text="'Prev'"
        :next-text="'Next'"
        :container-class="'pagination'">
      </paginate>
    </div>
  </div>
</template>

<script>
  import Transaction from '@components/transaction';
  import Paginate from 'vuejs-paginate'


  export default {
    name: "transactions",
    components: {
      Transaction,
      Paginate
    },
    data: function () {
      return {
        transactionData: {}
      }
    },

    created: function(){
      this.fetchData(1)
    },

    methods: {
      updateTransaction: function(transaction, new_data){
        ["amount", 'category_id', "category_name", "isExpense"].forEach((k) => {
          transaction[k] = new_data[k]
        })
      },

      fetchData: function(page){
        var request_params = { params: { page: page } }
        this.$http.get('transactions', request_params).then(function(response){
          this.transactionData = response.body
          console.log(this.transactionData)
        }, function(error){
          console.log(error)
        })
      }
    }
  }
</script>


<style scoped>
</style>
