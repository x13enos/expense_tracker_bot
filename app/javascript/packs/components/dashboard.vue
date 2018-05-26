<template>
  <div class="dashboard_content">
    <div class="col-lg-2 col-md-4">
      <h1>{{ user_data.current_month }}</h1>
    </div>
    <div class="col-lg-3 col-md-6 col-lg-offset-1">
      <div class="panel panel-green">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-3"><i class="fa fa-angle-double-up fa-5x"></i></div>
            <div class="col-xs-9 text-right">
                <div class="huge">{{user_data.income}}</div>
                <div>Income</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 col-lg-offset-1">
      <div class="panel panel-red">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-3"><i class="fa fa-angle-double-down fa-5x"></i></div>
            <div class="col-xs-9 text-right">
                <div class="huge">{{user_data.expense}}</div>
                <div>Expense</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class='row'>
      <div class="col-lg-12">
        <h2 class="page-header">Last Transactions</h2>
        <table class="table">
          <thead class="thead-dark">
            <tr>
              <th scope="col">#</th>
              <th scope="col">Category</th>
              <th scope="col">Amount</th>
              <th scope="col">Date(in UTC)</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(transaction, index) in lastFiveTransactions">
              <th scope="row">{{index + 1}}</th>
              <td>{{transaction.category}}</td>
              <td :class="[transaction.isExpense ? 'danger' : 'success']">{{transaction.amount}}</td>
              <td>{{transaction.date}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {
        user_data: {}
      }
    },

    created: function(){
      this.fetchUserData()
    },

    methods: {
      fetchUserData: function(){
        this.$http.get('dashboard').then(function(response){
          this.user_data = response.body
        }, function(error){
          console.log(error)
        })
      }
    },

    computed: {
      lastFiveTransactions: function(){
        if(this.user_data.transactions){
          return this.user_data.transactions.slice(0,5)
        }
      }
    }
  }
</script>


<style scoped>
  .dashboard_content{
    padding-top: 20px;
   }
</style>
