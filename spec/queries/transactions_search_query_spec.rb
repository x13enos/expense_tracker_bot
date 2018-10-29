require 'rails_helper'

RSpec.describe TransactionsSearchQuery do

  describe "#all" do
    let!(:category) { create(:category) }
    let!(:transaction1) { create(:transaction, category: category, created_at: Time.now - 3.days) }
    let!(:transaction2) { create(:transaction, created_at: Time.now - 2.days) }
    let!(:transaction3) { create(:transaction, created_at: Time.now - 4.days) }

    it "should return only transaction connected to category" do
      searcher = TransactionsSearchQuery.new(Transaction.all, { category_id: category.id })
      expect(searcher.all).to eq([transaction1])
    end

    it "should return only transaction created after passed day" do
      travel_to Time.now - (2.days + 2.hours)
      searcher = TransactionsSearchQuery.new(Transaction.all, { start_date: DateTime.now })
      expect(searcher.all).to eq([transaction2])
      travel_back
    end

    it "should return only transaction created before passed day" do
      travel_to Time.now - (4.days - 2.hours)
      searcher = TransactionsSearchQuery.new(Transaction.all, { end_date: DateTime.now })
      expect(searcher.all).to eq([transaction3])
      travel_back
    end
  end

end
