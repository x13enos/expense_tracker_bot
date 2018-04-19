require "rails_helper"

RSpec.describe "dashboard requests", type: :request do
  let(:base_url) { '/api/v1'}
  let(:user) { create(:user) }
  let(:auth_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{AuthService.encode(user.id)}" } }

  describe "index" do
    it "should return data for dashboard" do
      expence_category = create(:category, :expense, user: user)
      income_category = create(:category, :income, user: user)
      expense_transaction = create(:transaction, category: expence_category, user: user, amount: 100)
      income_transaction = create(:transaction, category: income_category, user: user, amount: 150)
      data = {
        expense: 100.00,
        income: 150.00,
        current_month: Time.now.strftime("%B"),
        transactions: [
          { category: income_category.name, isExpense: false, amount: 150.00, date: income_transaction.created_at.strftime("%d %B %Y - %T") },
          { category: expence_category.name, isExpense: true, amount: 100.00, date: expense_transaction.created_at.strftime("%d %B %Y - %T") }
        ]
      }.to_json


      get "#{base_url}/dashboard", params: { format: :json }, headers: auth_headers
      expect(response.body).to eq(data)
    end

  end

end
