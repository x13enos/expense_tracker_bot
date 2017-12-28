require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET index" do
    it 'should redirect user to dashboard page' do
      get :index, params: { token: "123" }
      expect(response.cookies['token']).to eq("123")
    end

    it 'should write token to cookie' do
      get :index, params: { token: "123" }
      expect(response).to redirect_to(root_path)
    end
  end
end
