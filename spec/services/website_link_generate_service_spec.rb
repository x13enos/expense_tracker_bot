require 'rails_helper'

RSpec.describe WebsiteLinkGenerateService do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:resulting_link) { '[Your link](http://example.com/authorize?token=token)'  }

    before do
      User.delete_all
    end

    it 'should return url for getting access on site' do
      allow(AuthService).to receive(:encode).with(user.id) { 'token' }
      allow(ENV).to receive(:[]).with("HOST") { "http://example.com" }
      expect(WebsiteLinkGenerateService.perform(user.id)).to eq(resulting_link)
    end

  end
end

