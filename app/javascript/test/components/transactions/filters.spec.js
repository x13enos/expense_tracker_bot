import { shallow } from '@vue/test-utils'
import transactionFilters from '@components/transactions/filters'

describe('transaction-filters.vue', () => {
  const componentPropsData = {
    categories: [{ id: 1, name: 'first'}, { id: 2, name: 'second'}]
  };

  describe("emitted events", () => {
    let wrapper;

    beforeEach(function() {
      wrapper = shallow(transactionFilters, { propsData: componentPropsData });
    });

    describe("apply filters with selected filters", () => {
      it('call method "apply-filters" by parent node', () => {
        wrapper.findAll(".btn-success").trigger('click');
        expect(wrapper.emitted("apply-filters").length).to.eq(1);
      });

      it('should pass handled data', () => {
        sinon.stub(wrapper.vm, 'selectFiltersData').callsFake(function fakeFn() {
            return 'handled_data';
        });
        wrapper.findAll(".btn-success").trigger('click');
        expect(wrapper.emitted("apply-filters")[0][0]).to.eq("handled_data");
      });
    });

    describe("clear filters", () => {
      it('call method "apply-filters" by parent node', () => {
        wrapper.findAll(".btn-default").trigger('click');
        expect(wrapper.emitted("apply-filters").length).to.eq(1);
      });

      it('should pass handled data', () => {
        wrapper.findAll(".btn-default").trigger('click');
        expect(wrapper.emitted("apply-filters")[0][0]).to.deep.eq({categoryId: null});
      });
    });
  });

  describe("methods", () => {
    let wrapper;

    beforeEach(function() {
      wrapper = shallow(transactionFilters, { propsData: componentPropsData });
    });

    describe("selectFiltersData", () => {
      it('should return handled data without date range', () => {
        wrapper.vm.categoryId = 1
        expect(wrapper.vm.selectFiltersData()).to.deep.eq({
          category_id: 1,
          start_date: undefined,
          end_date: undefined
        });
      });

      it('should return handled data without date range', () => {
        wrapper.vm.categoryId = 1
        wrapper.vm.dateStart =  new Date(2018, 11, 24, 10, 33);
        wrapper.vm.dateEnd = new Date(2018, 11, 24, 10, 33);
        expect(wrapper.vm.selectFiltersData()).to.deep.eq({
          category_id: 1,
          start_date: "12/24/2018",
          end_date: "12/24/2018"
        });
      });
    });
  });
})
