require 'rails_helper'

RSpec.describe TransactionsListService do
  describe "#perform" do
    let(:user) { create(:user) }

    context "when user has transactions in current month" do
      let(:category) { create(:category, :income, name: 'Salary', user: user)  }
      let(:category1) { create(:category, :expense, name: 'Food', user: user)  }
      let(:transaction) { create(:transaction, user: user, category: category, amount: 100) }
      let(:transaction1) { create(:transaction, user: user, category: category1, amount: 130) }
      let(:transaction2) { create(:transaction, user: user, category: category1, description: 'Burgers', amount: 30) }
      let(:response) { "*Sat, 15 April 2017*\nBurgers:  30.0\nFood:  130.0\n\n*Mon, 10 April 2017*\nSalary:  100.0" }

      it 'should build the report' do
        t = Time.local(2017, 4, 10, 10, 5, 0)
        Timecop.travel(t)
        transaction
        Timecop.travel(t + 5.days)
        transaction1
        transaction2
        expect(TransactionsListService.new(user).perform).to eq(response)
        Timecop.return
      end
    end

    context "when user has not the transactions in current month" do
      it 'should build the report' do
        allow(I18n).to receive(:t).with("telegram.transactions_list.you_do_not_have_transactions") { 'no_transactions' }
        expect(TransactionsListService.new(user).perform).to eq("no_transactions")
      end
    end

  end
end
