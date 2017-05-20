require 'rails_helper'

RSpec.describe ReportGenerateService do
  describe "#perform" do
    let(:user) { create(:user) }

    context "when user has transactions in current month" do
      let(:category) { create(:category, :income, name: 'Salary', user: user)  }
      let(:category1) { create(:category, :expense, name: 'Food', user: user)  }
      let(:transaction) { create(:transaction, user: user, category: category, amount: 100) }
      let(:transaction1) { create(:transaction, user: user, category: category1, amount: 130) }
      let(:transaction2) { create(:transaction, user: user, category: category1, description: 'Burgers', amount: 30) }
      let(:response) { "*Group by month*\n\nFood: 160.0\nSalary: 100.0\n\n*Group by day*\n\n*Mon, 10 April 2017*\nSalary: 100.0\n*Sat, 15 April 2017*\nFood: 160.0" }

      it 'should build the report' do
        t = Time.local(2017, 4, 10, 10, 5, 0)
        travel_to t
        transaction
        travel 5.day
        transaction1
        transaction2
        expect(ReportGenerateService.new(user).perform).to eq(response)
        travel_back
      end
    end

    context "when user has not the transactions in current month" do
      it 'should build the report' do
        allow(I18n).to receive(:t).with("telegram.reports.you_do_not_have_transactions") { 'no_transactions' }
        expect(ReportGenerateService.new(user).perform).to eq("no_transactions")
      end
    end

  end
end
