<template>
  <div>
    <div id="progress_bar"></div>
    <nav class="navbar navbar-default navbar-static-top navbar-without-bottom-margin">

      <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>

        <router-link to="/dashboard"  class="navbar-brand">
          ExpenseTrackerBot
        </router-link>
      </div>

      <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse in" aria-expanded="true" style="">
          <ul class="nav in" id="side-menu">
            <li>
              <router-link to="/dashboard">
                <i class="fa fa-dashboard fa-fw"></i>
                <span>Dashboard</span>
              </router-link>

            </li>

            <li>
              <router-link to="/transactions">
                <i class="fa fa-list fa-fw"></i>
                <span>Transactions</span>
              </router-link>

            </li>
          </ul>
        </div>
      </div>
    </nav>


    <div id='page-wrapper'>
      <Notifier />
      <div class="col-12"><router-view></router-view></div>
    </div>
  </div>
</template>

<script>
  import Notifier from '@components/services/notifier'

  export default {
    name: 'app',
    components: { Notifier }
  }
</script>

<style scoped>
  .navbar-without-bottom-margin{
    margin-bottom: 0px;
  }

  .nprogress-custom-parent{
    overflow: inherit;
  }
</style>
