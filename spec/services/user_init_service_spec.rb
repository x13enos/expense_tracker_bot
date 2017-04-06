require 'rails_helper'

RSpec.describe UserInitService do
  describe "#perform" do
    let(:user_data) { { 'id' => '111', 'first_name' => 'Ivan', 'last_name' => 'Denisov' } }
    let(:service) { UserInitService.new(user_data)  }

    before do
      User.delete_all
    end

    it "should create user if he doesn't exist" do
      expect{ service.perform }.to change(User, :count).from(0).to(1)
    end

    it "should create user with passed params" do
      service.perform
      expect(User.last).to have_attributes(telegram_id: 111, first_name: 'Ivan', last_name: 'Denisov')
    end

    it "shouldn't create user if he was created" do
      User.create(telegram_id: '111')
      expect{ service.perform }.to_not change(User, :count)
    end
  end
end
