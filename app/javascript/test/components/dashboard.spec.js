import { createLocalVue, shallow } from '@vue/test-utils'
import VueResource from 'vue-resource'
import dashboard from '../../packs/components/dashboard.vue';

const localVue = createLocalVue()
localVue.use(VueResource)

describe('dashboard.vue', () => {

  it('should request user data', () => {
    var fetchUserDataStub = sinon.stub(dashboard.methods, "fetchUserData")
    shallow(dashboard)
    expect(fetchUserDataStub.called).to.be.true
    fetchUserDataStub.restore()
  })

  describe("fetchUserData method", () => {
    let xhr, requests;

    beforeEach(() => {
      xhr = sinon.useFakeXMLHttpRequest();
      requests = this.requests = [];
      xhr.onCreate = (xhr) => { requests.push(xhr); }
    })

    afterEach(() => {
      xhr.restore();
    })

    it('should send get request for getting dashboard data', () => {
      var spy = sinon.spy(localVue.http, "get");
      shallow(dashboard, { localVue });
      expect(spy.withArgs('dashboard').calledOnce).to.be.true
    })

    it('should update user_data after getting dashboard info', (done) => {
      var wrapper = shallow(dashboard, { localVue });

      setTimeout(() => {
        expect(wrapper.vm.user_data.id).to.eq("12")
        done()
      }, 0)

      this.requests[0].respond(200, { "Content-Type": "application/json" },
                         '{ "id": "12" }');
    })
  })
})
