import Vuex from 'vuex'
import { createLocalVue, shallow } from '@vue/test-utils'
import notifier from '@components/services/notifier'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('notifier', () => {
  let wrapper;

  it("should hide if message unexists", () => {
    wrapper = shallow(notifier, {
      localVue,
      computed: { message() { return "" } }
    });
    expect(wrapper.is(".alert")).to.be.false
  })

  it("should show if message exists", () => {
    wrapper = shallow(notifier, {
      localVue,
      computed: { message() { return "alert" } }
    });
    expect(wrapper.is(".alert")).to.be.true;
  })
})

describe('notifier actions', () => {
  let actions, store, wrapper;

  beforeEach(function () {
    actions = { updateMessage: sinon.stub().callsFake(function fakeFn(context, message) { wrapper.vm.$store.state.message = message; }) }
    store = new Vuex.Store({ state: { message: "alert" }, actions })
    wrapper = shallow(notifier, { store, localVue });
    wrapper.find(".close").trigger("click")
  });

  it("should update store message when user clicks on the close button", () => {
    expect(wrapper.vm.message).to.equal("")
  })

  it("should remove notifier block", () => {
    expect(wrapper.find('.alert').exists()).to.be.false
  })
})
