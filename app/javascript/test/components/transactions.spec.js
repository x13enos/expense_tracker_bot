import { createLocalVue, shallow } from '@vue/test-utils'
import VueResource from 'vue-resource'
import transactions from '@components/transactions.vue';

const localVue = createLocalVue()
localVue.use(VueResource)

describe('transactions.vue', () => {

  describe("created", () => {
    it('should request transactions data', () => {
      var fetchDataStub = sinon.stub(transactions.methods, "fetchData")
      shallow(transactions)
      expect(fetchDataStub.called).to.be.true
      fetchDataStub.restore()
    })
  })

  describe("fetchTransactionsStub method", () => {
    let xhr, requests;

    beforeEach(() => {
      xhr = sinon.useFakeXMLHttpRequest();
      requests = this.requests = [];
      xhr.onCreate = (xhr) => { requests.push(xhr); }
    })

    afterEach(() => {
      xhr.restore();
    })

    it('should send get request for getting transactions data', () => {
      var spy = sinon.spy(localVue.http, "get");
      shallow(transactions, { localVue });
      expect(spy.withArgs('transactions').calledOnce).to.be.true
      localVue.http.get.restore()
    })

    it('should update transactionData after getting transactions info', (done) => {
      var wrapper = shallow(transactions, { localVue });

      setTimeout(() => {
        expect(wrapper.vm.transactionData.id).to.eq("12")
        done()
      }, 0)

      this.requests[0].respond(200, { "Content-Type": "application/json" },
                         '{ "id": "12" }');
    })
  })

  describe("updateTransaction method", () => {
    let transaction;

    before(() => {
      sinon.stub(transactions.methods, "fetchData")
      transaction = { "amount": 1, 'category_id': 1, "category_name": 'first', "isExpense": true }
      var new_data =    { "amount": 2, 'category_id': 2, "category_name": 'second', "isExpense": false }
      var wrapper = shallow(transactions);
      wrapper.vm.updateTransaction(transaction, new_data)
    });

    it('should update amount', () => {
      expect(transaction.amount).to.eq(2)
    });

    it('should update category_id', () => {
      expect(transaction.category_id).to.eq(2)
    })

    it('should update category_name', () => {
      expect(transaction.category_name).to.eq('second')
    })

    it('should update isExpense field', () => {
      expect(transaction.isExpense).to.eq(false)
    })
  })
})
