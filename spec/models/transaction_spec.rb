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

  describe ".search" do
    let!(:category) { create(:category) }
    let!(:transaction1) { create(:transaction, category: category, created_at: Time.now - 3.days) }
    let!(:transaction2) { create(:transaction, created_at: Time.now - 2.days) }
    let!(:transaction3) { create(:transaction, created_at: Time.now - 4.days) }

    it "should return only transaction connected to category" do
      expect(Transaction.search({ category_id: category.id })).to eq([transaction1])
    end

    it "should return only transaction created after passed day" do
      travel_to Time.now - (2.days + 2.hours)
      expect(Transaction.search({ start_date: DateTime.now })).to eq([transaction2])
      travel_back
    end

    it "should return only transaction created before passed day" do
      travel_to Time.now - (4.days - 2.hours)
      expect(Transaction.search({ end_date: DateTime.now })).to eq([transaction3])
      travel_back
    end
  end
end
