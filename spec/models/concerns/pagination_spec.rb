require 'rails_helper'

RSpec.describe "pagination concern" do

  %w(transaction).each do |class_name|

    let(:class_const) { class_name.capitalize.constantize }

    describe ".item_limits" do
      it "should return defualt value if it doesn't set in the class" do
        expect(class_const.item_limits).to eq(class_const::DEFAULT_LIMIT)
      end
    end

    describe ".page_count" do
      it "should return rounded up value" do
        11.times{ create(class_name.to_sym) }
        expect(class_const.page_count).to eq(2)
      end
    end

    describe ".paginate" do
      it "should return only 5 items" do
        15.times{ create(class_name.to_sym) }
        expect(class_const.paginate(2).count).to eq(5)
      end
    end
  end

end
