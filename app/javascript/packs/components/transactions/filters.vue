<template>
  <div class='row'>
    <div class='col-lg-12'>
      <form class="form-inline">
        <span>Search by:</span>
        <select v-model="categoryId" class="form-control">
          <option :value="null" disabled>Category</option>
          <option v-for="category in categories" :value="category.id">{{ category.name }}</option>
        </select>
        <datepicker v-model="dateStart" placeholder="Start date" :bootstrap-styling="true" wrapper-class="input-group"></datepicker>
        <datepicker v-model="dateEnd" placeholder="End date" :bootstrap-styling="true" wrapper-class="input-group"></datepicker>
        <div class="input-group">
          <button class='btn btn-success' @click="$emit('apply-filters', selectFiltersData())">Search</button>
          <button class='btn btn-default' @click="$emit('apply-filters', { categoryId: null })">Clear</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
  import Datepicker from 'vuejs-datepicker';

  export default {
    components: { Datepicker },
    props: ["categories"],
    data: function () {
      return {
        categoryId: null,
        dateStart: "",
        dateEnd: ""
      }
    },
    methods: {
      selectFiltersData: function(){
        var t, start_date, end_date;
        if(typeof this.dateStart === 'object' ){ start_date = this.dateStart.toLocaleDateString()}
        if(typeof this.dateEnd === 'object' ){ end_date = this.dateEnd.toLocaleDateString()}
        return {
          category_id: this.categoryId,
          start_date: start_date,
          end_date: end_date
        }
      }
    }
  }
</script>


<style scoped>
</style>
