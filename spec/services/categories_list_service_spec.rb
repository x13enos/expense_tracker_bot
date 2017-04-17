require 'rails_helper'

RSpec.describe CategoriesListService do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:service) { CategoriesListService.new(user) }

    before do
      Category.delete_all
    end

    context "user has the categories" do
      let(:income_category) { create(:category, :income, user: user, name: "Salary")  }
      let(:expense_category) { create(:category, :expense, user: user, name: "Food")  }
      let(:expense_category_2) { create(:category, :expense, user: user, name: "Food1")  }

      it 'should return list of categories that separated on income and expense sections'  do
        income_category
        expense_category
        expense_category_2
        expect(service.perform).to eq("*Incomes:*\nSalary\n\n*Expenses:*\nFood\nFood1")
      end

      it 'should return list of categories only with "income" financial type'  do
        income_category
        expect(service.perform).to eq("*Incomes:*\nSalary")
      end

      it 'should return list of categories only with "expense" financial type'  do
        expense_category
        expense_category_2
        expect(service.perform).to eq("*Expenses:*\nFood\nFood1")
      end
    end

    context "user has not the categories" do
      it 'should return message of non-existing categories for current user'  do
        allow(I18n).to receive(:t).with('telegram.categories.you_do_not_have_categories') { 'warning' }
        expect(service.perform).to eq("warning")
      end
    end
  end
end
