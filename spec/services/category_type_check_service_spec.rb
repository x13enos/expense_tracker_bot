require 'rails_helper'

RSpec.describe CategoryTypeCheckService do
  describe "#perform" do
    let(:user) { create(:user) }

    context "when user select one of the financial type" do
      let(:financial_type) { Category::FINANCIAL_TYPES.sample }
      let(:service) { CategoryTypeCheckService.new([financial_type], {}) }
      let(:success_result) do
        { markup:
          { text: "success" },
          context_handler: :new_category_name!
        }
      end

      it 'should return markup for filling the category name' do
        allow(I18n).to receive(:t).with("telegram.categories.new.fill_the_name") { 'success' }
        expect(service.perform).to eq(success_result)
      end

      it 'should write the category type to session' do
        service.perform
        expect(service.user_session[:category_type]).to eq(financial_type)
      end
    end

    context "when user select the wrong category type" do
      let(:financial_type) { "WRONG_TYPE" }
      let(:service) { CategoryTypeCheckService.new([financial_type], {}) }
      let(:fail_result) do
        { markup:
          { text: "fail", reply_markup: { keyboard: ["types"], one_time_keyboard: true}},
          context_handler: :new_category_type!
        }
      end

      it 'should return markup for filling the category name' do
        allow(I18n).to receive(:t).with("telegram.categories.new.wrong_type") { 'fail' }
        allow(I18n).to receive(:t).with("telegram.categories.types") { 'types' }
        expect(service.perform).to eq(fail_result)
      end

      it 'should not write the category type to session' do
        service.perform
        expect(service.user_session[:category_type]).to be_nil
      end
    end
  end
end
