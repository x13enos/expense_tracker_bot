require 'rails_helper'

RSpec.describe User, type: :model do
  context "validates" do
    it { should validate_presence_of(:telegram_id) }
  end
end
