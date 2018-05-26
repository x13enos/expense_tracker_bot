require 'rails_helper'

RSpec.describe Api::V1::DashboardController, type: :controller do

  login_user

  describe "GET index" do
    it "should return success status" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end

    it "should return assigns transactions" do
      transactions = double
      allow(@current_user).to receive_message_chain(:transactions, :current_month) { transactions }
      get :index, format: :json
      expect(assigns(:transactions)).to eq(transactions)
    end
  end
end
