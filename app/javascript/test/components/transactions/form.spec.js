import Vuex from 'vuex'
import { createLocalVue, shallow } from '@vue/test-utils'
import VueResource from 'vue-resource'
import transactionForm from '@components/transactions/form'


const localVue = createLocalVue()
localVue.use(VueResource)
localVue.use(Vuex)

describe('transaction-form.vue', () => {
  const componentPropsData = {
    categories: [{ id: 1, name: 'first'}, { id: 2, name: 'second'}]
  };

  describe("methods", () => {
    describe("cancelCreation", () => {

      it('call method "cancel-creation" by parent node', () => {
        var wrapper = shallow(transactionForm, { propsData: componentPropsData });
        wrapper.findAll(".btn-default").trigger('click');
        expect(wrapper.emitted("cancel-creation").length).to.eq(1);
      });
    });

    describe("createTransaction", () => {
      let xhr, requests, wrapper, actions, store;

      beforeEach(() => {
        actions = { updateMessage: sinon.stub().callsFake(function fakeFn(el, los) { }) }
        store = new Vuex.Store({ state: {}, actions })
        xhr = sinon.useFakeXMLHttpRequest();
        requests = this.requests = [];
        xhr.onCreate = (xhr) => { requests.push(xhr); }
        wrapper = shallow(transactionForm, { store, propsData: componentPropsData, localVue });
      })

      afterEach(() => { xhr.restore(); })

      it('should make an post request', () => {
        var spy = sinon.spy(localVue.http, "post");
        wrapper.vm.amount = 100;
        wrapper.vm.categoryId = 15;
        wrapper.vm.createTransaction();
        expect(spy.withArgs('transactions', { amount: 100, category_id: 15}).calledOnce).to.be.true
        spy.restore()
      });

      it('call method "add-transaction" by parent node', (done) => {
        wrapper.vm.createTransaction();

        setTimeout(() => {
          expect(wrapper.emitted("add-transaction").length).to.eq(1)
          done()
        }, 0)

        this.requests[0].respond(200, { "Content-Type": "application/json" },
                           '{ "id": "12" }');
      });

      it('call passed data to update flash message service', (done) => {
        wrapper.vm.createTransaction();

        setTimeout(() => {
          expect(actions.updateMessage.calledOnce).to.be.true
          done()
        }, 0)

        this.requests[0].respond(422, { "Content-Type": "application/json" },
                           '{ "errors": ["Failed"] }');
      });
    });
  });
})
