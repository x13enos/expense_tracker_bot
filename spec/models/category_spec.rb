require 'rails_helper'

RSpec.describe Category, type: :model do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:financial_type).in_array(Category::FINANCIAL_TYPES) }
  end
end
