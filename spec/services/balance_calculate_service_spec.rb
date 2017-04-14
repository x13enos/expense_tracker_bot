require 'rails_helper'

RSpec.describe BalanceCalculateService do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:income_category) { create(:category, :income, user: user, name: "Salary")  }

    before do
      Transaction.delete_all
    end

    it 'should return amount if user has transactions' do
      create(:transaction, user: user, category: income_category, amount: 500)
      create(:transaction, user: user, category: income_category, amount: 50)
      expect(BalanceCalculateService.new(user).perform).to eq("Your balance is 550")
    end

    it "should return zero if user hasn't transactions" do
      expect(BalanceCalculateService.new(user).perform).to eq("Your balance is 0")
    end

  end
end
