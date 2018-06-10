import { createLocalVue, shallow } from '@vue/test-utils'
import VueResource from 'vue-resource'
import transaction from '@components/transaction.vue';

const localVue = createLocalVue()
localVue.use(VueResource)

describe('transaction.vue', () => {
  const componentPropsData = {
    category_name: "Food",
    isExpense: true,
    amount: "-100",
    date: "January 1",
    category_id: 1,
    id: 1,
    categories: [{ id: 1, name: 'first'}, { id: 2, name: 'second'}]
  };

  describe("check template after creating", () => {
    let wrapper, checkingCells;

    before(() => {
      wrapper = shallow(transaction, {
        propsData: componentPropsData
      });
      checkingCells = wrapper.findAll("td");
    })

    it('should set category name', () => {
      expect(checkingCells.at(0).text()).to.eq("Food")
    })

    it('should set amount', () => {
      expect(checkingCells.at(1).text()).to.eq("-100")
    })

    it('should set date', () => {
      expect(checkingCells.at(2).text()).to.eq("January 1")
    })

    describe("class of amount field", () => {
      it('should return danger if isExpense - true', () => {
        wrapper.setProps({ isExpense: true })
        expect(wrapper.findAll("td").at(1).classes()).to.include("danger")
      })

      it('should return success if isExpense - false', () => {
        wrapper.setProps({ isExpense: false })
        expect(wrapper.findAll("td").at(1).classes()).to.include("success")
      })
    })
  })

  describe("show inputs after click on button edit", () => {
    let wrapper, checkingCells;

    before(() => {
      wrapper = shallow(transaction, {
        propsData: componentPropsData
      });
      wrapper.find('button.btn-edit').trigger('click')
      checkingCells = wrapper.findAll("td");
    })

    it('should show select with categories', () => {
      expect(checkingCells.at(0).find("option").text()).to.eq("first")
    })

    it('should return categorie id from option', () => {
      expect(checkingCells.at(0).find("option").attributes().value).to.eq('1')
    })

    it('should show input amount', () => {
      expect(checkingCells.at(1).find("input.amount").exists()).to.be.true
    })

    it('should show update button', () => {
      expect(checkingCells.at(3).find("button.btn-update").exists()).to.be.true
    })

    it('should show update button', () => {
      expect(checkingCells.at(3).find("button.btn-back").exists()).to.be.true
    })
  })

  describe("click back button on the transaction form", () => {
    it('should launch method "returnValues"', () => {
      var wrapper = shallow(transaction, { propsData: componentPropsData });
      sinon.spy(wrapper.vm, "returnValues");
      wrapper.find('button.btn-edit').trigger('click');
      wrapper.find('button.btn-back').trigger('click');
      expect(wrapper.vm.returnValues.called).to.be.true;
      wrapper.vm.returnValues.restore();
    })
  })

  describe("methods", () => {
    describe("returnValues", () => {
      let wrapper;

      before(() => {
        wrapper = shallow(transaction, { propsData: componentPropsData });
        wrapper.vm.isChanging = true;
        wrapper.vm.currentAmount = "1000";
        wrapper.vm.currentCategoryId = "1001";
        wrapper.vm.returnValues();
      })

      it('should set false status for active flag', () => {
        expect(wrapper.vm.isChanging).to.be.false
      });

      it('should set passed props amount', () => {
        expect(wrapper.vm.currentAmount).to.eq("-100")
      });

      it('should set passed props category id', () => {
        expect(wrapper.vm.currentCategoryId).to.eq(1)
      });
    });

    describe("updateTransaction", () => {
      let xhr, requests;

      beforeEach(() => {
        xhr = sinon.useFakeXMLHttpRequest();
        requests = this.requests = [];
        xhr.onCreate = (xhr) => { requests.push(xhr); }
      })

      afterEach(() => { xhr.restore(); })

      it('should set false status for active flag', () => {
        sinon.spy(localVue.http, "put");
        var wrapper = shallow(transaction, { propsData: componentPropsData, localVue });
        wrapper.vm.isChanging = true;
        wrapper.vm.updateTransaction();
        expect(wrapper.vm.isChanging).to.be.false
        localVue.http.put.restore()
      });

      it('should make an put request', () => {
        var spy = sinon.spy(localVue.http, "put");
        var wrapper = shallow(transaction, { propsData: componentPropsData, localVue });
        wrapper.vm.updateTransaction();
        expect(spy.withArgs('transactions/1', { amount: "-100", category_id: 1}).calledOnce).to.be.true
        spy.restore()
      });

      it('call method "update-transaction" by parent node', (done) => {
        var wrapper = shallow(transaction, { propsData: componentPropsData, localVue });
        wrapper.vm.updateTransaction();

        setTimeout(() => {
          expect(wrapper.emitted("update-transaction").length).to.eq(1)
          expect(wrapper.emitted("update-transaction")[0][0]["id"]).to.eq('12')
          done()
        }, 0)

        this.requests[0].respond(200, { "Content-Type": "application/json" },
                           '{ "id": "12" }');

      });

    })
  })
})
