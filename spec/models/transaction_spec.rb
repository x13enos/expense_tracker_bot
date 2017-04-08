require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "validates" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:category_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
  end

  context "relations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end
end
