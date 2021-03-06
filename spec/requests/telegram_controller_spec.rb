require 'rails_helper'

RSpec.describe TelegramController, telegram_bot: :rails do
  let(:user) { create(:user) }
  before do
    allow_any_instance_of(UserInitService).to receive(:perform) { user }
  end

  describe '#transactions' do
    it 'should build transactions list service' do
      expect(TransactionsListService).to receive(:new).with(user) { double(:perform => true) }
      dispatch_command :transactions
    end

    it 'should execute the transactions list service' do
      generator = double
      allow(TransactionsListService).to receive(:new) { generator }
      expect(generator).to receive(:perform)
      dispatch_command :transactions
    end

    it 'should return the list of transactions' do
      generator = double(:perform => "respond")
      allow(TransactionsListService).to receive(:new) { generator }
      expect { dispatch_command :transactions }.to respond_with_message("respond")
    end
  end

  describe '#delete_category' do
    context "user passed the name of existing category" do
      let(:category) { create(:category,:income, user: user) }
      let(:category_name) { category.name }

      it 'should return text about confirm the removing category' do
        text = "Type in 'yes' if you really want to delete that category."
        expect { dispatch_command :delete_category, category_name }.to respond_with_message(text)
      end

      context "user passed the word 'yes'" do
        before do
          dispatch_command :delete_category, category_name
        end

        it 'should delete category' do
          expect { dispatch_message 'yes' }.to change(user.categories, :count).from(1).to(0)
        end

        it 'should return positive response' do
          text = 'Category was deleted!'
          expect { dispatch_message 'yes' }.to respond_with_message(text)
        end
      end

      context "user didn't passed the word 'yes'" do
        before do
          dispatch_command :delete_category, category_name
        end

        it "shouldn't delete category" do
          expect { dispatch_message 'no' }.not_to change(user.categories, :count).from(1)
        end

        it 'should return positive response' do
          text = 'The deleting of category was cancelled.'
          expect { dispatch_message 'no' }.to respond_with_message(text)
        end
      end
    end

    context "user passed the invalid name" do
      let(:category_name) { 'name' }

      it 'should return text about confirm the removing category' do
        text = "Unfortunately we didn't find the category with that name."
        expect { dispatch_command :delete_category, category_name }.to respond_with_message(text)
      end
    end
  end

  describe "#website" do
    let(:resulting_link) { "[Your link](http://example.com/?token=token)"  }

    it 'call service of generating link' do
      expect(WebsiteLinkGenerateService).to receive(:perform).with(user.id) { resulting_link }
      dispatch_command :website
    end

    it 'should return link as a text' do
      expect(WebsiteLinkGenerateService).to receive(:perform).with(user.id) { resulting_link }
      expect { dispatch_command :website}.to respond_with_message(resulting_link)
    end
  end
end
