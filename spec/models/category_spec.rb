require 'rails_helper'

RSpec.describe Category, type: :model do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
    it { should validate_inclusion_of(:financial_type).in_array(Category::FINANCIAL_TYPES) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should validate_exclusion_of(:name).in_array(I18n.t('telegram.categories.types')) }
  end

  context "relations" do
    it { should have_many(:transactions) }
    it { should belong_to(:user) }
  end

  context "scopes" do
    before do
      Category.delete_all
    end

    describe ".income" do
      let(:user) { create(:user) }
      let!(:category_1) { create(:category, :income, :user => user)  }
      let!(:category_2) { create(:category, :expense, :user => user)  }
      let!(:category_3) { create(:category, :income, :user => user)  }

      it 'should return only income categories' do
        expect(Category.income).to eq([category_1, category_3])
      end
    end

    describe ".expense" do
      let(:user) { create(:user) }
      let!(:category_1) { create(:category, :income, :user => user)  }
      let!(:category_2) { create(:category, :expense, :user => user)  }
      let!(:category_3) { create(:category, :expense, :user => user)  }

      it 'should return only expense categories' do
        expect(Category.expense).to eq([category_2, category_3])
      end
    end
  end

  context "#expense?" do
    let(:income_category) { create(:category, :income)  }
    let(:expense_category) { create(:category, :expense)  }

    it 'should return true if category has expense financial type' do
      expect(expense_category.expense?).to be_truthy
    end

    it "should return false if category doesn't have expense financial type" do
      expect(income_category.expense?).to be_falsey
    end
  end

end
