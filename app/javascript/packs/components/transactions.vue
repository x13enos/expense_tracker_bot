<template>
  <div class='row'>
    <div class="col-lg-12">
      <div class='row'>
        <div class="col-lg-4"><h2>Transactions</h2></div>
        <div class='col-lg-8'>
          <button class='btn btn-success btn-add-transaction' @click="formActive = true" v-show="!formActive">
            Add transaction
          </button>
        </div>
      </div>
      <TransactionFilters
        v-show="!formActive"
        v-on:apply-filters="fetchData(currentPage, $event)"
        :categories="transactionData.categories" />
      <TransactionForm
        v-show="formActive"
        v-on:cancel-creation="formActive = false"
        v-on:add-transaction="addTransaction()"
        :categories="transactionData.categories" />
      <hr>
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
            v-bind:key="transaction.id"
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
  import TransactionForm from '@components/transactions/form'
  import TransactionFilters from '@components/transactions/filters'
  import Transaction from '@components/transaction';
  import Paginate from 'vuejs-paginate'

  export default {
    name: "transactions",
    components: {
      Transaction,
      TransactionForm,
      TransactionFilters,
      Paginate
    },
    data: function () {
      return {
        transactionData: {},
        formActive: false,
        currentPage: 1
      }
    },

    created: function(){
      this.fetchData(this.currentPage)
    },

    methods: {
      addTransaction: function(){
        this.formActive = false;
        this.fetchData(this.currentPage)
      },

      updateTransaction: function(transaction, new_data){
        ["amount", 'category_id', "category_name", "isExpense"].forEach((k) => {
          transaction[k] = new_data[k];
        })
      },

      fetchData: function(page=this.currentPage, filters={}){
        this.currentPage = page;
        var request_params = { params: { page: page, search: filters} }
        var that = this
        this.$http.get('transactions', request_params).then(function(response){
          that.transactionData = response.body;
        }, function(error){
          console.log(error)
        })
      }
    }
  }
</script>


<style scoped>
  .btn-add-transaction{
    margin-top: 30px;
    float: right;
  }
</style>
