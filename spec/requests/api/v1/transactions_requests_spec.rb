require "rails_helper"

RSpec.describe "transactions requests", type: :request do
  let(:base_url) { '/api/v1'}
  let(:user) { create(:user) }
  let(:auth_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{AuthService.encode(user.id)}" } }

  describe "index" do
    it "should return transactions data" do
      expence_category = create(:category, :expense, user: user)
      expense_transaction = create(:transaction, category: expence_category, user: user, amount: 100)
      data = {
        transactions: [
          {
            id: expense_transaction.id,
            amount: expense_transaction.amount,
            date: expense_transaction.created_at.strftime("%d %B %Y - %T"),
            category_id: expence_category.id,
            category_name: expence_category.name,
            isExpense: true
          },
        ],
        categories: [
          {
            id: expence_category.id,
            name: expence_category.name
          }
        ],
        page_count: 1
      }.to_json


      get "#{base_url}/transactions", params: { format: :json, page: 1 }, headers: auth_headers
      expect(response.body).to eq(data)
    end
  end

  describe "create" do
    let(:category) { create(:category, :expense) }

    it "should create transaction" do
      post "#{base_url}/transactions", params: { transaction: { amount: "120", category_id: category.id }, format: :json }, headers: auth_headers
      expect(Transaction.count).to eq(1)
    end

    it "should return new transaction" do
      post "#{base_url}/transactions", params: { transaction: { amount: "120", category_id: category.id }, format: :json }, headers: auth_headers
      data = {
        id: Transaction.last.id,
        amount: 120.0,
        date: Transaction.last.created_at.strftime("%d %B %Y - %T"),
        category_id: category.id,
        category_name: category.name,
        isExpense: true
      }.to_json
      expect(response.body).to eq(data)
    end
  end

  describe "update" do
    it "should return transactions" do
      category = create(:category, :expense, user: user)
      transaction = create(:transaction, category: category, user: user, amount: 100)
      data = {
        id: transaction.id,
        amount: 120.0,
        date: transaction.created_at.strftime("%d %B %Y - %T"),
        category_id: category.id,
        category_name: category.name,
        isExpense: true
      }.to_json


      put "#{base_url}/transactions/#{transaction.id}", params: { transaction: { amount: "120" }, format: :json }, headers: auth_headers
      expect(response.body).to eq(data)
    end
  end

end
