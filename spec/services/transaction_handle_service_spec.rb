require 'rails_helper'

RSpec.describe TransactionHandleService do
  describe "#perform" do
    let(:user) { create(:user) }

    before do
      Transaction.delete_all
    end

    context "when user passed the correct message for creating transaction" do
      let(:salary_category) { create(:category, name: "Salary", financial_type: 'income', user_id: user.id)  }
      let(:expense_category) { create(:category, name: "Eating out", financial_type: 'expense', user_id: user.id)  }

      let(:income_transaction_data) { { "text" => "#{salary_category.name} 4000" } }
      let(:expense_transaction_data) { { "text" => "#{expense_category.name} 4000" } }

      let(:service_with_income_data) { TransactionHandleService.new(income_transaction_data, user)  }
      let(:service_with_expense_data) { TransactionHandleService.new(expense_transaction_data, user)  }

      it 'should create transaction for user', :focus do
        expect{ service_with_income_data.perform }.to change(user.transactions, :count).from(0).to(1)
      end

      it 'should create transaction with positive amount' do
        service_with_income_data.perform
        expect(user.transactions.last.amount).to eq(4000.to_f)
      end

      it 'should create transaction with positive amount if user pass negative amount' do
        data ={ "text" => "#{salary_category.name} -4000" }
        TransactionHandleService.new(data, user).perform
        expect(user.transactions.last.amount).to eq(4000.to_f)
      end

      it 'should create transaction with category_id' do
        service_with_income_data.perform
        expect(user.transactions.last.category_id).to eq(salary_category.id)
      end

      it 'should create transaction with negative amount' do
        service_with_expense_data.perform
        expect(user.transactions.last.amount).to eq(-4000.to_f)
      end

      it 'should return success status' do
        allow(I18n).to receive(:t).with("telegram.transactions.transaction_was_added") { 'success' }
        expect(service_with_income_data.perform).to eq('success')
      end
    end

    context "when user passed the wrong message for creating transaction" do
      let(:user) { create(:user) }
      let(:user_2) { create(:user) }
      let(:salary_category) { create(:category, name: "Salary", financial_type: 'income', user_id: user_2.id)  }

      let(:data) { { "text" => "Salaly 4000" } }
      let(:data_for_non_existing_category) { { "text" => "Salary 4000" } }
      let(:service) { TransactionHandleService.new(data, user)  }

      it 'should not create transaction for user' do
        expect{ service.perform }.to_not change(user.transactions, :count)
      end

      it 'should return fail status' do
        allow(I18n).to receive(:t).with("telegram.transactions.transaction_was_not_added") { 'fail' }
        expect(service.perform).to eq('fail')
      end

      it 'should return fail status' do
        service = TransactionHandleService.new(data_for_non_existing_category, user)
        allow(I18n).to receive(:t).with("telegram.transactions.transaction_was_not_added") { 'fail' }
        expect(service.perform).to eq('fail')
      end
    end
  end
end
