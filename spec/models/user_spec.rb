require 'rails_helper'

RSpec.describe User, type: :model do
  context "validates" do
    it { should validate_presence_of(:telegram_id) }
  end

  context "relations" do
    it { should have_many(:transactions) }
    it { should have_many(:categories) }
  end

  describe "#full_name" do
    let(:user) { build(:user, first_name: 'Ivan', last_name: "Denisov" ) }

    it 'should return full_name of user' do
      expect(user.full_name).to eq('Ivan Denisov')
    end
  end
end
