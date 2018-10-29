require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "validates" do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
  end

  context "relations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  context "scopes" do
    describe ".current_month" do
      let(:transaction1) { create(:transaction) }
      let(:transaction2) { create(:transaction) }
      let(:transaction3) { create(:transaction) }

      it 'should return only transactions which were created in current month' do
        time = Time.current
        transaction1
        travel_to time.beginning_of_month + 1.hours
        transaction3
        travel_to time - 1.months
        transaction2
        travel_back
        expect(Transaction.current_month).to eq([transaction1, transaction3])
      end
    end
  end
end
