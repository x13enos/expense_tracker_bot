require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do

  login_user

  describe "GET index" do
    it "should return success status" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end

    it "should return assigns transactions" do
      transactions = double
      allow(@current_user).to receive_message_chain(:transactions, :order, :paginate) { transactions }
      get :index, format: :json
      expect(assigns(:transactions)).to eq(transactions)
    end

    it "should return assigns categories" do
      categories = double
      allow(@current_user).to receive_message_chain(:categories) { categories }
      get :index, format: :json
      expect(assigns(:categories)).to eq(categories)
    end
  end

  describe "POST create" do
    let(:transaction) { double(save: true) }
    let(:category) { create(:category, user: @current_user) }

    it "should assign attributes to the instance variable" do
      allow(@current_user).to receive_message_chain(:transactions, :new) { transaction }
      post :create, params: { transaction: { amount: "100", category_id: category.id } }, format: :json
      expect(assigns(:transaction)).to eq(transaction)
    end

    context "when attributes are valid" do
      it "should render update template" do
        post :create, params: { transaction: { amount: "100", category_id: category.id } }, format: :json
        expect(response).to render_template("transaction")
      end
    end

    context "when attributes are invalid" do
      it "should return 400 status" do
        post :create, params: { transaction: { amount: nil, category_id: category.id } }, format: :json
        expect(response.status).to eq(400)
      end

      it "should return transaction's errors" do
        post :create, params: { transaction: { amount: nil, category_id: category.id } }, format: :json
        expect(response.body).to eq({ errors: ["Amount can't be blank"] }.to_json)
      end
    end
  end

  describe "PUT update" do
    let(:transaction) { create(:transaction, user: @current_user) }
    let(:category) { create(:category, user: @current_user) }

    it "should assign attributes to the instance variable" do
      allow(@current_user).to receive_message_chain(:transactions, :find) { transaction }
      put :update, params: { id: transaction.id, transaction: { amount: "100", category_id: category.id } }, format: :json
      expect(assigns(:transaction)).to eq(transaction)
    end

    context "when attributes are valid" do
      it "should render update template" do
        put :update, params: { id: transaction.id, transaction: { amount: "100", category_id: category.id } }, format: :json
        expect(response).to render_template("transaction")
      end
    end

    context "when attributes are invalid" do
      it "should return 400 status" do
        put :update, params: { id: transaction.id, transaction: { amount: nil, category_id: category.id } }, format: :json
        expect(response.status).to eq(400)
      end

      it "should return transaction's errors" do
        put :update, params: { id: transaction.id, transaction: { amount: "nil", category_id: category.id } }, format: :json
        expect(response.body).to eq({ errors: ["Amount is not a number"] }.to_json)
      end
    end
  end
end
