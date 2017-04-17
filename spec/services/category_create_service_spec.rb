require 'rails_helper'

RSpec.describe CategoryCreateService do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:financial_type) { Category::FINANCIAL_TYPES.sample }

    before do
      Category.delete_all
    end

    context "when user passed the name" do
      let(:name) { ["Food"] }
      let(:service) { CategoryCreateService.new(user, name, financial_type) }
      let(:success_result) do
        {
          :status => :ok,
          :message=>"success"
        }
      end


      let(:fail_result) do
        {
          :status => :error,
          :message=>"recheck"
        }
      end

      it 'should return success result' do
        allow(I18n).to receive(:t).with("telegram.categories.new.was_added") { 'success' }
        expect(service.perform).to eq(success_result)
      end

      it 'shuld create new category for user' do
        expect{service.perform}.to change(user.categories, :count).from(0).to(1)
      end

      it 'should return error if user has the category with the same name' do
        allow(I18n).to receive(:t).with("telegram.categories.new.please_check_category_name", {:error=>"exist"}) { 'recheck' }
        allow(I18n).to receive(:t).with("telegram.categories.new.existing_name_of_category") { 'exist' }
        create(:category, :income, user: user, name: 'Food')
        expect(service.perform).to eq(fail_result)
      end
    end

    context "when user didn't fill the name" do
      let(:name) { [] }
      let(:service) { CategoryCreateService.new(user, name, financial_type) }
      let(:fail_result) do
        {
          :status => :error,
          :message=>"recheck"
        }
      end

      it 'should return markup for filling the category name' do
        allow(I18n).to receive(:t).with("telegram.categories.new.please_check_category_name", {:error=>"blank"}) { 'recheck' }
        allow(I18n).to receive(:t).with("telegram.categories.new.blank_name") { 'blank' }
        expect(service.perform).to eq(fail_result)
      end
    end
  end
end
