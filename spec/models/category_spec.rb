require 'rails_helper'

RSpec.describe Category, type: :model do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
    it { should validate_inclusion_of(:financial_type).in_array(Category::FINANCIAL_TYPES) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
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
end
